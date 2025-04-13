extends CharacterBody3D

@export var entity_name := "BallWalker"

enum DIST_TYPE {
	LONG_DIST,
	SHORT_DIST
}
var dist_state = DIST_TYPE.LONG_DIST
@export var dist_state_switch_cooldown := 2.0 # Time after a dist state switch before dist state can switch again
var can_switch_dist_state := false
@export var short_dist_state_range := 30.0
@export var max_short_dist_wait := 3.0
var short_dist_wait_remaining := 3.0
var substate_queued := false

@export var bowl_slam_foot_radius:= 6.0 # Imagine a circle w this radius around each foot. If the target is within both circles, a bowl slam occurs

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
	"ROLLER": 1.0,
}

@export var mortar_enemy_chances = {
	"BOUNCER": .5,
	"HEAVY": .5,
}

const STANDING_FEET_DIST := 19.0 # Dist btwn each foot when neutrally standing

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
@onready var standing_foot := $WalkerPivot/LeftLegStand/DomeMesh/Foot
@onready var gun_foot := $WalkerPivot/LegGun/HipJoint/Thigh/Knee/Shin/DomeMesh/Foot
@onready var anim_player := $AnimationPlayer
#@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl

var level : Node3D
var target : Node3D
var ball_spawner : Node3D

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	ball_spawner = find_child("BallSpawner")
	add_to_group("lockonables")
	
	ball_spawner.enemy_chances = mortar_enemy_chances

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		print(ball_spawner.position)
	if not is_on_floor():
		velocity.y -= gravity * delta
	match(dist_state):
		DIST_TYPE.LONG_DIST:
			long_dist_state_frame()
		DIST_TYPE.SHORT_DIST:
			short_dist_state_frame()
	move_and_slide()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	rotation.y = lerp_angle(rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func stop_aiming_at_target():
	aiming_at_target = false

func target_closer_to_standing_foot():
	return standing_foot.global_position.distance_to(target.global_position) <= gun_foot.global_position.distance_to(target.global_position)

func target_in_bowl_slam_range():
	return standing_foot.global_position.distance_to(target.global_position) >= bowl_slam_foot_radius and gun_foot.global_position.distance_to(target.global_position) >= bowl_slam_foot_radius

func switch_to_long_dist_state():
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
	aiming_at_target = true
	ball_spawner.spawning = true

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
			stomp()
		"default":
			print("Error: attempted to switch to substate: ", substate)
			switch_to_cannon()

func switch_to_mortar():
	# Replace this with an anim_tree condition
	foot_state = FOOT_TYPE.MORTAR
	anim_player.play("stand_to_foot_mortar")
	ball_spawner.enemy_chances = mortar_enemy_chances
	ball_spawner.spawning = true

func switch_to_cannon():
	# Replace this with an anim_tree condition
	foot_state = FOOT_TYPE.CANNON
	anim_player.play("stand_to_foot_cannon")
	ball_spawner.enemy_chances = cannon_enemy_chances
	ball_spawner.spawning = true

func stomp():
	if target_in_bowl_slam_range():
		"""
		anim_player.play("bowl_flip_down")
		await anim_player.animation_finished
		await get_tree().create_timer(1.0).timeout
		anim_player.play("bowl_flip_upright")
		"""
		await step_flip_to_downbowl()
		await get_tree().create_timer(0.5).timeout
		await step_flip_to_upbowl()
	else:
		if target_closer_to_standing_foot():
			global_position += STANDING_FEET_DIST * -transform.basis.z
			rotation.y += PI
		anim_player.play("right_stomp")

func step_flip_to_downbowl():
	anim_player.play("step_flip_to_downbowl")
	# global pos and walker pivot move an equal distance in opposite directions (global pos moves via tween, walker pivot moves via anim)
	await create_tween().tween_property(self, "global_position", global_position + transform.basis.z * STANDING_FEET_DIST, 2.0).finished
	# walker pivot then resets its pos so that other anims can work correctly, thus moving back to its original position
	walker_pivot.position = Vector3(0,0,-10)
	# To compensate, global pos also moves back to its original pos
	global_position -= transform.basis.z * STANDING_FEET_DIST
	# So after the step flip to downbowl anim, global pos and walker pivot are both UNCHANGED
	# The only things that changed were the positions and rotations of the legs and bowl

func step_flip_to_upbowl():
	anim_player.play("step_flip_to_upbowl")
	# Flip the walker so that it still moves forward
	"""
	Playing the anim and rotating the walker simultaneously in code causes a bug where 
	the walker flips for an extremely short moment before resuming the mvmt correctly.
	Each of these actions individually flip the walker, meaning that even though the code
	does both at the same time, one flip is happening before another.
	Through testing, it was found that it was the rotation that was happening sooner.
	To fix the bug, a tiny delay was added between the anim starting and the rotation.
	"""
	await get_tree().create_timer(.01).timeout
	rotation.y += PI
	
	# walker pivot moves back to its original pos while global pos does the same
	await create_tween().tween_property(self, "global_position", global_position - transform.basis.z * STANDING_FEET_DIST, 2.0).finished

func long_dist_state_frame():
	velocity.x = 0
	velocity.z = 0
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)
	if global_position.distance_to(target.global_position) <= short_dist_state_range:
		switch_to_short_dist_state()

func switch_to_short_dist_state():
	dist_state = DIST_TYPE.SHORT_DIST
	match(foot_state):
		FOOT_TYPE.CANNON:
			anim_player.play("foot_cannon_to_stand")
		FOOT_TYPE.MORTAR:
			anim_player.play("foot_mortar_to_stand")
		_:
			print("Error: tried to transition to short dist state from impossible foot state")
	ball_spawner.spawning = false

func short_dist_state_frame():
	velocity.x = 0
	velocity.z = 0
	if global_position.distance_to(target.global_position) >= short_dist_state_range:
		switch_to_long_dist_state()
	short_dist_wait_remaining -= get_physics_process_delta_time()
	if short_dist_wait_remaining <= 0:
		match(phase):
			PHASE.PHASE1:
				print(global_position.distance_to(target.global_position))
				choose_substate(phase1_short_dist_substate_chances)
			PHASE.PHASE2:
				choose_substate(phase2_short_dist_substate_chances)
		short_dist_wait_remaining = max_short_dist_wait
