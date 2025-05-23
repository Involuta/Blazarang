extends RigidBody3D
class_name Ball

@export var entity_name := "Ball"
@export var disappear_secs := 30.0

func _ready():
	await get_tree().create_timer(disappear_secs).timeout
	queue_free()

func _physics_process(_delta):
	if global_position.y < -100:
		queue_free()
