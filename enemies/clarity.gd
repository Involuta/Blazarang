extends CharacterBody3D

@export var entity_name := "Clarity" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

enum {
	STRAIGHT,
	CURVED,
	CIRCLING,
	SPECIAL,
	STAGGERED,
}
var behav_state := CIRCLING
var attacking := false # Set to true when attacking to prevent another attack from being queued

enum LOOK_STATE {
	DIR,
	TARGET_HEAD, # Used when Clarity stops aiming at target while attacking but still looks at target with her head
	TARGET_HEAD_ARM, # Used when Clarity's traveling in a direction but her head and arm still look at the target. May not be used ever since arm becomes offset from body
	TARGET_HEAD_ARM_BODY, # Used when Clarity's circling around target
	TARGET_BODY_FULL_ROTATION, # Used when Clarity's body rotates toward target on all axes, not just y. Used when she becomes a gun/cannon
	STOP
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

@export var blizzard_safezone_base_radius := 15.0
@export var blizzard_safezone_expanded_radius := 150.0 # Blizzard safezone expands on jumps
var blizzard_safezone_radius := 15.0
@export var body_light_base_radius := 18.0
@export var body_light_expanded_radius := 180.0 # Light expands on jumps to show new safezone

var stationary := false
@export var walk_speed := 1.8
var walk_dir := Vector3.FORWARD # Randomly set when switching to walk straight
@export var walk_curved_radius := 9.0 # Radius of circle Clarity walks on
@export var full_dash_speed := 18.0

@export var head_turn_speed := .06
@export var body_turn_speed := .09

# Distance in front of herself Clarity looks in order to match anim head looking forward
@export var look_forward_dist := 12.0

var aiming_at_target := true

@export var base_head_brightness := 0.0
@export var full_head_brightness := 6.0

@export var stagger_damage_threshold := 10.0 # Single hit damage to head necessary to stagger

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

var param_path_base := "parameters/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var transparent_mat := preload("res://textures/clear_tile.tres")
@onready var arm_anim_tree := $ArmAnimationTree # Controls arm attacks
@onready var arm_anim_player := $ClarityArmMeshes/AnimationPlayer # Plays stagger anim after anim tree is set inactive
@onready var body_anim_tree := $BodyAnimationTree # Controls walk anim
@onready var body_anim_player := $ClarityBodyMeshes/AnimationPlayer # Plays stagger anim after anim tree is set inactive
@onready var mhp := $MeleeHitboxPivot
@onready var arm_meshes := $ClarityArmMeshes
@onready var body_meshes := $ClarityBodyMeshes
@onready var head_light := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2/ClarityHead/BaseOffsetRotation/HeadMesh/HeadLight
@onready var head_bone := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2
@onready var head_mesh := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2/ClarityHead
@onready var body_light := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2/BodyLight
@onready var blizzard_area := $BlizzardDOTArea
@onready var particle_attractor := $ParticleAttractor

var head_hurtbox : Node3D

@onready var root := $/root/ViewControl
var level : Node3D
var target : Node3D
var cotu : Node3D # Clarity only attacks the target; cotu is only referenced here to help Clarity calculate whether to parry when Cotu throws a roserang
var camera : Node3D
var clarity_icon : Node3D
var bg_env : Environment
var bg_sky : ProceduralSkyMaterial
var bg_particle_attractor : GPUParticlesAttractor3D
var level_env : Environment
var level_sky : ProceduralSkyMaterial
var level_fog : FogMaterial

func _ready():
	head_hurtbox = find_child("EnemyHurtbox")
	
	head_hurtbox.add_to_group("lockonables")
	level = root.find_child("Level")
	target = level.find_child("Icon")
	cotu = level.find_child("cotuCB")
	camera = cotu.find_child("Camera3D")
	clarity_icon = level.find_child("ClarityIcon")
	
	var bg = root.find_child("SnowLevelBackground")
	bg_env = bg.find_child("WorldEnvironment").environment
	bg_sky = bg_env.sky.sky_material
	bg_particle_attractor = bg.find_child("ParticleAttractor")
	
	level_env = root.find_child("Level").find_child("WorldEnvironment").environment
	level_sky = level_env.sky.sky_material
	camera.environment = level_env
	
	blizzard_safezone_radius = blizzard_safezone_base_radius
	body_light.omni_range = body_light_base_radius
	
	min_long_dist_wait = phase1_min_long_dist_wait
	max_long_dist_wait = phase1_max_long_dist_wait
	long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
	
	switch_to_straight()
	
	arm_anim_tree.active = true
	body_anim_tree.active = true
	mhp.visible = false
	
	head_hurtbox.hit_received.connect(on_head_hit)

func frames(num: int) -> float:
	return num * get_physics_process_delta_time()

func head_light_high():
	get_tree().create_tween().tween_property(head_light, "light_energy", full_head_brightness, .3)

func head_light_low():
	get_tree().create_tween().tween_property(head_light, "light_energy", base_head_brightness, .3)

func on_head_hit(damage: int):
	if damage >= stagger_damage_threshold and behav_state != STAGGERED:
		switch_to_staggered()

func switch_to_staggered():
	# Set behav_state and look_state
	behav_state = STAGGERED
	look_state = LOOK_STATE.TARGET_HEAD_ARM_BODY
	# Switch to Stagger anim
	var arm_state_machine = arm_anim_tree["parameters/playback"]
	arm_state_machine.travel("Stagger")
	var body_state_machine = body_anim_tree["parameters/playback"]
	body_state_machine.travel("Stagger")
	# Move backward
	var t = get_tree().create_tween()
	var move_dir := 3 * walk_speed * target.global_position.direction_to(global_position)
	t.tween_property(self, "velocity", Vector3(move_dir.x, 0, move_dir.z), 0)
	t.tween_property(self, "velocity", Vector3.ZERO, frames(162))
	await get_tree().create_timer(frames(196)).timeout
	# Return to normal anim tree/state machine behavior
	switch_to_circling()
	arm_state_machine.travel("WalkLeftAggressive")
	body_state_machine.travel("WalkLeftAggressive")

func set_head_rotation(rot_deg: Vector3):
	# Set rotation of dynamic head (the head that looks at the player)
	head_mesh.rotation_degrees = rot_deg

func head_look_at_position(target_pos: Vector3):
	var old_head_rotation = head_mesh.rotation
	head_mesh.look_at(Vector3(target_pos.x, min_y_pos, target_pos.z), Vector3.UP, true)
	var head_target_rotation = head_mesh.rotation
	head_mesh.rotation = old_head_rotation
	head_mesh.rotation.y = lerp_angle(head_mesh.rotation.y, head_target_rotation.y, head_turn_speed)
	# Stop head from looking too far down (i.e. stop angle from being too high) and looking too far up
	head_mesh.rotation.x = clampf(lerp_angle(head_mesh.rotation.x, head_target_rotation.x, head_turn_speed), -.3, .45)
	head_mesh.rotation.z = lerp_angle(head_mesh.rotation.z, head_target_rotation.z, head_turn_speed)

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
	if cotu.global_position.distance_to(global_position) > blizzard_safezone_radius:
		blizzard_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		blizzard_area.process_mode = Node.PROCESS_MODE_DISABLED
	
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
		LOOK_STATE.STOP:
			pass
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
			SPECIAL, STAGGERED:
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
	var full_dash_vec = full_dash_speed * velocity.normalized()
	t.tween_property(self, "velocity", full_dash_vec, frames(97))
	t.tween_property(self, "velocity", full_dash_vec + 9 * Vector3.UP, frames(30)).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "velocity", Vector3.ZERO, frames(120))
	t.tween_property(self, "gravity", 0, 0)
	t.tween_interval(frames(49))
	t.tween_property(self, "gravity", .5 * ProjectSettings.get_setting("physics/3d/default_gravity"), 0)

func expand_blizzard_safezone():
	var t = get_tree().create_tween().set_parallel()
	t.tween_property(self, "blizzard_safezone_radius", blizzard_safezone_expanded_radius, frames(144))
	t.tween_property(body_light, "omni_range", body_light_expanded_radius, frames(144))
	t.tween_property(body_light, "light_color", Color.DARK_GRAY, frames(144))
	t.tween_property(bg_sky, "sky_top_color", Color("#8394ae"), frames(144))
	#t.tween_property(sky, "sky_horizon_color", Color("#6a7b95"), frames(144))
	#t.tween_property(sky, "ground_horizon_color", Color("#6a7b95"), frames(144))
	t.tween_property(bg_sky, "sky_horizon_color", Color.DARK_GRAY, frames(144))
	t.tween_property(bg_sky, "ground_horizon_color", Color.DARK_GRAY, frames(144))
	t.tween_property(level_sky, "sky_top_color", Color.GRAY, frames(144))
	t.tween_property(level_env, "fog_light_color", Color.GRAY, frames(144))
	t.tween_property(level_env, "fog_density", 0, frames(144))
	t.tween_property(level_env, "volumetric_fog_density", 0, frames(144))
	t.tween_property(particle_attractor, "strength", -30, 0)
	t.tween_property(bg_particle_attractor, "strength", -30, 0)

func contract_blizzard_safezone():
	var t = get_tree().create_tween().set_parallel()
	t.tween_property(self, "blizzard_safezone_radius", blizzard_safezone_base_radius, frames(360))
	t.tween_property(body_light, "omni_range", body_light_base_radius, frames(360))
	t.tween_property(body_light, "light_color", Color("#007ce4"), frames(360))
	t.tween_property(bg_sky, "sky_top_color", Color("#65768f"), frames(360))
	t.tween_property(bg_sky, "sky_horizon_color", Color("#5a6c82"), frames(360))
	t.tween_property(bg_sky, "ground_horizon_color", Color("#5a6c82"), frames(360))
	t.tween_property(level_sky, "sky_top_color", Color("#65768f"), frames(360))
	t.tween_property(level_env, "fog_light_color", Color("#5a6c82"), frames(360))
	t.tween_property(level_env, "fog_density", 0.01, frames(360))
	t.tween_property(level_env, "volumetric_fog_density", 0.036, frames(360))
	t.tween_property(particle_attractor, "strength", 0, frames(180))
	t.tween_property(bg_particle_attractor, "strength", 0, frames(180))
