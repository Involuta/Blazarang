extends CharacterBody3D

@export var entity_name := "FirstMiniboss"

enum {
	WAIT,
	FOLLOW,
	SHORT_DIST_ATTACK,
	LONG_DIST_ATTACK,
	TORNADO
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

@export var tornado_max_speed := 25.0
@export var tornado_acc := 10.0
var tornado_movement_begun = NOTIFICATION_WM_CLOSE_REQUEST

var aiming_at_target := true
@export var bullet_speed := 30.0
@export var fast_bullet_speed := 50.0
"""
@export var attack_chances = {
	"big_sweep": .2,
	"big_overhead" : .2,
	"double_sweep" : .2,
	"flying_sweep" : .4
}
"""
@export var short_dist_attack_chances = {
	"big_sweep": .1,
	"big_overhead" : .2,
	"double_sweep" : .3,
	"flying_sweep_right" : .2,
	"flying_sweep_left" : .2
}

@export var long_dist_attack_chances = {
	"snipe" : .1,
	"flying_sweep_right" : .2,
	"flying_sweep_left" : .1,
	"triple_shot" : .6
}

@export var flying_sweep_speed := 20.0

@export var body_spinner2_rotation_speed := 1.75
@export var body_spinner1_max_duration := 5.0
@export var body_spinner1_min_duration := 1.0
var body_spinner1_current_duration := 5.0
@export var body_spinner1_max_rotation_speed := 5.0
@export var body_spinner1_min_rotation_speed := 1.0
var body_spinner1_rotation_speed := 3.0
var body_spinner1_will_rest := true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var bullet := preload("res://enemies/enemy_mega_bullet.tscn")
@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer
@onready var inner_body := $FirstMiniboss/InnerBody
@onready var body_spinner1 := $FirstMiniboss/BodySpinner1
@onready var body_spinner2 := $FirstMiniboss/BodySpinner2
@onready var root := $/root/ViewControl
var level : Node3D
var target : Node3D

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	add_to_group("lockonables")
	if aggro_distance > 0:
		nav_agent.process_mode = Node.PROCESS_MODE_DISABLED
		behav_state = WAIT

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
		TORNADO:
			tornado_frame()
			
	if global_position.y < -100:
		queue_free()
	
	body_spinner1.rotation.y += delta * body_spinner1_rotation_speed
	body_spinner1_current_duration -= delta
	if body_spinner1_current_duration < 0:
		body_spinner1_current_duration = rng.randf_range(body_spinner1_min_duration, body_spinner1_max_duration)
		body_spinner1_rotation_speed = rng.randf_range(body_spinner1_min_rotation_speed, body_spinner1_max_rotation_speed)
		if body_spinner1_will_rest:
			body_spinner1_rotation_speed = 0
			body_spinner1_will_rest = false
		else:
			body_spinner1_will_rest = true
		if rng.randf() > .5:
			body_spinner1_rotation_speed *= -1
	
	body_spinner2.rotation.y += delta * body_spinner2_rotation_speed

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func wait():
	move_and_slide()
	if global_position.distance_to(target.global_position) < aggro_distance:
		nav_agent.process_mode = Node.PROCESS_MODE_INHERIT
		behav_state = FOLLOW

func _on_navigation_agent_3d_target_reached():
	if behav_state != SHORT_DIST_ATTACK and behav_state != LONG_DIST_ATTACK and behav_state != TORNADO:
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
	animation_player.play(choose_attack(short_dist_attack_chances))

func end_attack():
	behav_state = FOLLOW
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
	tornado_movement_begun = false

func choose_attack(attack_chances) -> String:
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for attack in attack_chances:
		cumulative_weight += attack_chances[attack]
		if choice <= cumulative_weight:
			return attack
	return attack_chances[0]

func short_dist_attack_frame():
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)

func long_dist_attack_frame():
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)
	
func stop_aiming_at_target():
	aiming_at_target = false

func shoot_bullet():
	var bullet_inst = bullet.instantiate()
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position + Vector3.UP + get_global_transform().basis.z
	bullet_inst.look_at(target.global_position)
	bullet_inst.velocity = -bullet_speed * bullet_inst.get_global_transform().basis.z

func shoot_triple_shot():
	var angle := -PI/6
	for i in range(3):
		var bullet_inst = bullet.instantiate()
		level.add_child.call_deferred(bullet_inst)
		await bullet_inst.tree_entered
		bullet_inst.global_position = global_position + Vector3.UP + Vector3.FORWARD
		bullet_inst.look_at(target.global_position)
		bullet_inst.rotate_object_local(Vector3.UP, angle)
		bullet_inst.velocity = -bullet_speed * bullet_inst.get_global_transform().basis.z
		angle += PI/6

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
	animation_player.play(choose_attack(long_dist_attack_chances))

func start_flying_sweep():
	gravity = 0
	velocity = -10 * global_position.direction_to(target.global_position)
	velocity.y = 4

func flying_sweep_rush():
	velocity = flying_sweep_speed * global_position.direction_to(target.global_position)

func start_tornado():
	velocity = Vector3.ZERO

func start_tornado_movement():
	tornado_movement_begun = true

func tornado_frame():
	if not tornado_movement_begun:
		return
	lerp_look_at_target(attack_turn_speed)
	velocity += tornado_acc * get_physics_process_delta_time() * global_position.direction_to(target.global_position)
	velocity.y = 0

func tornado_push():
	var old_acc = tornado_acc
	tornado_acc = 0
	for i in range(30):
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
		velocity *= .94
	tornado_acc = old_acc * 2
	await get_tree().create_timer(.5).timeout
	tornado_acc = old_acc

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
