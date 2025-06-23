extends Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity := Vector3.ONE
@export var max_lifetime_secs := 9.0
var invincible := true # prevents bullet from hitting self
var invincibility_secs := .05
var grounded := false
@export var bullet_explosion_secs := 1.0
var destroyed := false

@onready var flight_particles := $FlightParticles
@onready var impact_particles := $ImpactParticles

func _ready():
	flight_particles.emitting = true
	impact_particles.emitting = false
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

func _physics_process(delta):
	if not grounded:
		global_position += velocity * delta
		velocity.y -= gravity * delta

func _on_body_entered(body):
	if invincible:
		return
	
	# Prevents collision with other ground webs and paramites; all non-paramites are thick enemies
	if Globals.compare_layers(body.collision_layer, Globals.ENEMY_COL_LAYER):
		pass
	elif Globals.compare_layers(body.collision_layer, Globals.ARENA_COL_LAYER):
		become_ground_web()
	else:
		destroy_self()
	

func become_ground_web():
	grounded = true
	velocity.y = 0
	$AnimationPlayer.play("become_ground_web")

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	for child in get_children():
		if not "Explosion" in child.name:
			child.queue_free()
	await get_tree().create_timer(bullet_explosion_secs).timeout
	queue_free()
