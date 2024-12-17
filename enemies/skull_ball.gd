extends Ball

@onready var root := $/root/ViewControl
var target : Node3D
var follow_speed := 10.0

func _ready():
	target = root.find_child("Icon")

func _physics_process(delta):
	var dir_to_target := global_position.direction_to(target.global_position)
	linear_velocity.x = follow_speed * dir_to_target.x
	linear_velocity.z = follow_speed * dir_to_target.z
