extends RigidBody3D
class_name Ball

@export var entity_name := "Ball"

func _ready():
	await get_tree().create_timer(30).timeout
	queue_free()

func _physics_process(_delta):
	if global_position.y < -100:
		queue_free()
