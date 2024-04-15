extends Area3D

@export var resource_path := ""
var resource
@export var load_position := Vector3.ZERO
@export var load_rotation_y_degrees := 0.0
@export var node_path_in_level := ""
@onready var level = $/root/Level

func _ready():
	resource = load(resource_path)

func _on_body_entered(_body):
	if not level.find_child(node_path_in_level, false, false):
		var inst = resource.instantiate()
		level.add_child.call_deferred(inst)
		await inst.tree_entered
		inst.global_position = load_position
		inst.rotation.y = deg_to_rad(load_rotation_y_degrees)
