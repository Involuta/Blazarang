extends MeshInstance3D

var rng := RandomNumberGenerator.new()
@export var vibrating := false # Controlled by LaserCombo anim

func _physics_process(_delta):
	if vibrating:
		var s := rng.randf_range(1.0, 1.4)
		scale.x = s
		scale.z = s
