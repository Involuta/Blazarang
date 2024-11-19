extends Area3D

@export var trauma_reduction_rate := 1.0
@export var max_x := 10.0
@export var max_y := 10.0
@export var max_z := 5.0
@export var noise_speed := 50.0
@export var noise : FastNoiseLite

var trauma := 0.0 # btwn 0 and 1 inclusive
var time := 0.0

@onready var cam := $Camera3D as Camera3D
@onready var initial_rotation := cam.rotation_degrees as Vector3

func _process(delta):
	time += delta
	trauma = max(trauma - trauma_reduction_rate * delta, 0)

	cam.rotation_degrees.x = initial_rotation.x + max_x * get_shake_intensity() * get_noise_from_seed(0)
	cam.rotation_degrees.y = initial_rotation.y + max_y * get_shake_intensity() * get_noise_from_seed(1)
	cam.rotation_degrees.z = initial_rotation.z + max_z * get_shake_intensity() * get_noise_from_seed(2)

func _physics_process(_delta):
	Globals.emit_signal("camera_updated", rotation)

func add_trauma(trauma_amount: float):
	trauma = clamp(trauma + trauma_amount, 0.0, 1.0)

func get_shake_intensity() -> float:
	return trauma * trauma

func get_noise_from_seed(_seed : int) -> float:
	noise.seed = _seed
	return noise.get_noise_1d(time * noise_speed)
