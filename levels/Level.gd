extends Node3D

var cotu_look_direction

@export var lockonable_limit := 20
@onready var cotu = $/root/Arena/cotuCB
@onready var camera_twist_pivot = $/root/Arena/cotuCB/CameraTwistPivot
@onready var camera = $/root/Arena/cotuCB/CameraTwistPivot/CameraPitchPivot/CameraVisualObject/Camera3D

func _process(_delta):
	if Input.is_action_just_pressed("LockOn"):
		if cotu.locked_on:
			cotu.lock_off()
		else:
			try_lock_on()

func try_lock_on():
	cotu_look_direction = camera_twist_pivot.basis * Vector3.FORWARD
	var all_lockonables = get_tree().get_nodes_in_group("lockonables")
	var possible_lockonables = all_lockonables.filter(is_node_in_frustum)
	if not possible_lockonables.is_empty():
		var centermost_node = possible_lockonables.reduce(get_centermost_node)
		cotu.lock_on(centermost_node)

func is_node_in_frustum(node):
	return camera.is_position_in_frustum(node.global_position)
	
func get_centermost_node(centermost_node, current_node):
	# Think of the vector from Cotu to the node centermost to the camera direction ("vec_to_centermost_node")
	# Vec_to_closest_node has the largest dot product with cotu's facing direction
	var vec_to_centermost_node = cotu.global_position.direction_to(centermost_node.global_position)
	var vec_to_current_node = cotu.global_position.direction_to(current_node.global_position)
	if vec_to_current_node.dot(cotu_look_direction) > vec_to_centermost_node.dot(cotu_look_direction):
		return current_node
	else:
		return centermost_node
