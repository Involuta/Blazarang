extends Node3D

@export var diamond_num := 10.0
@export var min_spawn_radius := 10.0
@export var max_spawn_radius := 40.0
@export var min_dist_from_others := 5.0
var rng := RandomNumberGenerator.new()
var diamond := preload("res://levels/x_boss_level/background_nodes/diamond.tscn")
@onready var root := $/root/ViewControl
var bg : Node3D
var diamond_list := []

func _ready():
	bg = root.find_child("XBossLevelBackground")
	for i in range(diamond_num):
		var d = diamond.instantiate()
		bg.add_child.call_deferred(d)
		await d.tree_entered
		while true:
			var x := spawn_coord_within_radiuses()
			var y := spawn_coord_within_radiuses()
			var z := spawn_coord_within_radiuses()
			var test_pos := Vector3(x,y,z)
			if spawn_pos_is_far_from_others(test_pos):
				d.global_position = test_pos
				d.scale = Vector3.ONE
				diamond_list.append(d)
				break

func spawn_coord_within_radiuses() -> float:
	var n := 0.0
	while true:
		n = rng.randf_range(-max_spawn_radius, max_spawn_radius)
		if n < -min_spawn_radius or n > min_spawn_radius:
			break
	return n

func spawn_pos_is_far_from_others(pos: Vector3) -> bool:
	if diamond_list.is_empty():
		return true
	for d in diamond_list:
		if d.global_position.distance_to(pos) < min_dist_from_others:
			return false
	return true
