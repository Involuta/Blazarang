extends Node3D

@export var run_speed := 5.0
@export var turn_speed := 1.0

func _process(delta):
	var move_dir = Input.get_vector("WalkLeft", "WalkRight", "WalkForward", "WalkBackward")
	translate(Vector3(0, 0, -move_dir.y) * run_speed * delta)
	rotate_object_local(Vector3.UP, -move_dir.x * turn_speed * delta)
