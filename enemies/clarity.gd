extends CharacterBody3D

@export var entity_name := "Clarity" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

enum {
	STRAIGHT,
	CURVED,
	CIRCLING,
	SPECIAL,
}
var behav_state := STRAIGHT
var attacking := false # Set to true when attacking to prevent another attack from being queued

enum LOOK_STATE {
	DIR,
	TARGET_HEAD, # Used when Clarity stops aiming at target while attacking but still looks at target with her head
	TARGET_HEAD_ARM, # Used when Clarity's traveling in a direction but her head and arm still look at the target. May not be used ever since arm becomes offset from body
	TARGET_HEAD_ARM_BODY, # Used when Clarity's circling around target
	TARGET_BODY_FULL_ROTATION # Used when Clarity's body rotates toward target on all axes, not just y. Used when she becomes a gun/cannon
}
var look_state := LOOK_STATE.DIR

enum DIST_TYPE {
	SHORT_DIST,
	LONG_DIST
}
@export var phase1_min_long_dist_wait := .5
@export var phase1_max_long_dist_wait := 2.5
@export var phase2_min_long_dist_wait := .2
@export var phase2_max_long_dist_wait := 1
var min_long_dist_wait := .5
var max_long_dist_wait := 2.5
var long_dist_wait_remaining := 2.5
var attack_queued := false
signal no_attack_queued

enum PHASE {
	PHASE1,
	PHASE2,
}
var phase := PHASE.PHASE1

@export var min_y_pos := 11.4 # y pos of arena floor, ie X's minimum y position

var stationary := false
@export var walk_speed := 2.0
var walk_dir := Vector3.FORWARD # Randomly set when switching to walk straight
@export var walk_curved_radius := 9.0 # Radius of circle Clarity walks on

@export var head_turn_speed := .2
@export var body_turn_speed := .09

# Distance in front of herself Clarity looks in order to match anim head looking forward
@export var look_forward_dist := 12.0

@export var follow_speed := 1.5
@export var follow_time_before_parry := .1 # Min time necessary to spend in follow state before parry is possible
var current_follow_time := 0.0 # Reset after attack or parry is queued
@export var parry_angle_tolerance := PI/5 # Max y angle difference btwn vec from Cotu to Clarity and player camera fwd vec that triggers Clarity to parry
@export var parry_proximity := 1.5 # Max dist btwn Clarity and rose/ax to trigger parry
var rose_thrown := false # Set to true when Cotu throws non-special roserang while Clarity is following. Set to false when parry ends (end_parry). Why isn't this set to false every frame where a rose throw doesn't happen? Because the anim tree parry transition expressions need to read rose_thrown as true to know parry anim to play, and that happens at least 1 frame after a parry is triggered via queue_parry
var ax_thrown := false # Set to true when Cotu throws non-special axrang while Clarity is following. Set to false when parry ends (end_parry) for the same reason as rose_thrown
var parried := false # Set to true after a parry, set to false after a non-parry
@export var follow_left_distance := 7.5

@export var follow_turn_speed := .05
@export var base_attack_turn_speed := .15
var attack_turn_speed := 0.15

var aiming_at_target := true

@export var phase1_straight_attack_chances = {
	"Stomp" : .75,
	"JumpShot" : .25
}

@export var phase1_curved_attack_chances = {
	"Stomp" : 1.0
}

@export var phase1_circling_attack_chances = {
	"DoubleSlice" : .34,
	"SingleShot" : .33,
	"Spiral" : .33,
}

@export var diagonal_dash_speed := 22.0
@export var dash_speed := 40.0
@export var dash_back_speed := 36.0
@export var side_teleport_dist_from_target := 7.5
@export var front_teleport_dist_from_target := 9.0
@export var slipnslice_speed := 20.0
@export var slipnslice_stop_dist := 1.0
@export var superman_fwd_speed := 20.0
@export var superman_up_speed := 5.0
@export var superman_down_speed := 7.0
@export var triangle_arm_angle := 36.0
@export var triangle_arm_dist := 90.0
@export var triangle_axkick_dist := 3.5
@export var flyingkick_speed := 200.0
@export var flyingkick_hit_frames := 10 # Put the # of frames that the hitbox is active in the animation here

var param_path_base := "parameters/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var transparent_mat := preload("res://textures/clear_tile.tres")
@onready var arm_anim_tree := $ArmAnimationTree # Controls arm attacks
@onready var body_anim_tree := $BodyAnimationTree # Controls walk anim
@onready var mhp := $MeleeHitboxPivot
@onready var arm_meshes := $ClarityArmMeshes
@onready var body_meshes := $ClarityBodyMeshes
@onready var head_bone := $ClarityBodyMeshes/Armature/Skeleton3D/Hat_2
@onready var head_mesh := $ClarityBodyMeshes/Armature/Skeleton3D/Hat_2/ClarityHead

@onready var root := $/root/ViewControl
var level : Node3D
var target : Node3D
var cotu : Node3D # Clarity only attacks the target; cotu is only referenced here to help Clarity calculate whether to parry when Cotu throws a roserang
var clarity_icon : Node3D

func _ready():
	add_to_group("lockonables")
	level = root.find_child("Level")
	target = level.find_child("Icon")
	cotu = level.find_child("cotuCB")
	clarity_icon = level.find_child("ClarityIcon")
	
	min_long_dist_wait = phase1_min_long_dist_wait
	max_long_dist_wait = phase1_max_long_dist_wait
	long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
	
	attack_turn_speed = base_attack_turn_speed
	
	arm_anim_tree.active = true
	body_anim_tree.active = true
	mhp.visible = false

func head_look_at_position(target_pos):
	# Head mesh isn't a child of head bone so it doesn't inherit rotation from head bone
	head_mesh.global_position = head_bone.global_position
	var old_head_rotation = head_mesh.rotation
	head_mesh.look_at(Vector3(target_pos.x, min_y_pos, target_pos.z), Vector3.UP, true)
	var head_target_rotation = head_mesh.rotation
	head_mesh.rotation = old_head_rotation
	head_mesh.rotation.y = lerp_angle(head_mesh.rotation.y, head_target_rotation.y, head_turn_speed)
	# Look down/up at the player. Not too low (i.e. angle can't be too high) so the head doesn't look straight down
	head_mesh.rotation.x = clampf(lerp_angle(head_mesh.rotation.x, head_target_rotation.x, head_turn_speed), .6, .96)

func arm_look_at_position(target_pos):
	var vec3_to_target := -global_position.direction_to(target_pos)
	arm_meshes.rotation.x = lerp_angle(arm_meshes.rotation.x, 0, head_turn_speed)
	arm_meshes.rotation.y = lerp_angle(arm_meshes.rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), head_turn_speed)
	arm_meshes.rotation.z = lerp_angle(arm_meshes.rotation.z, 0, head_turn_speed)

func body_look_in_direction(dir: Vector3):
	body_meshes.rotation.x = lerp_angle(body_meshes.rotation.x, 0, body_turn_speed)
	body_meshes.rotation.y = lerp_angle(body_meshes.rotation.y, PI + atan2(-dir.x, -dir.z), body_turn_speed)
	body_meshes.rotation.z = lerp_angle(body_meshes.rotation.z, 0, body_turn_speed)

func body_face_position_directly(target_pos):
	for m in [arm_meshes, body_meshes]:
		var old_rotation = m.rotation
		m.look_at(m.global_position + m.global_position.direction_to(target_pos), Vector3.UP, true)
		var target_rotation = m.rotation
		m.rotation = old_rotation
		m.rotation.x = lerp_angle(m.rotation.x, target_rotation.x, body_turn_speed / 2.1)
		m.rotation.y = lerp_angle(m.rotation.y, target_rotation.y, body_turn_speed / 2.1)
		m.rotation.z = lerp_angle(m.rotation.z, target_rotation.z, body_turn_speed / 2.1)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
		if global_position.y < min_y_pos:
			velocity.y = 0
			global_position.y = min_y_pos
	move_and_slide()
	match(look_state):
		LOOK_STATE.DIR:
			var look_pos = global_position + look_forward_dist * velocity.normalized()
			head_look_at_position(look_pos)
			arm_look_at_position(look_pos)
			body_look_in_direction(velocity)
		LOOK_STATE.TARGET_HEAD:
			head_look_at_position(target.global_position)
		LOOK_STATE.TARGET_HEAD_ARM:
			head_look_at_position(target.global_position)
			arm_look_at_position(target.global_position)
			body_look_in_direction(velocity)
		LOOK_STATE.TARGET_HEAD_ARM_BODY:
			head_look_at_position(target.global_position)
			arm_look_at_position(target.global_position)
			body_look_in_direction(global_position.direction_to(target.global_position))
		LOOK_STATE.TARGET_BODY_FULL_ROTATION:
			if aiming_at_target:
				body_face_position_directly(target.global_position)
	if stationary:
		velocity.x = 0
		velocity.z = 0
	else:
		match(behav_state):
			STRAIGHT:
				walk_straight(walk_dir)
			CURVED:
				walk_curved(false)
			CIRCLING:
				walk_curved(true)
			SPECIAL:
				pass

func get_random_flat_unit_vector() -> Vector3:
	# 1. Pick a random angle in radians (0 to 2*PI)
	var angle = randf() * TAU 
	
	# 2. Calculate X and Z using trigonometry
	var x = cos(angle)
	var z = sin(angle)
	
	# 3. Return the resulting Vector3
	return Vector3(x, 0, z)

func long_dist_attack_check():
	if attacking:
		return
	# This code block ensures start_long_dist_attack is only called once
	if long_dist_wait_remaining <= 0:
		return
	else:
		long_dist_wait_remaining -= get_physics_process_delta_time()
		if not attack_queued and long_dist_wait_remaining <= 0:
			queue_attack()

func switch_to_straight():
	behav_state = STRAIGHT
	look_state = LOOK_STATE.DIR
	walk_dir = get_random_flat_unit_vector()

func walk_straight(dir: Vector3):
	velocity = walk_speed * dir
	
	long_dist_attack_check()

func switch_to_curved():
	behav_state = CURVED
	look_state = LOOK_STATE.TARGET_HEAD_ARM
	
	# Set center of circular path
	var direction_to_center = velocity.cross(Vector3.UP).normalized()
	var vec_to_center = walk_curved_radius * direction_to_center
	curve_center_pos = global_position + vec_to_center
	$Marker.global_position = curve_center_pos

var curve_center_pos := Vector3.FORWARD

func walk_curved(circling_target: bool):
	if circling_target:
		curve_center_pos = target.global_position
	
	# Calculate the vector from center to current position (the Radius)
	var radius_vec = (global_position - curve_center_pos).normalized()
	
	# Calculate the Tangent (the direction of travel)
	# Rotating the radius vector 90 degrees on the Y axis
	var tangent_dir = Vector3(-radius_vec.z, 0, radius_vec.x)
	
	# Set velocity directly
	# This ensures the movement is always perfectly perpendicular to the center
	velocity.x = tangent_dir.x * walk_speed
	velocity.z = tangent_dir.z * walk_speed
	
	long_dist_attack_check()

func switch_to_circling():
	behav_state = CIRCLING
	look_state = LOOK_STATE.TARGET_HEAD_ARM_BODY

func queue_attack():
	parried = false # Clarity can parry when he reaches follow state again
	attack_queued = true
	match(phase):
		PHASE.PHASE1:
			match(behav_state):
				STRAIGHT:
					var attack = choose_attack(phase1_straight_attack_chances)
					arm_anim_tree.set(attack, true)
					body_anim_tree.set(attack, true)
				CURVED:
					var attack = choose_attack(phase1_curved_attack_chances)
					arm_anim_tree.set(attack, true)
					body_anim_tree.set(attack, true)
				CIRCLING:
					var attack = choose_attack(phase1_circling_attack_chances)
					arm_anim_tree.set(attack, true)
					body_anim_tree.set(attack, true)
		PHASE.PHASE2:
			pass # pass until phase2 is confirmed to exist

func choose_attack(attack_chances) -> String:
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for attack in attack_chances:
		cumulative_weight += attack_chances[attack]
		if choice <= cumulative_weight:
			return param_path_base + attack
	return param_path_base + attack_chances.keys()[0]

func start_attack():
	# Without this await, the animation player would call end_attack at the end of the previous animation on the exact same frame as when the AnimationPlayer.play func is called below. Since an animation was currently in progress, the func call would do nothing, leaving the enemy in ATTACK mode but with no animation playing to free it from ATTACK mode, causing it to stand still indefinitely
	await get_tree().physics_frame
	attacking = true # Prevent another attack from being queued
	aiming_at_target = true

func end_attack():
	attacking = false
	attack_queued = false
	no_attack_queued.emit()
	var attack_chances = [phase1_straight_attack_chances, phase1_curved_attack_chances, phase1_circling_attack_chances]
	for ac in attack_chances:
		for attack in ac.keys():
			arm_anim_tree.set(param_path_base + attack, false)
			body_anim_tree.set(param_path_base + attack, false)
	long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
	current_follow_time = 0
	# After an attack or dodge ends, check when the rose or ax is thrown again
	rose_thrown = false
	ax_thrown = false
	"""
	FOR TESTING: behav_state is chosen here manually instead of randomly btwn str and cur
	NOTE: certain attacks always go to certain states (e.g. any jump shot to walk left must switch to circling)
	"""
	switch_to_circling()
	"""
	match(behav_state):
		STRAIGHT:
			switch_to_curved()
		CURVED:
			switch_to_circling()
		CIRCLING:
			switch_to_straight()
	"""

func set_stationary(state: bool):
	stationary = state

func choose_stomp_direction() -> String:
	var to_target = global_position.direction_to(target.global_position)
	
	# Calculate how much the target aligns with Forward and Right axes
	# Results range from -1.0 to 1.0
	var forward_dot = (body_meshes.transform.basis.z).dot(to_target)
	var right_dot = -body_meshes.transform.basis.x.dot(to_target)

	# Compare the absolute values to see which axis is more "dominant"
	if abs(forward_dot) > abs(right_dot):
		# Target is more in front or more behind than they are to the sides
		if forward_dot > 0:
			return "Front"
		else:
			return "Back"
	else:
		# Target is more to the sides than they are in front or back
		if right_dot > 0:
			return "Right"
		else:
			return "Left"

func get_dir_to_target_LR():
	# 1. Get the direction vector from character to target
	var to_target = global_position.direction_to(target.global_position)
	
	# 2. Get the character's local Right vector
	var character_right = -body_meshes.transform.basis.x
	
	# 3. Use the Dot Product
	var side_dot = character_right.dot(to_target)
	
	# side_dot > 0 means the target is to the Right
	# side_dot < 0 means the target is to the Left
	return "Left" if side_dot < 0 else "Right"

func set_aiming_at_target(state: bool):
	aiming_at_target = state

func set_look_state(new_state: LOOK_STATE):
	look_state = new_state

func jump_shot_mvmt():
	behav_state = SPECIAL
	var t = get_tree().create_tween()
	var full_dash_speed = velocity * 9
	t.tween_property(self, "velocity", full_dash_speed, 97 * get_physics_process_delta_time())
	#t.tween_property(self, "look_state", LOOK_STATE.TARGET_BODY_FULL_ROTATION, 0)
	t.tween_property(self, "velocity", full_dash_speed + 9 * Vector3.UP, 30 * get_physics_process_delta_time()).set_ease(Tween.EASE_IN_OUT)
	t.tween_property(self, "velocity", Vector3.ZERO, 120 * get_physics_process_delta_time())
	t.tween_property(self, "gravity", 0, 0)
	t.tween_interval(49 * get_physics_process_delta_time())
	t.tween_property(self, "gravity", .5 * ProjectSettings.get_setting("physics/3d/default_gravity"), 0)

