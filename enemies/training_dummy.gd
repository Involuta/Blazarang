extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var hurtbox := $EnemyHurtbox
@onready var root := $/root/ViewControl
var ui: Control

func _ready():
	ui = root.find_child("UIRoot")
	hurtbox.add_to_group("lockonables")
	hurtbox.hit_received.connect(update_damage_counter)

func update_damage_counter(damage: int):
	ui.update_damage_counter(damage)

func _physics_process(_delta):
	velocity.y -= gravity
	if Input.is_action_just_pressed("ResetDamageCounter"):
		ui.reset_damage_counter()
	# move_and_slide is necessary for training dummy to be hit by axrang explosion hitbox for whatever reason
	move_and_slide()
