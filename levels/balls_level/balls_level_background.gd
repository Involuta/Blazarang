extends Node3D

@export var star_num := 80.0
@export var star_min_spawn_radius := 16.0
@export var star_max_spawn_radius := 24.0
@export var star_min_dist_from_others := .5

var rng := RandomNumberGenerator.new()
var star := preload("res://levels/balls_level/background_nodes/balls_level_star.tscn")
@onready var root := $/root/ViewControl
var bg : Node3D
var star_list := []

func _ready():
	bg = root.find_child("BallsLevelBackground")
	for i in range(star_num):
		spawn_star()

func spawn_star():
	var s = star.instantiate()
	bg.add_child.call_deferred(s)
	await s.tree_entered
	while true:
		var test_pos := spawn_coord_within_radiuses(star_min_spawn_radius, star_max_spawn_radius)
		if spawn_pos_is_far_from_others(star_list, test_pos, star_min_dist_from_others):
			s.global_position = test_pos
			star_list.append(s)
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

func spawn_pos_is_far_from_others(obj_list, pos: Vector3, dist: float) -> bool:
	if star_list.is_empty():
		return true
	for obj in obj_list:
		if obj.global_position.distance_to(pos) < dist:
			return false
	return true
