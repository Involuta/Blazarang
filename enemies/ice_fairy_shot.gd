extends Node3D

var velocity := Vector3.ONE
@export var max_lifetime_secs := 4.5
var destroyed := false

@onready var anim_player := $AnimationPlayer

func _ready():
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

func _physics_process(delta):
	global_position += velocity * delta

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	anim_player.play("explode")
	await anim_player.animation_finished
	queue_free()

func _on_body_entered(_body):
	destroy_self()
