extends Node3D

var velocity := Vector3.ONE
@export var max_lifetime_secs := 4.5
var invincible := true # allows bullet to go through corners
var invincibility_secs := .05
@export var bullet_explosion_secs := 1.0
var destroyed := false

var explosion_hitbox : Node3D

func _ready():
	explosion_hitbox = get_node_or_null("ExplosionHitboxPivot/EnemyHitbox")
	if explosion_hitbox != null:
		explosion_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

func _physics_process(delta):
	global_position += velocity * delta

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	for child in get_children():
		if not "Explosion" in child.name:
			child.queue_free()
	$ExplosionParticles.emitting = true
	$ExplosionBall.emitting = true
	if explosion_hitbox != null:
		explosion_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	await get_tree().create_timer(bullet_explosion_secs/4.0).timeout
	if explosion_hitbox != null:
		explosion_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(bullet_explosion_secs).timeout
	queue_free()

func _on_body_entered(_body):
	if not invincible:
		destroy_self()
