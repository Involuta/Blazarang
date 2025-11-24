extends Node3D

@export var disappear_secs := 1.0

func _ready():
	await get_tree().create_timer(disappear_secs).timeout
	queue_free()

func set_active(_active: bool):
	# This func is necessary bc mite egg fog is spawned in by mite arena, and mite arena calls set active on everything it spawns
	pass
