extends RigidBody3D

var rng := RandomNumberGenerator.new()

@export var roll_dir := Vector2.LEFT
@export var roll_speed := 5.0
@export var roll_dir_variation := 1.0

func _ready():
	var actual_roll_dir2D := roll_dir + rng.randf_range(-roll_dir_variation, roll_dir_variation) * roll_dir.orthogonal()
	linear_velocity = roll_speed * Vector3(actual_roll_dir2D.x, 0, actual_roll_dir2D.y)
