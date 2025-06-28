extends Node3D

@export var disappear_secs := 1.0

func _ready():
	await get_tree().create_timer(disappear_secs).timeout
	queue_free()
