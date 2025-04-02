extends Node3D

var velocity := Vector3.ONE
@export var max_lifetime_secs := 4.5
@export var disappear_secs := 1.0
var destroyed := false

var explosion_hitbox : Node3D

func _ready():
	$SparkleParticles.emitting = true
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

func _physics_process(delta):
	global_position += velocity * delta

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	$SparkleParticles.emitting = false
	await get_tree().create_tween().tween_property(self, "velocity", Vector3.ZERO, disappear_secs/2).finished
	queue_free()
