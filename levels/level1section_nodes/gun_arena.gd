extends Level

@onready var loading_trigger = $LoadingTrigger
@onready var mega_gun = $EnemyMegaGun
@onready var launchpad = $Launchpad
@export var launchpad_vel := Vector3(0, 50, 0)

func _on_enemy_mega_gun_tree_exited():
	launchpad.constant_linear_velocity = launchpad_vel
	loading_trigger.attempt_load_resource()
