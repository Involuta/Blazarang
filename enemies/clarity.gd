extends CharacterBody3D

@export var entity_name := "Clarity" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

# Behav state is controlled within code bc multiple attacks can occur w/o a change in behav state (e.g. a series of blade attacks in circling state)
enum {
	STRAIGHT,
	CURVED,
	CIRCLING,
	SPECIAL,
	STAGGERED,
}
var behav_state := CIRCLING
var arm_attacking := false # Set to true when arm is attacking to prevent another attack from being queued
var snowflake_attacking := false # Same as arm_attacking but for the snowflake

# Look state is controlled within anim keyframes bc one anim can have multiple look states (e.g. jump shot, which goes from STOP or DIR to BODY FULL ROT to TARGET HEAD ARM BODY (which may be renamed TARGET LATERAL))
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
var arm_long_dist_wait_remaining := 2.5
var snowflake_long_dist_wait_remaining := 2.5
var arm_attack_queued := false
var snowflake_attack_queued := false
signal no_arm_attack_queued
signal no_snowflake_attack_queued

enum PHASE {
	PHASE1,
	PHASE2,
}
var phase := PHASE.PHASE1

@export var min_y_pos := 10.0 # y pos of arena floor, ie X's minimum y position

@export var blizzard_safezone_base_radius := 15.0
@export var blizzard_safezone_expanded_radius := 150.0 # Blizzard safezone expands on jumps
var blizzard_safezone_radius := 15.0
@export var safezone_expand_frames_jump_shot := 144
@export var safezone_contract_frames_jump_shot := 360

@export var body_light_base_radius := 18.0
@export var body_light_expanded_radius := 180.0 # Light expands on jumps to show new safezone
@export var min_fog_radius := 12.0 # Dist from Clarity where fog is minimized
@export var max_fog_radius := 24.0 # Dist from Clarity where fog is maximized
var env_autochange := true # Fog automatically changes depending on Cotu's dist to Clarity unless the blizzard is expanding/contracting

var stationary := false
@export var walk_speed := 1.8
var walk_dir := Vector3.FORWARD # Randomly set when switching to walk straight
@export var walk_curved_radius := 10.0 # Radius of circle Clarity walks on
@export var full_dash_speed := 24.0

@export var head_turn_speed := .06
@export var body_turn_speed := .06

# Distance in front of herself Clarity looks in order to match anim head looking forward
@export var look_forward_dist := 12.0

var aiming_at_target := true

@export var base_head_brightness := 0.0
@export var full_head_brightness := 6.0

var staggerable := false # When head is exposed but not glowing, staggerable is false
@export var stagger_damage_threshold := 10.0 # Single hit damage to head necessary to stagger

@export var wait_lowered_left_min_secs := .6
@export var wait_lowered_left_max_secs := 6.0
@export var wait_raised_left_min_secs := .6
@export var wait_raised_left_max_secs := 6.0

@export var arm_attack_chances = {
	"RaiseRightSlice" : .5,
	"LongSlice" : .5,
	"RegenShards" : 0.0,
}

@export var snowflake_attack_chances = {
	"DoubleShardSequence1" : .5,
	"SingleShardSequence1" : .5,
}

var param_path_base := "parameters/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var transparent_mat := preload("res://textures/clear_tile.tres")
@onready var arm_anim_player := $ClarityArmMeshes/AnimationPlayer # Depends on Clarity.glb. Plays stagger anim after anim tree is set inactive
@onready var mhp := $MeleeHitboxPivot
@onready var arm_meshes := $ClarityArmMeshes
@onready var body_meshes := $DressShardMaster # Depends on ClarityDressMeshes.glb. Plays dress shard anims
@onready var head_light := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2/ClarityHead/BaseOffsetRotation/HeadMesh/HeadLight
@onready var head_bone := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2
@onready var head_mesh := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2/ClarityHead
@onready var body_light := $ClarityArmMeshes/Armature/Skeleton3D/Hat_2/BodyLight
@onready var blizzard_hitbox := $BlizzardDOT
@onready var snowfall_particles := $SnowfallParticles
@onready var blizzard_particles := $BlizzardParticles
@onready var body_cone_fog := $FogVolume/BodyCone
@onready var feet_fog := $FogVolume/FeetFog
@onready var body_cloud := $FogVolume/BodyCloud

var head_hurtbox : Node3D
var dress_shards := {}

@onready var root := get_tree().root
var level : Node3D
var target : Node3D
var cotu : Node3D # Clarity only attacks the target; cotu is only referenced here to help Clarity calculate whether to parry when Cotu throws a roserang
var camera : Node3D
var clarity_icon : Node3D
var level_env : Environment
var sky : ProceduralSkyMaterial
var level_fog : FogMaterial

class DressShard extends Node3D:
	var node : Node
	var anim_player : AnimationPlayer
	# Since this is an inner class, it doesn't have access to get_tree()
	var ds_tween : Tween
	
	func _init(n: Node):
		self.node = n
		self.anim_player = n.find_child("AnimationPlayer")
	
	func frames(num: int) -> float:
		return num * self.node.get_physics_process_delta_time()
	
	func stop():
		self.node.top_level = true
	
	func recall():
		self.node.top_level = false
		self.ds_tween = self.node.get_tree().create_tween().set_parallel()
		ds_tween.tween_property(self.node, "position", Vector3.ZERO, frames(45)).set_ease(Tween.EASE_IN_OUT)
		ds_tween.tween_property(self.node, "rotation", Vector3.ZERO, frames(45)).set_ease(Tween.EASE_IN_OUT)

func _ready():
	head_hurtbox = find_child("EnemyHurtbox")
	
	head_hurtbox.add_to_group("lockonables")
	level = root.find_child("Level", true, false)
	target = level.find_child("Icon")
	cotu = level.find_child("cotuCB")
	camera = cotu.find_child("Camera3D")
	clarity_icon = level.find_child("ClarityIcon")
	
	level_env = level.find_child("WorldEnvironment").environment
	sky = level_env.sky.sky_material
	
	blizzard_safezone_radius = blizzard_safezone_base_radius
	body_light.omni_range = body_light_base_radius
	
	min_long_dist_wait = phase1_min_long_dist_wait
	max_long_dist_wait = phase1_max_long_dist_wait
	arm_long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
	snowflake_long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
	
	switch_to_circling()
	
	mhp.visible = false
	
	dress_shards["FrontLeft"] = DressShard.new(find_child("DressShardFrontLeft"))
	dress_shards["FrontRight"] = DressShard.new(find_child("DressShardFrontRight"))
	dress_shards["MiddleLeft"] = DressShard.new(find_child("DressShardMiddleLeft"))
	dress_shards["MiddleRight"] = DressShard.new(find_child("DressShardMiddleRight"))
	dress_shards["BackLeft"] = DressShard.new(find_child("DressShardBackLeft"))
	dress_shards["BackRight"] = DressShard.new(find_child("DressShardBackRight"))
	dress_shards["Master"] = DressShard.new(find_child("DressShardMaster"))
	
	head_hurtbox.hit_received.connect(on_head_hit)
	
	# Set up all states pre-fight. This may eventually be replaced by either a PreFight anim or an anim that spawns the snowflake entity
	arm_anim_player.play("WalkLeftAggressive")
	
	await get_tree().create_timer(3).timeout
	play_anim_all_dress_shards("SingleShardSequence1")

func frames(num: int) -> float:
	return num * get_physics_process_delta_time()

func set_head_hurtbox_active(state: bool):
	if state:
		head_hurtbox.process_mode = PROCESS_MODE_INHERIT
	else:
		head_hurtbox.process_mode = PROCESS_MODE_DISABLED

func set_staggerable(state: bool):
	staggerable = state

func on_head_hit(damage: int):
	if staggerable and damage >= stagger_damage_threshold and behav_state != STAGGERED:
		switch_to_staggered()

func switch_to_staggered():
	# Set behav_state and look_state
	behav_state = STAGGERED
	look_state = LOOK_STATE.TARGET_HEAD_ARM_BODY
	# Switch to Stagger anim
	arm_anim_player.play("Stagger")
	# Move backward
	var t = get_tree().create_tween()
	var move_dir := 3 * walk_speed * target.global_position.direction_to(global_position)
	t.tween_property(self, "velocity", Vector3(move_dir.x, 0, move_dir.z), 0)
	t.tween_property(self, "velocity", Vector3.ZERO, frames(162))
	await get_tree().create_timer(frames(196)).timeout
	# Return to normal anim tree/state machine behavior
	switch_to_circling()

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

func dress_shards_look_in_direction(dir: Vector3):
	var ds_master = dress_shards["Master"]
	ds_master.node.rotation.x = lerp_angle(ds_master.node.rotation.x, 0, body_turn_speed)
	ds_master.node.rotation.y = lerp_angle(ds_master.node.rotation.y, PI + atan2(-dir.x, -dir.z), body_turn_speed)
	ds_master.node.rotation.z = lerp_angle(ds_master.node.rotation.z, 0, body_turn_speed)

func body_face_position_directly(target_pos):
	for m in [arm_meshes, body_meshes]:
		var old_rotation = m.rotation
		m.look_at(m.global_position + m.global_position.direction_to(target_pos), Vector3.UP, true)
		var target_rotation = m.rotation
		m.rotation = old_rotation
		m.rotation.x = lerp_angle(m.rotation.x, target_rotation.x, body_turn_speed / 2.1)
		m.rotation.y = lerp_angle(m.rotation.y, target_rotation.y, body_turn_speed / 2.1)
		m.rotation.z = lerp_angle(m.rotation.z, target_rotation.z, body_turn_speed / 2.1)

# Lerp val (float btwn 0 and 1) to be used for value transitions
var cotu_dist_lerp_val := .5
func _physics_process(delta):
	var dist_to_cotu = cotu.global_position.distance_to(global_position)
	if dist_to_cotu > blizzard_safezone_radius:
		blizzard_hitbox.process_mode = PROCESS_MODE_INHERIT
	else:
		blizzard_hitbox.process_mode = PROCESS_MODE_DISABLED
	snowfall_particles.global_position = cotu.global_position + 15*Vector3.UP
	
	if env_autochange:
		env_autochange_frame(dist_to_cotu, delta)
	
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
			dress_shards_look_in_direction(velocity)
		LOOK_STATE.TARGET_HEAD_ARM_BODY:
			head_look_at_position(target.global_position)
			arm_look_at_position(target.global_position)
			body_look_in_direction(global_position.direction_to(target.global_position))
			dress_shards_look_in_direction(global_position.direction_to(target.global_position))
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

func arm_long_dist_attack_check():
	if arm_attacking:
		return
	# This code block ensures start_long_dist_attack is only called once
	if arm_long_dist_wait_remaining <= 0:
		return
	else:
		arm_long_dist_wait_remaining -= get_physics_process_delta_time()
		if not arm_attack_queued and arm_long_dist_wait_remaining <= 0:
			queue_arm_attack()

func snowflake_long_dist_attack_check():
	if snowflake_attacking:
		return
	# This code block queue_attack is only called once
	if snowflake_long_dist_wait_remaining <= 0:
		return
	else:
		snowflake_long_dist_wait_remaining -= get_physics_process_delta_time()
		if not snowflake_attack_queued and snowflake_long_dist_wait_remaining <= 0:
			queue_snowflake_attack()

func switch_to_straight():
	behav_state = STRAIGHT
	look_state = LOOK_STATE.DIR
	walk_dir = get_random_flat_unit_vector()

func walk_straight(dir: Vector3):
	velocity = walk_speed * dir
	arm_long_dist_attack_check()

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
	
	arm_long_dist_attack_check()
	snowflake_long_dist_attack_check()

func switch_to_circling():
	behav_state = CIRCLING
	look_state = LOOK_STATE.TARGET_HEAD_ARM_BODY

func switch_to_special():
	behav_state = SPECIAL
	# Look state isn't set bc look state often changes in special attacks (e.g. jump shot goes from STOP to BODY FULL ROTATION to TARGET HEAD ARM BODY ROTATION)

func queue_arm_attack():
	arm_attack_queued = true
	match(phase):
		PHASE.PHASE1:
			match(behav_state):
				CIRCLING:
					var attack = choose_attack(arm_attack_chances)
					arm_anim_player.play(attack)
		PHASE.PHASE2:
			pass # pass until phase2 is confirmed to exist

func queue_snowflake_attack():
	snowflake_attack_queued = true
	match(phase):
		PHASE.PHASE1:
			match(behav_state):
				CIRCLING:
					var attack = choose_attack(snowflake_attack_chances)
					play_anim_all_dress_shards(attack)
		PHASE.PHASE2:
			pass # pass until phase2 is confirmed to exist

func choose_attack(attack_chances) -> String:
	var choice := randf()
	var cumulative_weight := 0.0
	for attack in attack_chances:
		cumulative_weight += attack_chances[attack]
		if choice <= cumulative_weight:
			return attack
	return attack_chances.keys()[0]

func start_arm_attack():
	# Without this await, the animation player would call end_attack at the end of the previous animation on the exact same frame as when the AnimationPlayer.play func is called below. Since an animation was currently in progress, the func call would do nothing, leaving the enemy in ATTACK mode but with no animation playing to free it from ATTACK mode, causing it to stand still indefinitely
	await get_tree().physics_frame
	arm_attacking = true # Prevent another arm attack from being queued
	aiming_at_target = true

func start_snowflake_attack():
	# Without this await, the animation player would call end_attack at the end of the previous animation on the exact same frame as when the AnimationPlayer.play func is called below. Since an animation was currently in progress, the func call would do nothing, leaving the enemy in ATTACK mode but with no animation playing to free it from ATTACK mode, causing it to stand still indefinitely
	await get_tree().physics_frame
	snowflake_attacking = true # Prevent another arm attack from being queued

func end_arm_attack():
	arm_attacking = false
	arm_attack_queued = false
	no_arm_attack_queued.emit()
	arm_long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
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

func end_snowflake_attack():
	snowflake_attacking = false
	snowflake_attack_queued = false
	no_snowflake_attack_queued.emit()
	snowflake_long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
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

func wait_lowered_left():
	var wait_time := randf_range(wait_lowered_left_min_secs, wait_lowered_left_max_secs)
	await get_tree().create_timer(wait_time).timeout
	# Choose RaiseLeftSliceFast, RaiseLeftFast, or RaiseLeftSlow
	var choice := randf()
	var cumulative_weight := 0.0
	var next_moves := ["RaiseLeftSliceFast", "RaiseLeftFast", "RaiseLeftSlow"]
	for move in next_moves:
		# All next moves have equal weight
		cumulative_weight += 1.0 / next_moves.size()
		if choice <= cumulative_weight:
			arm_anim_player.play(move)
			return
	arm_anim_player.play(next_moves[0])

func wait_raised_left():
	var wait_time := randf_range(wait_raised_left_min_secs, wait_raised_left_max_secs)
	await get_tree().create_timer(wait_time).timeout
	arm_anim_player.play("LeftSliceFromWait")

func jump_shot_mvmt():
	switch_to_special()
	var t = get_tree().create_tween()
	var full_dash_vec = full_dash_speed * body_meshes.transform.basis.z
	t.tween_property(self, "velocity", full_dash_vec, frames(97))
	t.tween_property(self, "velocity", full_dash_vec + 9 * Vector3.UP, frames(30)).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "velocity", Vector3.ZERO, frames(120))
	t.tween_property(self, "gravity", 0, 0)
	t.tween_interval(frames(49))
	t.tween_property(self, "gravity", .5 * ProjectSettings.get_setting("physics/3d/default_gravity"), 0)

func expand_blizzard_safezone_jump_shot():
	expand_blizzard_safezone(safezone_expand_frames_jump_shot)

func contract_blizzard_safezone_jump_shot():
	contract_blizzard_safezone(safezone_contract_frames_jump_shot)

func env_autochange_frame(dist_to_cotu: float, delta: float):
	# Keep dist to Cotu value within fog bounds
		var clamped_cotu_dist = clampf(dist_to_cotu, min_fog_radius, max_fog_radius)
		# Convert dist to Cotu to a float btwn 0 and 1 (lerp val)
		var target_cotu_dist_lerp_val = remap(clamped_cotu_dist,
		min_fog_radius, max_fog_radius,
		0.0, 1.0)
		# Move sample val toward the target so transitions happen smoothly
		cotu_dist_lerp_val = move_toward(cotu_dist_lerp_val, target_cotu_dist_lerp_val, delta / 3)
		
		# Set fog density based on dist from Cotu
		var min_fog_density := .01
		var max_fog_density := .3
		level_env.fog_density = lerpf(min_fog_density, max_fog_density, cotu_dist_lerp_val)
		
		# Repeat the above for sky and fog colors (0 is near, 1 is far)
		# Sky top color
		var sky_top_gradient = Gradient.new()
		sky_top_gradient.set_color(0, Color("#65768f"))
		sky_top_gradient.set_color(1, Color("#3c485a"))
		sky.sky_top_color = sky_top_gradient.sample(cotu_dist_lerp_val)
		# Sky/ground horizon color
		var sky_horizon_gradient = Gradient.new()
		sky_horizon_gradient.set_color(0, Color("#5a6c82"))
		sky_horizon_gradient.set_color(1, Color("#1d2730"))
		sky.sky_horizon_color = sky_horizon_gradient.sample(cotu_dist_lerp_val)
		sky.ground_horizon_color = sky.sky_horizon_color
		# Fog color is the same as horizon color
		level_env.fog_light_color = sky.sky_horizon_color
		level_env.volumetric_fog_emission = sky.sky_horizon_color
		
		# Snowfall particle intensity. Amount isn't changed bc that causes glitchy behavior
		snowfall_particles.lifetime = lerpf(12, 6, cotu_dist_lerp_val)
		snowfall_particles.process_material.initial_velocity_min = lerpf(1.2, 6, cotu_dist_lerp_val)
		snowfall_particles.process_material.initial_velocity_max = lerpf(2.4, 9, cotu_dist_lerp_val)
		snowfall_particles.process_material.emission_ring_radius = lerpf(18, 9, cotu_dist_lerp_val)
		
		# Body/feet fog
		# Body fog doesn't change
		# Feet fog goes to 0 at far dist
		var near_feet_fog_density := .6
		#feet_fog.material.set_shader_parameter("density", lerpf(near_feet_fog_density, 0, cotu_dist_lerp_val))
		#feet_fog.material.density = lerpf(near_feet_fog_density, 0, cotu_dist_lerp_val)
		var body_fog_gradient = Gradient.new()
		body_fog_gradient.set_color(0, Color("aad3ff"))
		body_fog_gradient.set_color(1, body_light.light_color)
		body_cone_fog.material.set_shader_parameter("emission", body_fog_gradient.sample(cotu_dist_lerp_val-.1))
		#feet_fog.material.emission = body_fog_gradient.sample(cotu_dist_lerp_val)
		#feet_fog.material.set_shader_parameter("emission", body_fog_gradient.sample(cotu_dist_lerp_val))

func expand_blizzard_safezone(frame_duration: int):
	snowfall_particles.emitting = false
	env_autochange = false
	
	var t = get_tree().create_tween().set_parallel()
	t.tween_property(self, "blizzard_safezone_radius", blizzard_safezone_expanded_radius, frames(frame_duration))
	t.tween_property(body_light, "omni_range", body_light_expanded_radius, frames(frame_duration))
	t.tween_property(body_light, "light_color", Color.SNOW, frames(frame_duration))
	t.tween_property(body_light, "light_volumetric_fog_energy", 12.0, frames(frame_duration))
	t.tween_property(sky, "sky_top_color", Color.LIGHT_SKY_BLUE, frames(frame_duration))
	t.tween_property(sky, "sky_horizon_color", Color.SKY_BLUE, frames(frame_duration))
	t.tween_property(sky, "ground_horizon_color", Color.SKY_BLUE, frames(frame_duration))
	t.tween_property(level_env, "fog_light_color", Color.NAVY_BLUE, frames(frame_duration))
	t.tween_property(level_env, "fog_density", 0.0015, frames(frame_duration))
	t.tween_property(level_env, "volumetric_fog_density", .0009, frames(frame_duration))
	t.tween_property(level_env, "volumetric_fog_emission", Color("#95a5bd"), frames(frame_duration))
	#t.tween_property(particle_attractor, "strength", 300, frames(frame_duration))
	# Body fog
	t.tween_property(body_cone_fog.material, "shader_parameter/density", 0.0, frames(frame_duration))
	#t.tween_property(feet_fog.material, "shader_parameter/density", 0.0, frames(frame_duration))

func contract_blizzard_safezone(frame_duration: int):
	var t = get_tree().create_tween().set_parallel()
	t.tween_property(self, "blizzard_safezone_radius", blizzard_safezone_base_radius, frames(frame_duration))
	t.tween_property(body_light, "omni_range", body_light_base_radius, frames(frame_duration))
	t.tween_property(body_light, "light_color", Color("#007ce4"), frames(frame_duration))
	t.tween_property(body_light, "light_volumetric_fog_energy", 6.0, frames(frame_duration))
	t.tween_property(sky, "sky_top_color", Color("#65768f"), frames(frame_duration))
	t.tween_property(sky, "sky_horizon_color", Color("#5a6c82"), frames(frame_duration))
	t.tween_property(sky, "ground_horizon_color", Color("#5a6c82"), frames(frame_duration))
	t.tween_property(level_env, "fog_light_color", Color("#5a6c82"), frames(frame_duration))
	t.tween_property(level_env, "fog_density", 0.01, frames(frame_duration))
	t.tween_property(level_env, "volumetric_fog_density", 0.036, frames(frame_duration))
	t.tween_property(level_env, "volumetric_fog_emission", Color("#65768f"), frames(frame_duration))
	#t.tween_property(particle_attractor, "strength", 0, frames(frame_duration/2))
	# Body fog
	t.tween_property(body_cone_fog.material, "shader_parameter/density", 0.3, frames(frame_duration/2))
	#t.tween_property(feet_fog.material, "shader_parameter/density", 0.15, frames(frames/2))

	await get_tree().create_timer(frames(frame_duration)).timeout
	# contract_blizzard_safezone transitions to the env the autochanging env would be if Cotu were within min_fog_dist, aka when cotu_dist_lerp_val is 0
	cotu_dist_lerp_val = 0.0
	snowfall_particles.emitting = true
	env_autochange = true

func backflip_mvmt():
	switch_to_special()
	var t = get_tree().create_tween()
	var full_dash_vec = 3*full_dash_speed*-body_meshes.transform.basis.z + .6*full_dash_speed*Vector3.UP
	t.tween_property(self, "gravity", 0, 0)
	t.tween_property(self, "velocity", full_dash_vec, frames(27))
	t.tween_property(self, "velocity", Vector3.ZERO, frames(130))
	t.tween_property(self, "velocity", full_dash_speed*3 * Vector3.DOWN, 0)
	t.tween_property(self, "gravity", .5 * ProjectSettings.get_setting("physics/3d/default_gravity"), 0)
	t.tween_interval(frames(100))
	# Return to base pose starts after the above interval
	t.tween_property(self, "velocity", full_dash_speed * Vector3.ZERO, 0)

func regen_shards_mvmt():
	switch_to_special()
	var t = get_tree().create_tween()
	var move_dir := 3 * walk_speed * target.global_position.direction_to(global_position)
	t.tween_property(self, "velocity", Vector3(move_dir.x, 0, move_dir.z), 0)
	t.tween_property(self, "velocity", Vector3.ZERO, frames(84))

func stop_dress_shard(s: String):
	dress_shards[s].stop()

func recall_dress_shard(s: String):
	dress_shards[s].recall()

func play_anim_all_dress_shards(s: String):
	for ds in dress_shards.values():
		ds.anim_player.play(s)
