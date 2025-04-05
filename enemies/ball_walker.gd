extends CharacterBody3D

@export var entity_name := "BallWalker"

enum {
	ATTACK
}
var behav_state = ATTACK

@export var aggro_distance := -1

@export var follow_speed := 5.0
@export var target_distance := 40.0

var aiming_at_target := true
@export var ball_speed := 20.0

@export var follow_turn_speed := .15
@export var attack_turn_speed := .15

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
	ball_spawner = find_child("BowlPivot")
	add_to_group("lockonables")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	match(behav_state):
		ATTACK:
			attack()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	rotation.y = lerp_angle(rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func start_attack():
	behav_state = ATTACK
	aiming_at_target = true
	$AnimationPlayer.play("foot_cannon")
	#anim_tree.set("parameters/StateMachine/conditions/shoot", true)

func try_end_attack():
	if global_position.distance_to(target.global_position) > target_distance:
		#anim_tree.set("parameters/StateMachine/conditions/shoot", false)
		pass
	else:
		aiming_at_target = true

func attack():
	velocity.x = 0
	velocity.z = 0
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)
	#ball_spawner.spawning = true

func stop_aiming_at_target():
	aiming_at_target = false
