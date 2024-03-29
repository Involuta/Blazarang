extends Node3D

var rng := RandomNumberGenerator.new()
var melee := preload("res://enemies/enemy_fasthuman.tscn")
var gunner := preload("res://enemies/enemy_gunhuman.tscn")
@export var spawning := true
@export var spawn_cooldown_secs := 7.0
@export var enemy_chances = {
	"MELEE": .66,
	"GUNNER" : .33
}
@onready var arena := $/root/Arena
	
func _ready():
	while self and spawning:
		if spawn_limit_met():
			await get_tree().create_timer(get_physics_process_delta_time()).timeout
		else:
			var enemy_inst = choose_enemy()
			arena.add_child.call_deferred(enemy_inst)
			await enemy_inst.tree_entered
			enemy_inst.global_position = global_position
			await get_tree().create_timer(spawn_cooldown_secs).timeout

func choose_enemy():
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for enemy in enemy_chances:
		cumulative_weight += enemy_chances[enemy]
		if choice <= cumulative_weight:
			return spawn_from_name(enemy)
	return spawn_from_name("default")
	
func spawn_from_name(enemy_name):
	match(enemy_name):
		"MELEE":
			return melee.instantiate()
		"GUNNER":
			return gunner.instantiate()
		"default":
			print("Error: attempted to spawn unknown enemy")
			return melee.instantiate()

func spawn_limit_met():
	return get_tree().get_nodes_in_group("lockonables").size() >= arena.lockonable_limit
