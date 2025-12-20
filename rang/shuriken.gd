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
@onready var mesh := $ShurikenMesh
var level : Node3D
var cotu: Node3D
var icon: Node3D
var target: Node3D

# --- Mesh Rotation Parameters ---
@export var min_spin_speed := 4.0 
@export var max_spin_speed := 30.0 
var current_spin_speed: float = 0.0
# --------------------------------

@export var orbit_radius := 1.2
@export var orbit_speed := 4.0
var orbit_angle := 0.0

@export var spinup_duration := 0.4
var spinup_time := 0.0
@export var approach_speed := 40.0

var approach_target_pos := Vector3.ZERO

# --- Rose Curve Variables ---
@export var time_per_slash := 2.0 
var slash_time := 0.0 
@export var slash_radius_h := 4.5 
@export var slash_radius_v := 3.0 

@export var total_slashes := 3
var total_slash_duration: float 

# --- Randomization Variables ---
var random_angle_offset := 0.0 
var random_tilt_amount_deg := 0.0
# Determines if the curve is traversed clockwise (1.0) or counter-clockwise (-1.0)
var path_direction := 1.0 
# -------------------------------

@export var recall_speed := 40.0

var initial_rotation: Basis 

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	icon = level.find_child("Icon")
	
	hitbox.damage = Globals.player_hitbox_data.ShurikenBaseDamage
	current_spin_speed = min_spin_speed 

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
	
	mesh.rotate_y(current_spin_speed * delta)

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
	current_spin_speed = min_spin_speed

# -------------------------------------------------
# SPINUP
# -------------------------------------------------
func spinup_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	spinup_time += delta
	look_at(target.global_position)

	var t = min(spinup_time / spinup_duration, 1.0)
	current_spin_speed = lerp(min_spin_speed, max_spin_speed, t)

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
	
	current_spin_speed = max_spin_speed

	look_at(target.global_position)

	if global_position.distance_to(approach_target_pos) < 0.1:
		switch_to_slash()

func switch_to_approach():
	if not is_instance_valid(target):
		switch_to_recall()
		return
	
	# --- Generate Random Path Parameters ---
	random_angle_offset = randf_range(0.0, TAU)
	random_tilt_amount_deg = randf_range(-30.0, 30.0)
	
	# Randomize direction: 50% chance for 1.0, 50% chance for -1.0
	path_direction = 1.0 if randf() > 0.5 else -1.0
	# ---------------------------------------
		
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
	
	current_spin_speed = max_spin_speed
	
	if slash_time >= total_slash_duration:
		switch_to_recall()
		return
	
	var current_slash_index = int(slash_time / time_per_slash)
	var t_cycle = fmod(slash_time, time_per_slash) / time_per_slash
	var envelope = sin(t_cycle * PI)
	
	# Base Curve Calculation
	# Multiply theta by path_direction to control clockwise vs counter-clockwise movement
	var theta = t_cycle * 2.0 * PI * path_direction
	
	var local_x = envelope * slash_radius_h * cos(theta)
	var local_y = envelope * slash_radius_v * sin(theta)
	var local_z = envelope * cos(theta) * slash_radius_h * 0.1 
	
	# Petal Rotation
	var petal_angle = (current_slash_index * (2.0 * PI / float(total_slashes))) + random_angle_offset
	
	# Apply 2D rotation
	var final_x = local_x * cos(petal_angle) - local_y * sin(petal_angle)
	var final_y = local_x * sin(petal_angle) + local_y * cos(petal_angle)
	
	# Transform to world space
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
	
	# 1. Calculate standard orientation facing the target
	var forward_dir = (target.global_position - global_position).normalized()
	var right_dir = forward_dir.cross(Vector3.UP).normalized()
	if right_dir == Vector3.ZERO:
		right_dir = forward_dir.cross(Vector3.FORWARD).normalized()
	var up_dir = right_dir.cross(forward_dir).normalized()
	
	initial_rotation = Basis(right_dir, up_dir, forward_dir)

	# 2. Apply Random Plane Tilt
	var tilt_quat = Quaternion(forward_dir, deg_to_rad(random_tilt_amount_deg))
	initial_rotation = Basis(tilt_quat) * initial_rotation
	
	# Snap to starting position
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
	
	current_spin_speed = max_spin_speed

	if global_position.distance_to(icon.global_position) < 0.3:
		switch_to_orbit()

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# External API
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	if state == State.ORBIT:
		switch_to_spinup(new_target)
