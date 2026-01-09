extends Node3D

signal destroyed(shuriken_node)

enum State {
	ORBIT,
	SPINUP,
	APPROACH,
	SLASH,
	FRENZY,
	RECALL,
	EXPLODE
}

var state: State = State.ORBIT

@onready var root := $/root/ViewControl
@onready var hitbox := $PlayerHitbox
@onready var explosion_hitbox := $ExplosionPivot/PlayerHitbox
@onready var mesh := $ShurikenMesh
@onready var explosion_particles := $ExplosionParticles
var level : Node3D
var cotu: Node3D
var icon: Node3D
var target: Node3D

var shuriken_self_destruction := false # TRUE = Explode, FALSE = Recall

# --- Mesh Rotation Parameters ---
@export var min_spin_speed := 4.0 
@export var max_spin_speed := 30.0 
var current_spin_speed: float = 0.0

@export var orbit_radius := 1.2
@export var orbit_speed := 4.0
var orbit_angle := 0.0

# --- Spinup / Launch Parameters ---
@export var spinup_duration := 0.6 
@export var spinup_launch_speed := 12.0
@export var spinup_decel_time := 0.4 # Time to slow to a halt (must be < spinup_duration for full stop)
var spinup_time := 0.0
var current_spinup_velocity := Vector3.ZERO

@export var approach_speed := 40.0
var approach_target_pos := Vector3.ZERO

# --- Rose Curve Variables ---
@export var slash_path_speed := 15.0 
var time_per_slash := 1.0
var slash_time := 0.0

@export var slash_radius_h := 4.0
@export var slash_radius_v := 2.0

# --- Slash Counts (Set by CotuControl.gd via configure_slashes ---
var base_slashes := 3          # Default number of slashes
var marked_slashes_bonus := 0  # Extra slashes if target is marked and Cotu has marked slash bonuses
var actual_total_slashes := 0  # Calculated at runtime
# --------------------------

# --- Randomization Variables ---
var random_angle_offset := 0.0
var random_tilt_amount_deg := 0.0
var path_direction := 1.0

# --- Frenzy Variables ---
@export var frenzy_duration := 4.0 # How long the frenzy lasts
@export var frenzy_path_speed := 45.0 # Speed of the slash path during frenzy
var frenzy_time_remaining := 0.0
var time_per_frenzy_slash := 1.0

@export var recall_speed := 40.0
@export var explode_secs := 0.5 

# PMD = pre-multiplier damage
var damage_multiplier := 0.0 # Each hitbox's damage is pre multiplier damage * (1 + damage_multiplier)
var main_hitbox_pmd := 0.0
var explosion_hitbox_pmd := 0.0

var initial_rotation: Basis

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	icon = level.find_child("Icon")
	
	main_hitbox_pmd = Globals.player_hitbox_data.ShurikenBaseDamage
	explosion_hitbox_pmd = main_hitbox_pmd * 2
	update_hitbox_damage()
	explosion_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	current_spin_speed = min_spin_speed

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
		State.FRENZY:
			frenzy_frame(delta)
		State.RECALL:
			recall_frame(delta)
		State.EXPLODE:
			explode_frame(delta)
	
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
	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED:
		switch_to_recall()
		return

	spinup_time += delta
	
	if spinup_decel_time > 0.0:
		global_position += current_spinup_velocity * delta
		var friction = (spinup_launch_speed / spinup_decel_time) * delta
		current_spinup_velocity = current_spinup_velocity.move_toward(Vector3.ZERO, friction)

	look_at(target.global_position)

	var t = min(spinup_time / spinup_duration, 1.0)
	current_spin_speed = lerp(min_spin_speed, max_spin_speed, t)

	if spinup_time >= spinup_duration:
		switch_to_approach()

func switch_to_spinup(new_target: Node3D):
	target = new_target
	spinup_time = 0.0
	state = State.SPINUP
	
	var outward_dir = (global_position - icon.global_position)
	outward_dir.y = 0 
	outward_dir = outward_dir.normalized()
	var launch_dir = (outward_dir + Vector3.UP).normalized()
	current_spinup_velocity = launch_dir * spinup_launch_speed

# -------------------------------------------------
# APPROACH
# -------------------------------------------------
func approach_frame(delta):
	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED:
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
	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED:
		switch_to_recall()
		return
	
	random_angle_offset = randf_range(0.0, TAU)
	random_tilt_amount_deg = randf_range(-30.0, 30.0)
	path_direction = 1.0 if randf() > 0.5 else -1.0
	
	var direction_to_target = (target.global_position - global_position).normalized()
	approach_target_pos = target.global_position - direction_to_target * slash_radius_h * 1.5

	state = State.APPROACH

# -------------------------------------------------
# SLASH
# -------------------------------------------------
func slash_frame(delta):
	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED:
		if shuriken_self_destruction:
			switch_to_explode()
		else:
			switch_to_recall()
		return

	slash_time += delta
	current_spin_speed = max_spin_speed
	
	# Calculate total duration based on actual slash count (base + marked bonus)
	var total_duration = actual_total_slashes * time_per_slash
	
	if slash_time >= total_duration:
		if shuriken_self_destruction:
			switch_to_explode()
		else:
			switch_to_recall()
		return
	
	var current_slash_index = int(slash_time / time_per_slash)
	var t_cycle = fmod(slash_time, time_per_slash) / time_per_slash
	var envelope = sin(t_cycle * PI)
	
	var theta = t_cycle * 2.0 * PI * path_direction
	
	var local_x = envelope * slash_radius_h * cos(theta)
	var local_y = envelope * slash_radius_v * sin(theta)
	var local_z = envelope * cos(theta) * slash_radius_h * 0.1
	
	var petal_angle = (current_slash_index * (2.0 * PI / float(max(1, actual_total_slashes)))) + random_angle_offset
	
	var final_x = local_x * cos(petal_angle) - local_y * sin(petal_angle)
	var final_y = local_x * sin(petal_angle) + local_y * cos(petal_angle)
	
	var local_offset = Vector3(final_x, final_y, local_z)
	var world_offset = initial_rotation * local_offset
	
	global_position = target.global_position + world_offset
	look_at(target.global_position)

func switch_to_slash():
	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED:
		switch_to_recall()
		return
	
	# Determine actual slashes. 
	# Note: Cotu calls configure_slashes() before this happens, 
	# setting marked_slashes_bonus appropriately.
	actual_total_slashes = base_slashes + marked_slashes_bonus
	
	var avg_radius = (slash_radius_h + slash_radius_v) / 2.0
	var approx_path_length = PI * avg_radius
	
	if slash_path_speed <= 0.01:
		slash_path_speed = 0.01
	time_per_slash = approx_path_length / slash_path_speed
	
	slash_time = 0.0
	
	var forward_dir = (target.global_position - global_position).normalized()
	var right_dir = forward_dir.cross(Vector3.UP).normalized()
	if right_dir == Vector3.ZERO:
		right_dir = forward_dir.cross(Vector3.FORWARD).normalized()
	var up_dir = right_dir.cross(forward_dir).normalized()
	
	initial_rotation = Basis(right_dir, up_dir, forward_dir)

	var tilt_quat = Quaternion(forward_dir, deg_to_rad(random_tilt_amount_deg))
	initial_rotation = Basis(tilt_quat) * initial_rotation
	
	global_position = target.global_position
	state = State.SLASH

func frenzy_frame(delta):
	frenzy_time_remaining -= delta

	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED \
	or frenzy_time_remaining <= 0.0: 
		
		if is_instance_valid(target) and target.process_mode != Node.PROCESS_MODE_DISABLED:
			# If time is up, transition back to the normal slash state
			switch_to_slash()
		else:
			# Target lost
			if shuriken_self_destruction:
				switch_to_explode()
			else:
				switch_to_recall()
		return

	slash_time += delta 
	current_spin_speed = max_spin_speed
	
	# Frenzy slashes are infinite, but we still need a cycle index for the petal angle
	# We use a static divisor (e.g., 4) since the number of slashes is infinite/arbitrary
	var num_cycles_for_petal_angle = 4.0 
	var current_slash_index = int(slash_time / time_per_frenzy_slash)
	var t_cycle = fmod(slash_time, time_per_frenzy_slash) / time_per_frenzy_slash
	var envelope = sin(t_cycle * PI)
	
	var theta = t_cycle * 2.0 * PI * path_direction
	
	var local_x = envelope * slash_radius_h * cos(theta)
	var local_y = envelope * slash_radius_v * sin(theta)
	var local_z = envelope * cos(theta) * slash_radius_h * 0.1
	
	# Use the randomization offset when calculating the petal angle
	var petal_angle = (current_slash_index * (2.0 * PI / num_cycles_for_petal_angle)) + random_angle_offset
	
	var final_x = local_x * cos(petal_angle) - local_y * sin(petal_angle)
	var final_y = local_x * sin(petal_angle) + local_y * cos(petal_angle)
	
	var local_offset = Vector3(final_x, final_y, local_z)
	var world_offset = initial_rotation * local_offset
	
	global_position = target.global_position + world_offset
	look_at(target.global_position)

func switch_to_frenzy():
	if not is_instance_valid(target) \
	or target.process_mode == Node.PROCESS_MODE_DISABLED:
		return
	
	state = State.FRENZY
	frenzy_time_remaining = frenzy_duration
	slash_time = 0.0 
	
	# --- MODIFICATION START ---
	# Ensure randomization variables are correctly initialized when entering frenzy 
	# (They should have been initialized in switch_to_approach, but re-initializing them 
	# here ensures they are set if the shuriken enters frenzy from another state)
	random_angle_offset = randf_range(0.0, TAU)
	random_tilt_amount_deg = randf_range(-30.0, 30.0)
	path_direction = 1.0 if randf() > 0.5 else -1.0
	# --- MODIFICATION END ---
	
	var avg_radius = (slash_radius_h + slash_radius_v) / 2.0
	var approx_path_length = PI * avg_radius
	
	if frenzy_path_speed <= 0.01:
		frenzy_path_speed = 0.01
	time_per_frenzy_slash = approx_path_length / frenzy_path_speed
	
	# Recalculate Initial Rotation using the randomized tilt
	var forward_dir = (target.global_position - global_position).normalized()
	var right_dir = forward_dir.cross(Vector3.UP).normalized()
	if right_dir == Vector3.ZERO:
		right_dir = forward_dir.cross(Vector3.FORWARD).normalized()
	var up_dir = right_dir.cross(forward_dir).normalized()
	
	initial_rotation = Basis(right_dir, up_dir, forward_dir)

	# --- Using the randomized tilt ---
	var tilt_quat = Quaternion(forward_dir, deg_to_rad(random_tilt_amount_deg))
	initial_rotation = Basis(tilt_quat) * initial_rotation
	
	global_position = target.global_position

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
		destroy_self()

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# EXPLODE
# -------------------------------------------------

func explode_frame(_delta):
	pass

func switch_to_explode():
	state = State.EXPLODE
	explosion_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	mesh.visible = false
	explosion_particles.emitting = true
	await get_tree().create_timer(explode_secs).timeout
	if is_instance_valid(self):
		destroy_self()

# -------------------------------------------------
# External API
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	if state == State.ORBIT:
		switch_to_spinup(new_target)

func configure(base: int, marked_bonus: int, should_self_destruct: bool):
	base_slashes = base
	marked_slashes_bonus = marked_bonus
	shuriken_self_destruction = should_self_destruct

func destroy_self():
	destroyed.emit(self)
	queue_free()

func update_hitbox_damage():
	# If damage is boosted by 25%, damage_multiplier is .25, dm is 1.25
	var dm = 1 + damage_multiplier
	hitbox.damage = main_hitbox_pmd * dm
	explosion_hitbox.damage = explosion_hitbox_pmd * dm

func apply_damage_multiplier(mult: float):
	# Multipliers accumulate multiplicatively
	damage_multiplier *= 1 + mult
	update_hitbox_damage()
