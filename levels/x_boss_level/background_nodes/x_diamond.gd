extends Node3D

@onready var eye := $EyeMesh
@onready var anim_player := $AnimationPlayer

@onready var root := $/root/ViewControl
var target : Node3D

var aiming_at_target := true

func _ready():
	target = root.find_child("Icon")
	await get_tree().create_timer(1).timeout
	anim_player.play("top_twist_out")
	await anim_player.animation_finished
	anim_player.play("shoot_laser")
	await anim_player.animation_finished
	anim_player.play("top_twist_in")

func set_target(new_target : Node3D):
	target = new_target

func _physics_process(_delta):
	if aiming_at_target:
		eye.look_at(target.global_position)

func stop_aiming_at_target():
	aiming_at_target = false
