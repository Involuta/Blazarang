extends Node3D

@export var disappear_secs := 5.0
@onready var anim_player := $AnimationPlayer

func _ready():
	await get_tree().create_timer(disappear_secs).timeout
	anim_player.play("disappear")
	await anim_player.animation_finished
	queue_free()
