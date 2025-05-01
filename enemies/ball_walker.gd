extends CharacterBody3D

@export var entity_name := "BallWalker"

var min_y_pos := 10.0 # y pos of arena floor, used for calculating dist walker is from arena center

enum DIST_TYPE {
	LONG_DIST,
	SHORT_DIST
}
var dist_state = DIST_TYPE.LONG_DIST
var anim_in_progress := false
@export var max_dist_state_switch_cooldown := 10.0 # Time after a dist state switch before dist state can switch again
var dist_state_switch_cooldown_remaining := 10.0
var can_switch_dist_state := false
@export var max_foot_ball_spawner_upgrade_time := 5.0 # Time after foot ball spawner starts spawning balls that it gets upgraded
var foot_ball_spawner_upgrade_time_remaining := 5.0
@export var short_dist_state_range := 30.0
@export var max_short_dist_wait := 3.0
var short_dist_wait_remaining := 3.0
var substate_queued := false

var facing_forward := false # Whether to face toward or away from the target pos of lerp_look_at
var aiming_at_icon := false
var just_walked := false # Whether the last short dist action the walker performed was a walk
var latest_saved_y_rotation := 0.0 # Latest rotation before initiating linear look at pos

@export var max_dist_from_arena_center := 80.0 # Max dist from arena center before walker steps the other way
@export var arena_radius := 40.0
var walker_icon_pos := Vector3.ZERO

@export var bowl_slam_proximity := 5.0 # Imagine a circle w this radius around the walker pivot. If the target is within the circle, a bowl slam occurs

@export var bowl_radius := 8.0 # Radius of bowl mesh
@export var num_rim_balls := 7.0 # Num of balls spawned from rim per rim ball blast
@export var rim_ball_fwd_speed := 8.0
@export var rim_ball_init_down_speed := 8.0 # Downward speed of rim ball when it's first shot out

var typhoon_rotating := false # If this is true, the walker pivot rotates about its y axis
var typhoon_rotation_rate := 0.0 # Modified by physics_process if typhoon_rotating

enum PHASE {
	PHASE1,
	PHASE2,
}
var phase := PHASE.PHASE1

enum FOOT_TYPE {
	CANNON,
	MORTAR
}
var foot_state = FOOT_TYPE.CANNON

@export var aggro_distance := -1

@export var follow_speed := 5.0

var aiming_at_target := true

@export var follow_turn_speed := .15
@export var attack_turn_speed := .15

@export var phase1_short_dist_substate_chances = {
	"STOMP": 1.0,
}

@export var phase1_long_dist_substate_chances = {
	"CANNON": .5,
	"MORTAR": .5
}

@export var phase2_short_dist_substate_chances = {
	"STOMP": 1.0,
}

@export var phase2_long_dist_substate_chances = {
	"CANNON": .5,
	"MORTAR": .5
}

@export var cannon_enemy_chances = {
	"ROLLER": 1,
}

@export var upgraded_cannon_enemy_chances = {
	"SKULL" : 1,
}

@export var mortar_enemy_chances = {
	"BOUNCER": .5,
	"HEAVY": .5,
}

@export var upgraded_mortar_enemy_chances = {
	"SKULL" : 1,
}

@export var random_balls_chances = {
	"ROLLER" : .5,
	"BOUNCER" : .3,
	"HEAVY" : .2,
	"SKULL" : 0.0,
}

const STANDING_FEET_DIST := 20.0 # Dist btwn each foot when neutrally standing

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var roller := preload("res://enemies/roller_ball.tscn")
var bouncer := preload("res://enemies/bouncer_ball.tscn")
var giant_roller := preload("res://enemies/giant_roller_ball.tscn")
var giant_bouncer := preload("res://enemies/giant_bouncer_ball.tscn")
var swarm := preload("res://enemies/swarm_ball.tscn")
var skull := preload("res://enemies/skull_ball.tscn")
var heavy := preload("res://enemies/heavy_ball.tscn")
var deathball := preload("res://enemies/death_ball.tscn")
var popper := preload("res://enemies/popper_ball.tscn")

@onready var walker_pivot := $WalkerPivot
@onready var bowl_pivot := $WalkerPivot/BowlPivot
@onready var standing_foot := $WalkerPivot/LeftLegStand/DomeMesh/Foot
@onready var gun_foot := $WalkerPivot/RightLegGun/HipJoint/Thigh/Knee/Shin/DomeMesh/Foot
@onready var anim_player := $AnimationPlayer
#@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl

var level : Node3D
var target : Node3D
var walker_icon : Node3D
var foot_ball_spawner : Node3D

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	walker_icon = root.find_child("WalkerIcon")
	foot_ball_spawner = find_child("FootBallSpawner")
	add_to_group("lockonables")
	
	foot_ball_spawner.enemy_chances = mortar_enemy_chances
	
	dist_state_switch_cooldown_remaining = max_dist_state_switch_cooldown
	foot_ball_spawner_upgrade_time_remaining = max_foot_ball_spawner_upgrade_time

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		print(foot_ball_spawner.position)
	if not is_on_floor():
		velocity.y -= gravity * delta
	if typhoon_rotating:
		rotate_y(typhoon_rotation_rate)
	match(dist_state):
		DIST_TYPE.LONG_DIST:
			long_dist_state_frame()
		DIST_TYPE.SHORT_DIST:
			short_dist_state_frame()
	move_and_slide()
	
	var target_pos := -target.global_position
	var target_pos_angle_from_center := atan2(target_pos.x, target_pos.z)
	walker_icon_pos = Vector3(arena_radius * sin(target_pos_angle_from_center), 15, arena_radius * cos(target_pos_angle_from_center))
	walker_icon.global_position = walker_icon_pos

func update_latest_y_rotation():
	latest_saved_y_rotation = global_rotation.y

func lerp_look_at_position(target_pos, turn_speed):
	var vec3_to_target := global_position.direction_to(target_pos)
	if facing_forward:
		vec3_to_target *= -1
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func linear_look_at_position(target_pos, turn_speed):
	var vec3_to_target := global_position.direction_to(target_pos)
	if facing_forward:
		vec3_to_target *= -1
	global_rotation.y = Globals.rotate_toward(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed * get_physics_process_delta_time())

func stop_aiming_at_target():
	aiming_at_target = false

func target_closer_to_standing_foot():
	return standing_foot.global_position.distance_to(target.global_position) <= gun_foot.global_position.distance_to(target.global_position)

func target_in_bowl_slam_range():
	return walker_pivot.global_position.distance_to(target.global_position) <= bowl_slam_proximity

func switch_to_long_dist_state():
	aiming_at_icon = false
	aiming_at_target = true
	dist_state = DIST_TYPE.LONG_DIST
	# If target is closer to left foot than right foot (ie closer to standing foot than gun foot), instantly move forward L units and instantly flip the walker before choosing a long range substate
	if target_closer_to_standing_foot():
		global_position += STANDING_FEET_DIST * -transform.basis.z
		rotation.y += PI
	match(phase):
		PHASE.PHASE1:
			choose_substate(phase1_long_dist_substate_chances)
		PHASE.PHASE2:
			choose_substate(phase2_long_dist_substate_chances)
	foot_ball_spawner.spawning = true

func choose_substate(substate_chances):
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for substate in substate_chances:
		cumulative_weight += substate_chances[substate]
		if choice <= cumulative_weight:
			choose_substate_from_name(substate)
			return
	choose_substate_from_name("default")

func choose_substate_from_name(substate: String):
	match(substate):
		"CANNON":
			switch_to_cannon()
		"MORTAR":
			switch_to_mortar()
		"STOMP":
			step_or_stomp()
		"default":
			print("Error: attempted to switch to substate: ", substate)
			switch_to_cannon()

func switch_to_mortar():
	anim_in_progress = true
	foot_state = FOOT_TYPE.MORTAR
	anim_player.play("stand_to_foot_mortar")
	foot_ball_spawner.enemy_chances = mortar_enemy_chances
	foot_ball_spawner.spawning = true
	foot_ball_spawner.skull_launched_by_mortar = true
	await anim_player.animation_finished
	anim_in_progress = false

func switch_to_cannon():
	anim_in_progress = true
	foot_state = FOOT_TYPE.CANNON
	anim_player.play("stand_to_foot_cannon")
	foot_ball_spawner.enemy_chances = cannon_enemy_chances
	foot_ball_spawner.spawning = true
	foot_ball_spawner.skull_launched_by_mortar = false
	await anim_player.animation_finished
	anim_in_progress = false

func upgrade_foot_ball_spawner():
	if foot_state == FOOT_TYPE.CANNON:
		foot_ball_spawner.enemy_chances = upgraded_cannon_enemy_chances
	elif foot_state == FOOT_TYPE.MORTAR:
		foot_ball_spawner.enemy_chances = upgraded_mortar_enemy_chances

func choose_ball_from_name(ball_name):
	match(ball_name):
		"ROLLER":
			return foot_ball_spawner.roller
		"BOUNCER":
			return foot_ball_spawner.bouncer
		"HEAVY":
			return foot_ball_spawner.heavy
		"SKULL":
			return foot_ball_spawner.skull
		"default":
			print("Error: attempted to choose ball with name: ", ball_name)
			return foot_ball_spawner.roller

func get_random_ball():
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for ball in random_balls_chances:
		cumulative_weight += random_balls_chances[ball]
		if choice <= cumulative_weight:
			return choose_ball_from_name(ball)
	return choose_ball_from_name("default")

func spawn_rim_balls():
	foot_ball_spawner.skull_launched_by_mortar = false
	var ball_vec := -transform.basis.z
	# Make it so that a ball doesn't shoot directly from the walker's rim in its fwd direction bc that's where its thigh is
	# 2 balls shoot at equivalent angles beside the line representinga the walker's fwd direction
	ball_vec = ball_vec.rotated(Vector3.UP, PI/num_rim_balls)
	for i in range(num_rim_balls):
		var b = get_random_ball().instantiate()#foot_ball_spawner.roller.instantiate()
		level.add_child.call_deferred(b)
		await b.tree_entered
		b.global_position = bowl_pivot.global_position + bowl_radius * ball_vec
		b.linear_velocity = rim_ball_fwd_speed * ball_vec
		b.linear_velocity.y = -rim_ball_init_down_speed
		ball_vec = ball_vec.rotated(Vector3.UP, 2 * PI / num_rim_balls)

func spawn_foot_explosion():
	var foot_explosion_inst = load("res://enemies/ball_walker_foot_explosion.tscn").instantiate()
	level.add_child.call_deferred(foot_explosion_inst)
	await foot_explosion_inst.tree_entered
	foot_explosion_inst.global_position = gun_foot.global_position
	foot_explosion_inst.rotation.y = rotation.y
	spawn_rim_balls()

func spawn_bowl_explosion():
	var foot_explosion_inst = load("res://enemies/ball_walker_foot_explosion.tscn").instantiate()
	level.add_child.call_deferred(foot_explosion_inst)
	await foot_explosion_inst.tree_entered
	foot_explosion_inst.global_position = bowl_pivot.global_position
	foot_explosion_inst.global_position.y = min_y_pos+1
	foot_explosion_inst.rotation.y = rotation.y

func step_or_stomp():
	# If you're too far from arena center and you didn't just walk, walk towards icon
	if not just_walked and global_position.distance_to(min_y_pos * Vector3.UP) >= max_dist_from_arena_center:
		just_walked = true
		aiming_at_icon = true
		anim_in_progress = true
		await step_flip_to_downbowl()
		await step_flip_to_upbowl()
		anim_in_progress = false
		aiming_at_icon = false
	# Otherwise, if target is directly below you, either bowl slam or walk away
	elif target_in_bowl_slam_range():
		if not just_walked and rng.randf() > .9:
			just_walked = true
			aiming_at_icon = true
			anim_in_progress = true
			await step_flip_to_downbowl()
			await step_flip_to_upbowl()
			anim_in_progress = false
			aiming_at_icon = false
		else:
			just_walked = false
			anim_in_progress = true
			#await bowl_slam()
			await typhoon()
			anim_in_progress = false
	# If you cannot bowl slam or walk, stomp. If the target is closer to the gun foot, flip yourself
	else:
		just_walked = false
		anim_in_progress = true
		if target_closer_to_standing_foot():
			global_position += STANDING_FEET_DIST * -transform.basis.z
			rotation.y += PI
		anim_player.play("right_stomp")
		await get_tree().create_timer(2.0).timeout
		anim_in_progress = false

func bowl_slam():
	anim_player.play("bowl_flip_down")
	await anim_player.animation_finished
	anim_player.play("bowl_slam")
	await anim_player.animation_finished
	anim_player.play("bowl_flip_upright")
	await anim_player.animation_finished

func step_flip_to_downbowl():
	update_latest_y_rotation()
	facing_forward = true
	anim_player.play("step_flip_to_downbowl")
	await anim_player.animation_finished
	await spawn_foot_explosion() # Spawn the foot explosion before the flip to prevent it from being spawned at the wrong foot
	# Flip ball walker so that when the upbowl step flip anim plays, it moves the walker forward instead of backward
	rotation.y += PI
	# To compensate, global pos moves back
	global_position -= transform.basis.z * STANDING_FEET_DIST
	update_latest_y_rotation()

func step_flip_to_upbowl():
	facing_forward = false
	anim_player.play("step_flip_to_upbowl")
	await anim_player.animation_finished
	await spawn_foot_explosion()
	# Don't do anything else; the rotation and global pos mvmt from the previous anim (step flip to downbowl) did all the work already

func typhoon():
	anim_player.play("bowl_flip_down")
	await anim_player.animation_finished
	anim_player.play("typhoon")
	walker_pivot.position = Vector3.ZERO
	global_position += 10 * -transform.basis.z
	typhoon_rotating = true
	await create_tween().tween_property(self, "typhoon_rotation_rate", PI/10, 2.2).finished
	await create_tween().tween_property(self, "typhoon_rotation_rate", 0, 2.2).finished
	await anim_player.animation_finished
	typhoon_rotating = false
	walker_pivot.rotation.y = -PI/2
	walker_pivot.position = 10 * Vector3.FORWARD
	global_position += 10 * transform.basis.z
	anim_player.play("bowl_flip_upright")
	await anim_player.animation_finished

func long_dist_state_frame():
	velocity.x = 0
	velocity.z = 0
	
	if aiming_at_target:
		linear_look_at_position(target.global_position, attack_turn_speed)
	elif aiming_at_icon:
		linear_look_at_position(walker_icon.global_position, attack_turn_speed)
	
	if not anim_in_progress:
		if foot_ball_spawner_upgrade_time_remaining <= 0:
			upgrade_foot_ball_spawner()
		else:
			foot_ball_spawner_upgrade_time_remaining -= get_physics_process_delta_time()
		
		if dist_state_switch_cooldown_remaining <= 0 and global_position.distance_to(target.global_position) < short_dist_state_range:
			switch_to_short_dist_state()
			dist_state_switch_cooldown_remaining = max_dist_state_switch_cooldown
			foot_ball_spawner_upgrade_time_remaining = max_foot_ball_spawner_upgrade_time
		elif dist_state_switch_cooldown_remaining > 0:
			dist_state_switch_cooldown_remaining -= get_physics_process_delta_time()

func switch_to_short_dist_state():
	aiming_at_target = false
	anim_in_progress = true
	dist_state = DIST_TYPE.SHORT_DIST
	match(foot_state):
		FOOT_TYPE.CANNON:
			anim_player.play("foot_cannon_to_stand")
		FOOT_TYPE.MORTAR:
			anim_player.play("foot_mortar_to_stand")
		_:
			print("Error: tried to transition to short dist state from impossible foot state")
	foot_ball_spawner.spawning = false
	await get_tree().create_timer(1.0).timeout
	anim_in_progress = false

func short_dist_state_frame():
	velocity.x = 0
	velocity.z = 0
	
	if aiming_at_target:
		linear_look_at_position(target.global_position, attack_turn_speed)
	elif aiming_at_icon:
		linear_look_at_position(walker_icon.global_position, attack_turn_speed)
	
	if not anim_in_progress and dist_state_switch_cooldown_remaining <= 0 and global_position.distance_to(target.global_position) >= short_dist_state_range:
		switch_to_long_dist_state()
		dist_state_switch_cooldown_remaining = max_dist_state_switch_cooldown
	elif not anim_in_progress and dist_state_switch_cooldown_remaining > 0:
		dist_state_switch_cooldown_remaining -= get_physics_process_delta_time()
	
	if not anim_in_progress and short_dist_wait_remaining <= 0:
		match(phase):
			PHASE.PHASE1:
				choose_substate(phase1_short_dist_substate_chances)
			PHASE.PHASE2:
				choose_substate(phase2_short_dist_substate_chances)
		short_dist_wait_remaining = max_short_dist_wait
	else:
		short_dist_wait_remaining -= get_physics_process_delta_time()
