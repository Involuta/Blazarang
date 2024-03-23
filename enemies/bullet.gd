extends Node3D

var velocity := Vector3.ONE

func _physics_process(delta):
	global_position += velocity*delta

func _on_body_entered(_body):
	queue_free()
