extends Node3D

const GUN_CHANCE = .33

var spawn_cooldown_secs := 7.0
var rng := RandomNumberGenerator.new()
var fasthuman := preload("res://enemies/enemy_fasthuman.tscn")
var gunhuman := preload("res://enemies/enemy_gunhuman.tscn")
@export var spawning := true
@onready var arena := $/root/Arena
	
func _ready():
	while self and spawning:
		if spawn_limit_met():
			await get_tree().create_timer(get_physics_process_delta_time()).timeout
		else:
			var enemy_inst = choose_enemy()
			add_child.call_deferred(enemy_inst)
			await enemy_inst.tree_entered
			enemy_inst.global_position = global_position
			await get_tree().create_timer(spawn_cooldown_secs).timeout

func choose_enemy():
	var choice := rng.randf()
	if choice <= GUN_CHANCE:
		return gunhuman.instantiate()
	else:
		return fasthuman.instantiate()

func spawn_limit_met():
	return get_tree().get_nodes_in_group("lockonables").size() >= arena.lockonable_limit
