extends Node3D

var velocity := Vector3.ONE
@export var max_lifetime_secs := 4.5
var invincible := true # allows bullet to go through corners
var invincibility_secs := .05

func _ready():
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false
	await get_tree().create_timer(max_lifetime_secs).timeout
	if self:
		queue_free()

func _physics_process(delta):
	global_position += velocity*delta

func _on_body_entered(_body):
	if not invincible:
		queue_free()
