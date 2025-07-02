extends Node3D

# This script prevents legs from lagging behind body by adding fwd ("fwd" = dir of mvmt) offset to the step targets' positions

@export var offset := 10.0

@onready var parent = get_parent_node_3d()
@onready var previous_position = parent.global_position

func _process(delta):
	var velocity = parent.global_position - previous_position
	global_position = parent.global_position + offset * velocity
	previous_position = parent.global_position
