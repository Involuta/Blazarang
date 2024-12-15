extends Node3D

var rng := RandomNumberGenerator.new()
var roller := preload("res://enemies/roller_ball.tscn")

@export var spawning := true
@export var spawn_cooldown_secs := 3.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"ROLLER": 1
}

@export var roll_speed := 20.0
@export var roll_dir := Vector2.LEFT
@export var roll_dir_angle_arc := 30.0

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
		"default":
			print("Error: attempted to spawn unknown enemy")
			await spawn_roller()

func spawn_roller():
	var r = roller.instantiate()
	level.add_child.call_deferred(r)
	await r.tree_entered
	r.global_position = global_position
	var roll_dir_half_arc := deg_to_rad(roll_dir_angle_arc) / 2
	r.global_rotation = rotation + rng.randf_range(-roll_dir_half_arc, roll_dir_half_arc) * Vector3.UP
	r.linear_velocity = roll_speed * -r.get_global_transform().basis.z
