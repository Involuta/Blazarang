extends Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity := Vector3.ONE
@export var max_lifetime_secs := 9.0
var invincible := true # prevents bullet from hitting self
var invincibility_secs := .05
@export var egg_explosion_secs := 1.0
var destroyed := false

@onready var flight_particles := $FlightParticles
@onready var impact_particles := $ImpactParticles

@onready var root := $/root/ViewControl
var mite_arena : Node3D

# 1 = landmite, 2 = paramite, 3 = flatmite, 4 = harvestman, 5 = web
@export var type := 1

func _ready():
	mite_arena = root.find_child("MiteLevelMainArena")
	
	flight_particles.emitting = true
	impact_particles.emitting = false
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

# Func is called by mite_level_main_arena on both enemies and eggs, so eggs need this func
func set_active(_active):
	pass

func _physics_process(delta):
	if not destroyed:
		global_position += velocity * delta
		velocity.y -= gravity * delta

func _on_body_entered(body):
	if invincible:
		return
	
	# Prevents collision with ground webs and paramites; all non-paramites are thick enemies
	if Globals.compare_layers(body.collision_layer, Globals.ENEMY_COL_LAYER):
		pass
	elif Globals.compare_layers(body.collision_layer, Globals.ARENA_COL_LAYER):
		# Disable hitbox so spawned mites aren't hurt by egg
		$PlayerHitbox.process_mode = Node.PROCESS_MODE_DISABLED
		mite_arena.spawn_enemy_from_egg_at(global_position, type)
		destroy_self()

func destroy_self():
	$AnimationPlayer.play("explode")
	flight_particles.emitting = false
	impact_particles.emitting = true
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	await get_tree().create_timer(egg_explosion_secs).timeout
	queue_free()
