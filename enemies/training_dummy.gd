extends Node3D

@onready var hurtbox := $EnemyHurtbox
@onready var root := $/root/ViewControl
var ui: Control

func _ready():
	ui = root.find_child("UIRoot")
	hurtbox.hit_received.connect(update_damage_counter)

func update_damage_counter(damage: int):
	ui.update_damage_counter(damage)

func _physics_process(_delta):
	if Input.is_action_just_pressed("ResetDamageCounter"):
		ui.reset_damage_counter()
