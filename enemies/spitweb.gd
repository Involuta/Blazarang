extends Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity := Vector3.ONE
@export var max_lifetime_secs := 4.5
var invincible := true # prevents bullet from hitting self
var invincibility_secs := .05
@export var bullet_explosion_secs := 1.0
var destroyed := false

func _ready():
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

func _physics_process(delta):
	global_position += velocity * delta
	velocity.y -= gravity * delta

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	for child in get_children():
		if not "Explosion" in child.name:
			child.queue_free()
	await get_tree().create_timer(bullet_explosion_secs).timeout
	queue_free()

func _on_body_entered(_body):
	if not invincible:
		destroy_self()
