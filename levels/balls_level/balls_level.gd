extends Level

var ui_root : Control
var ball_walker_health_bar : Control
var ball_walker_damage_indicator : Control
var ball_walker_hurtbox : Node3D

func _ready():
	super()
	ui_root = root.find_child("UIRoot")
	ball_walker_health_bar = ui_root.find_child("BallWalkerHealthBar")
	ball_walker_damage_indicator = ball_walker_health_bar.find_child("DamageIndicator")
	ball_walker_hurtbox = root.find_child("BallWalker").find_child("EnemyHurtboxFlesh")
	ui_root.hide_black_screen()
	ball_walker_damage_indicator.max_value = ball_walker_hurtbox.max_health

func _physics_process(_delta):
	ball_walker_health_bar.max_value = ball_walker_hurtbox.max_health
	ball_walker_health_bar.value = ball_walker_hurtbox.health
	ball_walker_damage_indicator.value = ball_walker_hurtbox.damage_indicator_value
