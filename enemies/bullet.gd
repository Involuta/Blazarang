extends Node3D

var velocity := Vector3.ONE
@export var max_lifetime_secs := 4.5
var invincible := true # allows bullet to go through corners
var invincibility_secs := .05
@export var bullet_explosion_secs := 1.0
var destroyed := false

func _ready():
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false
	await get_tree().create_timer(max_lifetime_secs).timeout
	if self and not destroyed:
		destroy_self()

func _physics_process(delta):
	global_position += velocity*delta

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	$EnemyHitbox.queue_free()
	$BulletMesh.queue_free()
	$TailParticles.queue_free()
	$ExplodeParticles.emitting = true
	$ExplosionBall.emitting = true
	await get_tree().create_timer(bullet_explosion_secs).timeout
	queue_free()

func _on_body_entered(_body):
	if not invincible:
		destroy_self()
