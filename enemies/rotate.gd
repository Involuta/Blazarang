extends RigidBody3D

func _ready():
	await get_tree().create_timer(5.0).timeout
	queue_free()
