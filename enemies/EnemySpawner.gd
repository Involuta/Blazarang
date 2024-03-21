extends Node3D

var spawn_cooldown_secs := 7.0
var fasthuman := preload("res://enemies/enemy_fasthuman.tscn")
@export var spawning := true
@onready var arena := $/root/Arena

func _ready():
	while (self) and spawning:
		var fasthuman_inst = fasthuman.instantiate()
		arena.add_child.call_deferred(fasthuman_inst)
		await fasthuman_inst.tree_entered
		fasthuman_inst.global_position = global_position
		await get_tree().create_timer(spawn_cooldown_secs).timeout
