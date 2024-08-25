extends CharacterBody3D

@export var entity_name := "XBoss"

enum {
	WAIT,
	FOLLOW,
	SHORT_DIST_ATTACK,
	LONG_DIST_ATTACK,
}
var behav_state := FOLLOW
var long_dist_wait_remaining := 5.0

@export var max_long_dist_wait := 5.0

@export var aggro_distance := -1

@export var follow_speed := 10.0
@export var target_distance := 4.0

@export var attack_duration_secs := 2.5

@export var follow_turn_speed := .05
@export var attack_turn_speed := .15

var aiming_at_target := true
@export var bullet_speed := 30.0
@export var fast_bullet_speed := 50.0

@export var short_dist_attack_chances = {
	"SlipnSlice" : 1.0,
	"Superman" : .25,
}

@export var long_dist_attack_chances = {
	"SlipnSlice" : 1.0,
	"Superman" : .25
}

@export var slipnslice_speed := 20.0
@export var superman_fwd_speed := 20.0
@export var superman_down_speed := 7.0
@export var triangle_arm_angle := 36.0
@export var triangle_arm_dist := 90.0
@export var triangle_axkick_dist := 10.0
@export var flyingkick_hit_frames := 10

var param_path_base := "parameters/StateMachine/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var bullet := preload("res://enemies/enemy_mega_bullet.tscn")
var body_mat := preload("res://textures/x_boss_body.tres")
@onready var nav_agent := $NavigationAgent3D
@onready var anim_tree := $AnimationTree
@onready var x_meshes := $X_boss_meshes/Armature/Skeleton3D/Body_001
@onready var x_mesh_left_arm := $X_boss_meshes/Armature/Skeleton3D/LeftArm
@onready var x_mesh_right_arm := $X_boss_meshes/Armature/Skeleton3D/RightArm
@onready var level := $/root/Level
@onready var target := $/root/Level/Target
@onready var left_arm := $/root/Level/XBossArena1/XLeftArm
@onready var right_arm := $/root/Level/XBossArena1/XRightArm

func _ready():
	add_to_group("lockonables")
	if aggro_distance > 0:
		nav_agent.process_mode = Node.PROCESS_MODE_DISABLED
		behav_state = WAIT
	anim_tree.active = true

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		match(behav_state):
			WAIT:
				print("WAIT")
			FOLLOW:
				print("FOLLOW")
			SHORT_DIST_ATTACK:
				print("ATTACK")
	if not is_on_floor():
		velocity.y -= gravity * delta
	match(behav_state):
		WAIT:
			wait()
		FOLLOW:
			follow()
		SHORT_DIST_ATTACK:
			short_dist_attack_frame()
		LONG_DIST_ATTACK:
			long_dist_attack_frame()
			
	if global_position.y < -100:
		queue_free()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func wait():
	move_and_slide()
	if global_position.distance_to(target.global_position) < aggro_distance:
		nav_agent.process_mode = Node.PROCESS_MODE_INHERIT
		behav_state = FOLLOW

func _on_navigation_agent_3d_target_reached():
	if behav_state != SHORT_DIST_ATTACK and behav_state != LONG_DIST_ATTACK:
		start_short_dist_attack()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW:
		if is_on_floor():
			# This line accelerates the agent rather than setting its velocity to its desired velocity directly, preventing it from getting caught on corners
			velocity = velocity.move_toward(safe_velocity, .25)
		else:
			# If the enemy is in the air, don't use navigation agent at all
			var move_dir = global_position.direction_to(target.global_position)
			velocity.x = follow_speed / 2 * move_dir.x
			velocity.z = follow_speed / 2 * move_dir.z
	move_and_slide()

func follow():
	lerp_look_at_target(follow_turn_speed)
	nav_agent.set_target_position(target.global_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# If player isn't in sight, reduce target distance to a very small number
	if can_see_target():
		nav_agent.target_desired_distance = target_distance
	else:
		nav_agent.target_desired_distance = .1
	
	long_dist_wait_remaining -= get_physics_process_delta_time()
	if long_dist_wait_remaining <= 0:
		start_long_dist_attack()

func start_short_dist_attack():
	# Without this await, the animation player would call end_attack at the end of the previous animation on the exact same frame as when the AnimationPlayer.play func is called below. Since an animation was currently in progress, the func call would do nothing, leaving the enemy in ATTACK mode but with no animation playing to free it from ATTACK mode, causing it to stand still indefinitely
	await get_tree().create_timer(get_process_delta_time()).timeout
	nav_agent.velocity.x = 0
	nav_agent.velocity.z = 0
	velocity.x = 0
	velocity.z = 0
	behav_state = SHORT_DIST_ATTACK
	aiming_at_target = true
	anim_tree.set(choose_attack(short_dist_attack_chances), true)

func end_attack():
	for attack in short_dist_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in long_dist_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	behav_state = FOLLOW

func choose_attack(attack_chances) -> String:
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for attack in attack_chances:
		cumulative_weight += attack_chances[attack]
		if choice <= cumulative_weight:
			return param_path_base + attack
	return param_path_base + attack_chances.keys()[0]

func short_dist_attack_frame():
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)

func long_dist_attack_frame():
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)
	
func stop_aiming_at_target():
	aiming_at_target = false

func face_target():
	look_at(target.global_position)

func start_slipnslice():
	velocity = slipnslice_speed * -transform.basis.z

func stop_mvmt():
	velocity = Vector3.ZERO

func start_superman():
	velocity.y = 6

func superman_rush():
	velocity = superman_fwd_speed * -transform.basis.z
	velocity.y = -superman_down_speed

func triangle_shoot_arms():
	left_arm.rotation_degrees = (rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP
	left_arm.visible = true
	var left_arm_tween = get_tree().create_tween()
	left_arm_tween.tween_callback(left_arm.stop_firing_laser)
	left_arm_tween.tween_property(left_arm, "global_position", triangle_arm_dist*left_arm.basis.z, .3).as_relative().from(global_position + Vector3(-.2, .2, 0))
	left_arm_tween.tween_property(left_arm, "rotation_degrees", Vector3.UP * -2 * triangle_arm_angle, .1).as_relative()
	left_arm_tween.tween_callback(left_arm.fire_laser)
	
	right_arm.rotation_degrees = (rotation_degrees.y - 180 - triangle_arm_angle) * Vector3.UP
	right_arm.visible = true
	var right_arm_tween = get_tree().create_tween()
	right_arm_tween.tween_callback(right_arm.stop_firing_laser)
	right_arm_tween.tween_property(right_arm, "global_position", triangle_arm_dist*right_arm.basis.z, .3).as_relative().from(global_position + Vector3(.2, .2, 0))
	right_arm_tween.tween_property(right_arm, "rotation_degrees", Vector3.UP * 2 * triangle_arm_angle, .1).as_relative()
	right_arm_tween.tween_callback(right_arm.fire_laser)

func flyingkick_rush():
	# Up vec prevents X from ending up under the ground after tweening
	var kick_tween = get_tree().create_tween()
	kick_tween.tween_property(self, "global_position", (-1.5+global_position.distance_to(target.global_position)) * -transform.basis.z + .01 * Vector3.UP, flyingkick_hit_frames/60.0).set_trans(Tween.TRANS_EXPO).as_relative()

func recall_left_arm():
	if x_meshes.get_surface_override_material(2) == body_mat:
		return
	left_arm.stop_firing_laser()
	var recall_tween = get_tree().create_tween()
	recall_tween.set_parallel()
	recall_tween.tween_method(recall_left_arm_frame, 0.0, 1.0, .8).set_ease(Tween.EASE_OUT)
	recall_tween.tween_callback(hide_left_arm).set_delay(.25)
	recall_tween.tween_callback(x_meshes.set_surface_override_material.bind(2, body_mat)).set_delay(.25)

func recall_left_arm_frame(lerp_val):
	left_arm.rotation_degrees = left_arm.rotation_degrees.lerp((rotation_degrees.y - 180 - triangle_arm_angle) * Vector3.UP, lerp_val)
	left_arm.rotation_degrees = (rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP
	left_arm.global_position = left_arm.global_position.lerp(x_mesh_left_arm.global_position, lerp_val)

func hide_left_arm():
	left_arm.visible = false

func recall_right_arm():
	if x_meshes.get_surface_override_material(5) == body_mat:
		return
	right_arm.stop_firing_laser()
	var recall_tween = get_tree().create_tween()
	recall_tween.set_parallel()
	recall_tween.tween_method(recall_right_arm_frame, 0.0, 1.0, .8).set_ease(Tween.EASE_OUT)
	recall_tween.tween_callback(hide_right_arm).set_delay(.25)
	recall_tween.tween_callback(x_meshes.set_surface_override_material.bind(5, body_mat)).set_delay(.25)

func recall_right_arm_frame(lerp_val):
	right_arm.rotation_degrees = right_arm.rotation_degrees.lerp((rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP, lerp_val)
	right_arm.rotation_degrees = (rotation_degrees.y - 180 - triangle_arm_angle) * Vector3.UP
	right_arm.global_position = right_arm.global_position.lerp(x_mesh_right_arm.global_position, lerp_val)

func hide_right_arm():
	right_arm.visible = false

func shoot_bullet():
	var bullet_inst = bullet.instantiate()
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position + Vector3.UP + get_global_transform().basis.z
	bullet_inst.look_at(target.global_position)
	bullet_inst.velocity = -bullet_speed * bullet_inst.get_global_transform().basis.z

func shoot_fast_bullet():
	var bullet_inst = bullet.instantiate()
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position + Vector3.UP + Vector3.FORWARD
	bullet_inst.look_at(target.global_position)
	bullet_inst.velocity = -fast_bullet_speed * bullet_inst.get_global_transform().basis.z

func start_long_dist_attack():
	# This await might not be necessary, but it's here just in case
	await get_tree().create_timer(get_process_delta_time()).timeout
	nav_agent.velocity.x = 0
	nav_agent.velocity.z = 0
	velocity.x = 0
	velocity.z = 0
	behav_state = LONG_DIST_ATTACK
	long_dist_wait_remaining = max_long_dist_wait
	aiming_at_target = true
	anim_tree.set(choose_attack(short_dist_attack_chances), true)

func can_see_target():
	var space_state := get_world_3d().direct_space_state
	var sight_dir := global_position.direction_to(target.global_position)
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + nav_agent.neighbor_distance * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER, Globals.TARGET_COL_LAYER])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if not result:
		return true
	if result.collider.collision_layer == Globals.ARENA_COL_LAYER:
		return false
	else:
		return true
