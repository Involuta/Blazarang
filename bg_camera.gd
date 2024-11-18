extends Camera3D

func _ready():
	Globals.camera_updated.connect(update_rotation)

func update_rotation(new_rot: Vector3):
	rotation = new_rot
