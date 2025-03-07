extends Node3D

@onready var anim_player = $AnimationPlayer

func _ready():
	visible = false
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED
	Globals.activate_x_laser_combo_ball.connect(_on_activate)

func _on_activate():
	visible = true
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_INHERIT
	anim_player.play("grow")
	await get_tree().create_timer(11).timeout
	anim_player.play("shrink")
