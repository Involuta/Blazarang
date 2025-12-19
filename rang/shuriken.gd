extends Node3D

enum State {
	ORBIT,
	SPINUP,
	APPROACH,
	SLASH,
	RECALL
}

var state: State = State.ORBIT

@onready var root := $/root/ViewControl
@onready var hitbox := $PlayerHitbox
@onready var mesh := $MeshInstance3D
var level : Node3D
var cotu: Node3D
var icon: Node3D
var target: Node3D

@export var orbit_radius := 1.2
@export var orbit_speed := 4.0
var orbit_angle := 0.0

@export var spinup_duration := 0.4
var spinup_time := 0.0
@export var approach_speed := 40.0

var approach_target_pos := Vector3.ZERO

# --- Rose Curve Variables ---
@export var time_per_slash := 1.0 # How long a single "in-and-out" slash takes
var slash_time := 0.0  # Total time tracker for the entire slash sequence
@export var slash_radius_h := 4.5  # Max horizontal offset distance
@export var slash_radius_v := 3.0  # Max vertical offset distance
@export var slash_freq_h := 3.0  # Frequency multiplier for horizontal (Rose curve 'k')
@export var slash_freq_v := 2.0  # Frequency multiplier for vertical

# --- MULTIPLE SLASH PARAMETERS ---
@export var total_slashes := 3 # The total number of full "in-and-out" slashes before recalling
var total_slash_duration: float # Calculated total time: total_slashes * time_per_slash
# -------------------------------------------

@export var recall_speed := 40.0

var initial_rotation: Basis # Store initial rotation for consistent curve orientation

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	icon = level.find_child("Icon")
	
	hitbox.damage = Globals.player_hitbox_data.ShurikenBaseDamage

# -------------------------------------------------
# Core loop
# -------------------------------------------------
func _physics_process(delta):
	match state:
		State.ORBIT:
			orbit_frame(delta)
		State.SPINUP:
			spinup_frame(delta)
		State.APPROACH:
			approach_frame(delta)
		State.SLASH:
			slash_frame(delta)
		State.RECALL:
			recall_frame(delta)
	mesh.rotate_y(4 * delta)

# -------------------------------------------------
# ORBIT (Unchanged)
# -------------------------------------------------
func orbit_frame(delta):
	orbit_angle += orbit_speed * delta
	global_position = icon.global_position + Vector3(
		cos(orbit_angle),
		0,
		sin(orbit_angle)
	) * orbit_radius

func switch_to_orbit():
	state = State.ORBIT
	target = null

# -------------------------------------------------
# SPINUP (Unchanged)
# -------------------------------------------------
func spinup_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	spinup_time += delta
	look_at(target.global_position)

	if spinup_time >= spinup_duration:
		switch_to_approach()

func switch_to_spinup(new_target: Node3D):
	target = new_target
	spinup_time = 0.0
	state = State.SPINUP

# -------------------------------------------------
# APPROACH (Modified for better staging)
# -------------------------------------------------
func approach_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	global_position = global_position.move_toward(
		approach_target_pos,
		approach_speed * delta
	)

	look_at(target.global_position)

	# The `approach_target_pos` is now the **starting point** of the slash curve
	if global_position.distance_to(approach_target_pos) < 0.1:
		switch_to_slash()

func switch_to_approach():
	if not is_instance_valid(target):
		switch_to_recall()
		return
		
	# Stage a bit away from the target to start the curve
	var direction_to_target = (target.global_position - global_position).normalized()
	approach_target_pos = target.global_position - direction_to_target * slash_radius_h * 1.5

	state = State.APPROACH

# -------------------------------------------------
# SLASH (Modified to use total duration)
# -------------------------------------------------
func slash_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	slash_time += delta
	
	# Check if the entire slash sequence is complete
	if slash_time >= total_slash_duration:
		switch_to_recall()
		return
	
	# T_cycle: Normalized time from 0 to 1 for a SINGLE slash cycle
	# This repeats 'total_slashes' times over the total duration.
	var t_cycle = fmod(slash_time, time_per_slash) / time_per_slash

	# Envelope: ensures the shuriken goes in and out of the center.
	# It uses t_cycle to ensure it completes one full in-and-out motion per slash.
	var envelope = sin(t_cycle * PI)
	
	# Lateral/Horizontal Offset (X-axis in local space)
	# The curve frequency determines the SHAPE of the slash, not the count.
	var x_offset = envelope * slash_radius_h * cos(t_cycle * 2.0 * PI * slash_freq_h)
	
	# Vertical Offset (Y-axis in local space)
	var y_offset = envelope * slash_radius_v * sin(t_cycle * 2.0 * PI * slash_freq_v)
	
	# Forward Offset (Z-axis in local space) - Optional, slightly reduced.
	# Note: We use t_cycle here to make the forward motion also loop per slash.
	var z_offset = envelope * cos(t_cycle * 2.0 * PI * 1.0) * slash_radius_h * 0.1
	
	# Create the local offset vector
	var local_offset = Vector3(x_offset, y_offset, z_offset)

	# Apply the initial rotation to transform the local offset into world space (Godot 4.x)
	var world_offset = initial_rotation * local_offset
	
	# Update position
	global_position = target.global_position + world_offset
	
	# Continuously look at the target
	look_at(target.global_position)

func switch_to_slash():
	if not is_instance_valid(target):
		switch_to_recall()
		return

	# --- MODIFIED: Calculate total duration ---
	total_slash_duration = total_slashes * time_per_slash
	slash_time = 0.0
	# ------------------------------------------
	
	# Determine the orientation of the curve's plane (Unchanged)
	var forward_dir = (target.global_position - global_position).normalized()
	var right_dir = forward_dir.cross(Vector3.UP).normalized()
	if right_dir == Vector3.ZERO:
		right_dir = forward_dir.cross(Vector3.FORWARD).normalized()
	var up_dir = right_dir.cross(forward_dir).normalized()
	
	initial_rotation = Basis(right_dir, up_dir, forward_dir)
	
	# Immediately snap to the starting position (target's position + initial curve offset)
	# We snap to the starting point of the first slash cycle (t_cycle=0)
	var start_offset_local = Vector3(0, 0, 0) # Start at the target's center for the first slash
	global_position = target.global_position + initial_rotation * start_offset_local

	state = State.SLASH

# -------------------------------------------------
# RECALL (Unchanged)
# -------------------------------------------------
func recall_frame(delta):
	global_position = global_position.move_toward(
		icon.global_position,
		recall_speed * delta
	)
	look_at(icon.global_position) # Look back towards the icon

	if global_position.distance_to(icon.global_position) < 0.3:
		switch_to_orbit()

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# External API (Unchanged)
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	switch_to_spinup(new_target)
