extends Node3D

@onready var anim_player := $AnimationPlayer

func _ready():
	await get_tree().create_timer(1).timeout
	anim_player.play("top_twist_out")
	await anim_player.animation_finished
	anim_player.play("shoot_laser")
	await anim_player.animation_finished
	anim_player.play("top_twist_in")
