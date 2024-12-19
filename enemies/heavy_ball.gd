extends Ball

var arena_floor_y := 10.0
@onready var physical_collider = $CollisionShape3D
@onready var hitbox := $EnemyHitbox

# Min speed necessary for ball to depress into the floor upon initial impact
# If this speed is not met, the ball starts sinking from its bottom
@export var depress_min_speed := 10.0

func _ready():
	hitbox.process_mode = Node.PROCESS_MODE_INHERIT

func _physics_process(delta):
	super(delta)
	if global_position.y <= arena_floor_y - physical_collider.shape.radius * 2:
		queue_free()
	if linear_velocity.length() > depress_min_speed:
		if global_position.y <= arena_floor_y + physical_collider.shape.radius / 2:
			linear_velocity = Vector3.ZERO
			hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	else:
		if global_position.y <= arena_floor_y + physical_collider.shape.radius + 1:
			linear_velocity = Vector3.ZERO
			hitbox.process_mode = Node.PROCESS_MODE_DISABLED
