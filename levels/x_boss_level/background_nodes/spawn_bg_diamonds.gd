extends Node3D

@export var big_diamond_num := 20.0
@export var big_diamond_min_size := .05
@export var big_diamond_max_size := 1.0
@export var big_diamond_min_spawn_radius := 1.0
@export var big_diamond_max_spawn_radius := 5.5
@export var big_diamond_min_dist_from_others := 2.4

@export var small_diamond_num := 80.0
@export var small_diamond_min_size := .05
@export var small_diamond_max_size := .15
@export var small_diamond_min_spawn_radius := 6.0
@export var small_diamond_max_spawn_radius := 12.0
@export var small_diamond_min_dist_from_others := .5

var rng := RandomNumberGenerator.new()
var diamond := preload("res://levels/x_boss_level/background_nodes/diamond.tscn")
var flat_diamond := preload("res://levels/x_boss_level/background_nodes/flat_diamond.tscn")
@onready var root := $/root/ViewControl
var bg : Node3D
var big_diamond_list := []
var small_diamond_list := []

func _ready():
	var starlight_tween := get_tree().create_tween()
	starlight_tween.set_parallel()
	starlight_tween.tween_property($Star/OmniLight3D, "omni_range", 15, 3)
	starlight_tween.tween_property($Star, "scale", Vector3.ONE, 3)
	bg = root.find_child("XBossLevelBackground")
	for i in range(big_diamond_num):
		spawn_big_diamond()
	for i in range(small_diamond_num):
		spawn_small_diamond()

func spawn_small_diamond():
	var d = flat_diamond.instantiate()
	bg.add_child.call_deferred(d)
	await d.tree_entered
	while true:
		var test_pos := spawn_coord_within_radiuses(small_diamond_min_spawn_radius, small_diamond_max_spawn_radius)
		if spawn_pos_is_far_from_others(small_diamond_list, test_pos, small_diamond_min_dist_from_others):
			d.global_position = test_pos
			d.scale = rng.randf_range(small_diamond_min_size, small_diamond_max_size) * Vector3.ONE
			small_diamond_list.append(d)
			break

func spawn_big_diamond():
	var d = diamond.instantiate()
	bg.add_child.call_deferred(d)
	await d.tree_entered
	while true:
		var test_pos := spawn_coord_within_radiuses(big_diamond_min_spawn_radius, big_diamond_max_spawn_radius)
		if spawn_pos_is_far_from_others(big_diamond_list, test_pos, big_diamond_min_dist_from_others):
			d.global_position = test_pos
			d.scale = rng.randf_range(big_diamond_min_size, big_diamond_max_size) * Vector3.ONE
			big_diamond_list.append(d)
			break

func spawn_coord_within_radiuses(min_spawn_radius: float, max_spawn_radius: float) -> Vector3:
	var theta = rng.randf_range(0, 2*PI)  # Angle around the vertical axis (0 to 2π)
	var phi = rng.randf_range(0, PI)     # Angle from the top (0 to π)
	var r = rng.randf_range(min_spawn_radius, max_spawn_radius)  # Radius within shell

	# Convert spherical coordinates to Cartesian coordinates
	var x = r * sin(phi) * cos(theta)
	var y = r * sin(phi) * sin(theta)
	var z = r * cos(phi)

	return Vector3(x, y, z)

func spawn_pos_is_far_from_others(diamond_list, pos: Vector3, dist: float) -> bool:
	if diamond_list.is_empty():
		return true
	for d in diamond_list:
		if d.global_position.distance_to(pos) < dist:
			return false
	return true
