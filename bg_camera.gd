extends Camera3D

var pos_mvmt_scale := .004

func _ready():
	Globals.cam_pos_updated.connect(update_position)
	Globals.cam_rot_updated.connect(update_rotation)

func update_position(new_pos: Vector3):
	global_position = pos_mvmt_scale * new_pos

func update_rotation(new_rot: Vector3):
	rotation = new_rot
