extends Node3D

var rng := RandomNumberGenerator.new()
var roller := preload("res://enemies/roller_ball.tscn")
var bouncer := preload("res://enemies/bouncer_ball.tscn")
var giant_roller := preload("res://enemies/giant_roller_ball.tscn")
var giant_bouncer := preload("res://enemies/giant_bouncer_ball.tscn")

@export var spawning := true
@export var spawn_cooldown_secs := 3.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"ROLLER": .4,
	"BOUNCER": .1,
	"GIANT_ROLLER": .5
}

@export var move_speed := 20.0
@export var move_dir_angle_arc := 30.0
@export var bounce_height := 20.0

@onready var root = $/root/ViewControl
var level : Node3D

func _ready():
	level = root.find_child("Level")

func _physics_process(_delta):
	if self and not spawn_cooldown_active and spawning and not spawn_limit_met():
		spawn_enemy()

func spawn_limit_met():
	if level:
		return get_tree().get_nodes_in_group("lockonables").size() >= level.lockonable_limit
	else:
		return true

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
		"default":
			print("Error: attempted to spawn unknown enemy")
			await spawn_roller()

func spawn_roller():
	var b = roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	var move_dir_half_arc := deg_to_rad(move_dir_angle_arc) / 2
	b.global_rotation = rotation + rng.randf_range(-move_dir_half_arc, move_dir_half_arc) * Vector3.UP
	b.linear_velocity = move_speed * -b.get_global_transform().basis.z

func spawn_bouncer():
	var b = bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	var move_dir_half_arc := deg_to_rad(move_dir_angle_arc) / 2
	b.global_rotation = rotation + rng.randf_range(-move_dir_half_arc, move_dir_half_arc) * Vector3.UP
	b.linear_velocity = .25 * move_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = bounce_height

func spawn_giant_roller():
	var b = giant_roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = move_speed * -b.get_global_transform().basis.z

func spawn_giant_bouncer():
	var b = giant_bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = .25 * move_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = bounce_height
