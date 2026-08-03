extends Node3D

@onready var root := get_tree().root
var cam : Node3D

func _ready():
	cam = root.find_child("Camera3D", true, false)

func _physics_process(_delta):
	look_at(cam.global_position)
