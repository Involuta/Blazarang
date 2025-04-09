extends CharacterBody3D

@export var entity_name := "BallWalker"

enum {
	LONG_DIST,
	SHORT_DIST
}
var behav_state = LONG_DIST

enum {
	CANNON,
	MORTAR
}
var foot_state = CANNON

@export var short_dist_state_range := 40.0

@export var aggro_distance := -1

@export var follow_speed := 5.0
@export var target_distance := 40.0

var aiming_at_target := true
@export var ball_speed := 20.0

@export var follow_turn_speed := .15
@export var attack_turn_speed := .15

@export var long_dist_substate_chances = {
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

#@onready var anim_player := $AnimationPlayer
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
	match(behav_state):
		LONG_DIST:
			long_dist_state_frame()
		SHORT_DIST:
			short_dist_state_frame()
	move_and_slide()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	rotation.y = lerp_angle(rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func try_end_attack():
	if global_position.distance_to(target.global_position) > target_distance:
		#anim_tree.set("parameters/StateMachine/conditions/shoot", false)
		pass
	else:
		aiming_at_target = true

func stop_aiming_at_target():
	aiming_at_target = false

func switch_to_long_dist_state():
	behav_state = LONG_DIST
	choose_long_dist_substate()
	aiming_at_target = true
	ball_spawner.spawning = true
	#anim_tree.set("parameters/StateMachine/conditions/shoot", true)

func choose_long_dist_substate():
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for substate in long_dist_substate_chances:
		cumulative_weight += long_dist_substate_chances[substate]
		if choice <= cumulative_weight:
			await choose_substate_from_name(substate)
			return
	await choose_substate_from_name("default")

func choose_substate_from_name(substate: String):
	match(substate):
		"CANNON":
			await switch_to_cannon()
		"MORTAR":
			await switch_to_mortar()
		"default":
			print("Error: attempted to switch to substate: ", substate)
			await switch_to_cannon()

func switch_to_mortar():
	# Replace this with an anim_tree condition
	foot_state = MORTAR
	$AnimationPlayer.play("stand_to_foot_mortar")
	ball_spawner.enemy_chances = mortar_enemy_chances
	ball_spawner.spawning = true

func switch_to_cannon():
	# Replace this with an anim_tree condition
	foot_state = CANNON
	$AnimationPlayer.play("stand_to_foot_cannon")
	ball_spawner.enemy_chances = cannon_enemy_chances
	ball_spawner.spawning = true

func long_dist_state_frame():
	velocity.x = 0
	velocity.z = 0
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)
	#ball_spawner.spawning = true
	if global_position.distance_to(target.global_position) <= short_dist_state_range:
		switch_to_short_dist_state()

func switch_to_short_dist_state():
	behav_state = SHORT_DIST
	match(foot_state):
		CANNON:
			$AnimationPlayer.play("foot_cannon_to_stand")
		MORTAR:
			$AnimationPlayer.play("foot_mortar_to_stand")
		_:
			print("Error: tried to transition to short dist state from impossible foot state")
	ball_spawner.spawning = false
	#await get_tree().create_tween().tween_property(self, "global_position", global_position - 19 * -transform.basis.z, 2).finished

func short_dist_state_frame():
	velocity.x = 0
	velocity.z = 0
	#ball_spawner.spawning = true
	if global_position.distance_to(target.global_position) > short_dist_state_range:
		switch_to_long_dist_state()
