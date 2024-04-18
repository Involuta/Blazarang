extends Area3D

@export var node_path_in_level := ""
@onready var level = $/root/Level

func _on_body_entered(_body):
	# Using if find_child(...) instead of if $section prevents errors from being thrown when $section returns nullptr
	if level.find_child(node_path_in_level, false, false):
		level.get_node(node_path_in_level).queue_free()
