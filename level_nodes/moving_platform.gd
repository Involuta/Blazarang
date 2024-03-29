extends Level

var move_speed := 1.0
var spin_speed := .25
var moving := false
@onready var platform = $Platform
@onready var spawner_spinner = $Platform/SpawnerSpinner

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		moving = true
	if moving:
		platform.linear_velocity = move_speed * Vector3.UP
		spawner_spinner.rotate_y(spin_speed * delta)
