extends Node3D
class_name StationaryBallSpawner

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

@export var spawning := true
@export var spawn_cooldown_secs := 3.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"ROLLER": .0,
	"BOUNCER": .0,
	"GIANT_ROLLER": .0,
	"GIANT_BOUNCER": .0,
	"SWARM": .0,
	"SKULL": .0,
	"HEAVY": .0,
	"DEATHBALL": 1.0,
	"POPPER" : 1.0,
}

@export var roller_move_speed := 20.0
@export var move_dir_angle_arc := 20.0
@export var bounce_height := 10.0
var high_target_trajectory_lateral_vel := 0.0
var high_target_trajectory_y_vel := 0.0

@export var swarm_size := 15.0

@export var skull_follow_speed := 5.0
@export var skull_explode_dist := 5.0

@export var heavy_launch_height := 20.0
@export var arena_floor_y := 10.0

@export var deathball_move_speed := 15.0

@export var roller_chargeup_secs := 1.0
@export var bouncer_chargeup_secs := 2.0
@export var giant_roller_chargeup_secs := 5.0
@export var giant_bouncer_chargeup_secs := 5.0
@export var swarm_chargeup_secs := 5.0
@export var skull_chargeup_secs := 4.5
@export var heavy_chargeup_secs := 4.0

@onready var root = $/root/ViewControl
var level : Node3D
var target : Node3D

func _ready():
	level = root.find_child("Level")

func spawn_enemy():
	spawn_cooldown_active = true
	await choose_enemy()
	await get_tree().create_timer(spawn_cooldown_secs).timeout
	spawn_cooldown_active = false

func choose_enemy():
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for enemy in enemy_chances:
		cumulative_weight += enemy_chances[enemy]
		if choice <= cumulative_weight:
			await spawn_from_name(enemy)
			return
	await spawn_from_name("default")
	
func spawn_from_name(enemy_name):
	match(enemy_name):
		"ROLLER":
			await spawn_roller()
		"BOUNCER":
			await spawn_bouncer()
		"GIANT_ROLLER":
			await spawn_giant_roller()
		"GIANT_BOUNCER":
			await spawn_giant_bouncer()
		"SWARM":
			await spawn_swarm()
		"SKULL":
			await spawn_skull()
		"HEAVY":
			await spawn_heavy()
		"DEATHBALL":
			await spawn_deathball()
		"POPPER":
			await spawn_popper()
		"default":
			print("Error: attempted to spawn unknown enemy")
			await spawn_roller()

func spawn_roller():
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = roller_move_speed * -transform.basis.z

func spawn_bouncer():
	await get_tree().create_timer(bouncer_chargeup_secs).timeout
	var b = bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = .25 * roller_move_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = bounce_height

func spawn_giant_roller():
	await get_tree().create_timer(giant_roller_chargeup_secs).timeout
	var b = giant_roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = roller_move_speed * -b.get_global_transform().basis.z

func spawn_giant_bouncer():
	await get_tree().create_timer(giant_bouncer_chargeup_secs).timeout
	var b = giant_bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = .25 * roller_move_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = bounce_height

func spawn_swarm():
	await get_tree().create_timer(swarm_chargeup_secs).timeout
	for i in range(swarm_size):
		var b = swarm.instantiate()
		level.add_child.call_deferred(b)
		await b.tree_entered
		b.global_position = global_position
		var move_dir_half_arc := deg_to_rad(move_dir_angle_arc) / 2
		b.global_rotation = global_rotation + rng.randf_range(-move_dir_half_arc, move_dir_half_arc) * Vector3.UP
		b.linear_velocity = roller_move_speed * -b.get_global_transform().basis.z
		b.linear_velocity.y = rng.randfn()

func spawn_skull():
	await get_tree().create_timer(skull_chargeup_secs).timeout
	var b = skull.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = roller_move_speed * -b.get_global_transform().basis.z
	b.follow_speed = skull_follow_speed
	b.explode_dist = skull_explode_dist

func spawn_heavy():
	await get_tree().create_timer(heavy_chargeup_secs).timeout
	var b = heavy.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = high_target_trajectory_lateral_vel * -b.get_global_transform().basis.z
	b.linear_velocity.y = high_target_trajectory_y_vel
	b.arena_floor_y = arena_floor_y

func spawn_deathball():
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = deathball.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.velocity = deathball_move_speed * -b.get_global_transform().basis.z

func spawn_popper():
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = popper.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = roller_move_speed * -b.get_global_transform().basis.z
