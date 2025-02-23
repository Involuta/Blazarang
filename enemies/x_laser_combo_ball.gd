extends Node3D

func _ready():
	visible = false
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED
	Globals.activate_x_laser_combo_ball.connect(_on_activate)

func _on_activate():
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_INHERIT
	$AnimationPlayer.play("grow")
