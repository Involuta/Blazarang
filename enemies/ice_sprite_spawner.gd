extends Node3D

@export var max_brightness := 12.0
@export var min_brightness := 6.0
@export var appear_dim_time := 12.0
@export var max_height := 60.0
@export var rise_time := 60.0
@export var min_scale := 1.0
@export var max_scale := 6.0

@onready var root := get_tree().root
@onready var light := $OmniLight
var cam : Node3D

func _ready():
	cam = root.find_child("Camera3D", true, false)
	var t = get_tree().create_tween().set_parallel()
	t.tween_property(light, "light_energy", min_brightness, appear_dim_time).from(max_brightness)
	t.tween_property(self, "position", max_height*Vector3.UP, rise_time).as_relative()
	t.tween_property(self, "scale", max_scale*Vector3.ONE, rise_time).from(min_scale)

func _physics_process(_delta):
	look_at(cam.global_position)
