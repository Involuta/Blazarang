extends RigidBody3D

@export var entity_name := "Ball"

func _physics_process(_delta):
	if global_position.y < -100:
		queue_free()
