extends Ball

var arena_floor_y := 10.0
@onready var physical_collider = $CollisionShape3D

func _physics_process(delta):
	super(delta)
	if global_position.y <= arena_floor_y + physical_collider.shape.radius / 2:
		linear_velocity = Vector3.ZERO
