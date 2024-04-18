extends Level

@onready var mega_gun = $EnemyMegaGun
@onready var launchpad = $Launchpad
@export var launchpad_vel := Vector3(0, 50, 0)

func _physics_process(delta):
	if not mega_gun:
		launchpad.constant_linear_velocity = launchpad_vel
