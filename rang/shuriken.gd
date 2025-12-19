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
@export var time_per_slash := 1.0 # Duration of a single petal loop
var slash_time := 0.0 
@export var slash_radius_h := 4.5 # Max horizontal offset
@export var slash_radius_v := 3.0 # Max vertical offset

@export var total_slashes := 3 # Number of petals in the rose pattern (number of hits + 1, because the first hit doesn't come from a slash but from the initial approach)
var total_slash_duration: float 

@export var recall_speed := 40.0

var initial_rotation: Basis 

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
# ORBIT
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
# SPINUP
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
# APPROACH
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

	# Transition to slash when close to the start point
	if global_position.distance_to(approach_target_pos) < 0.1:
		switch_to_slash()

func switch_to_approach():
	if not is_instance_valid(target):
		switch_to_recall()
		return
		
	# Target a position offset from the enemy to seamlessly begin the curve
	var direction_to_target = (target.global_position - global_position).normalized()
	approach_target_pos = target.global_position - direction_to_target * slash_radius_h * 1.5

	state = State.APPROACH

# -------------------------------------------------
# SLASH
# -------------------------------------------------
func slash_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	slash_time += delta
	
	if slash_time >= total_slash_duration:
		switch_to_recall()
		return
	
	# Determine which slash in the sequence is currently active
	var current_slash_index = int(slash_time / time_per_slash)

	# Normalized time (0.0 to 1.0) for the current slash cycle
	var t_cycle = fmod(slash_time, time_per_slash) / time_per_slash

	# Envelope: Moves the shuriken Out and back In (0 -> 1 -> 0)
	var envelope = sin(t_cycle * PI)
	
	# Base Curve Calculation (Standard Oval on the plane)
	var theta = t_cycle * 2.0 * PI
	
	var local_x = envelope * slash_radius_h * cos(theta)
	var local_y = envelope * slash_radius_v * sin(theta)
	var local_z = envelope * cos(theta) * slash_radius_h * 0.1 
	
	# Petal Rotation: Rotate the loop based on the current slash index
	# This distributes the slashes evenly around the circle
	var petal_angle = current_slash_index * (2.0 * PI / float(total_slashes))
	
	# Apply 2D rotation to the offset to create the rose pattern
	var final_x = local_x * cos(petal_angle) - local_y * sin(petal_angle)
	var final_y = local_x * sin(petal_angle) + local_y * cos(petal_angle)
	
	# Transform the calculated offset to world space
	var local_offset = Vector3(final_x, final_y, local_z)
	var world_offset = initial_rotation * local_offset
	
	global_position = target.global_position + world_offset
	look_at(target.global_position)

func switch_to_slash():
	if not is_instance_valid(target):
		switch_to_recall()
		return

	total_slash_duration = total_slashes * time_per_slash
	slash_time = 0.0
	
	# orient the plane of the curve to face the target
	var forward_dir = (target.global_position - global_position).normalized()
	var right_dir = forward_dir.cross(Vector3.UP).normalized()
	if right_dir == Vector3.ZERO:
		right_dir = forward_dir.cross(Vector3.FORWARD).normalized()
	var up_dir = right_dir.cross(forward_dir).normalized()
	
	initial_rotation = Basis(right_dir, up_dir, forward_dir)
	
	# Snap to the starting position of the first slash cycle
	var start_offset_local = Vector3(0, 0, 0)
	global_position = target.global_position + initial_rotation * start_offset_local

	state = State.SLASH

# -------------------------------------------------
# RECALL
# -------------------------------------------------
func recall_frame(delta):
	global_position = global_position.move_toward(
		icon.global_position,
		recall_speed * delta
	)
	look_at(icon.global_position)

	if global_position.distance_to(icon.global_position) < 0.3:
		switch_to_orbit()

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# External API
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	switch_to_spinup(new_target)
