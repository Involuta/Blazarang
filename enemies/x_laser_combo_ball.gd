extends Node3D

@onready var anim_player := $AnimationPlayer
@onready var vibrating_ball_mesh := $VibratingBallMesh
@export var vibrating_ball_size := 1.0 # Used by anims
var vibrating_ball_size_range := .2
var rng := RandomNumberGenerator.new()

func _ready():
	visible = false
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_DISABLED
	Globals.activate_x_laser_combo_ball.connect(_on_activate)

func _on_activate():
	visible = true
	for child in get_children():
		child.process_mode = Node.PROCESS_MODE_INHERIT
	"""
	anim_player.play("grow")
	await get_tree().create_timer(11).timeout
	anim_player.play("shrink")
	"""
	# 10.5 secs btwn grow and shrink
	anim_player.play("grow")
	# Laser combo startup is 2.5 secs long
	await get_tree().create_timer(2.5).timeout
	# Laser overhead at 4.68 secs after laser combo starts
	await get_tree().create_timer(2.7).timeout
	anim_player.play("explosion")
	await get_tree().create_timer(5.4).timeout
	anim_player.play("shrink")

func _physics_process(_delta):
	vibrating_ball_mesh.scale = (vibrating_ball_size+vibrating_ball_size_range*rng.randf()) * Vector3.ONE
