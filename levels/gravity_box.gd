extends Area3D

@export var gravity_multiplier := 1.0
@onready var cotu = $/root/Level/cotuCB

func _on_body_entered(body):
	if body == cotu:
		cotu.gravity = cotu.default_gravity * gravity_multiplier
