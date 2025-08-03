extends Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity := Vector3.ONE
@export var max_lifetime_secs := 9.0
var invincible := true # prevents bullet from hitting self
var invincibility_secs := .05
var grounded := false
@export var grounded_secs := 1.0 # Time tiny mite spends on ground before disappearing
@export var bullet_explosion_secs := 1.0
var destroyed := false

func _ready():
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
	
	# Prevents collision with ground webs and paramites
	if Globals.compare_layers(body.collision_layer, Globals.ENEMY_COL_LAYER):
		pass
	elif Globals.compare_layers(body.collision_layer, Globals.ARENA_COL_LAYER):
		velocity.y = 0
		await get_tree().create_timer(grounded_secs).timeout
		destroy_self()
	else:
		destroy_self()

func destroy_self():
	destroyed = true
	queue_free()
