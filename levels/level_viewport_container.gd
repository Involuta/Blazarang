extends SubViewportContainer

@onready var root := $/root/ViewControl
var cotu : Node3D

func _ready():
	cotu = root.find_child("cotuCB")
	set_process_unhandled_input(true)

func _input(event):
	if event is InputEventMouse:
		var mouse_event = event.duplicate()
		mouse_event.position = get_global_transform_with_canvas().affine_inverse() * event.position
		cotu._unhandled_input(mouse_event)
	else:
		cotu._unhandled_input(event)
