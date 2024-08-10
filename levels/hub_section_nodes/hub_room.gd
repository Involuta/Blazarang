extends Node3D

@onready var anim_player = $AnimationPlayer

func _ready():
	pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("UIScrollUp"):
		anim_player.play("scroll_up")
	elif Input.is_action_just_pressed("UIScrollDown"):
		anim_player.play("scroll_down")
