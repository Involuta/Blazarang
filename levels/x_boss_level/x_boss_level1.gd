extends Level

var ui_root : Control
var x_health_bar : Control
var x_damage_indicator : Control
var x_hurtbox : Node3D

func _ready():
	ui_root = root.find_child("UIRoot")
	x_health_bar = ui_root.find_child("XHealthBar")
	x_damage_indicator = x_health_bar.find_child("DamageIndicator")
	x_hurtbox = root.find_child("XBoss").find_child("EnemyHurtbox")
	ui_root.hide_black_screen()
	x_damage_indicator.max_value = x_hurtbox.max_health

func _physics_process(_delta):
	x_health_bar.max_value = x_hurtbox.max_health
	x_health_bar.value = x_hurtbox.health
	x_damage_indicator.value = x_hurtbox.damage_indicator_value
