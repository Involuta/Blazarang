extends Node3D

var appear_time := .36
var bright_time := 4.5 # Time ring spends at full brightness
var fade_time := 4.5 # Time ring spends fading to nothing
var disappear_time := 2.0 # Time spent waiting for particles to disappear after ring disappears
@onready var ring_mesh := $RingMesh
@onready var cloud_particles := $CloudParticles

func _ready():
	ring_animation()

func ring_animation():
	var mat = ring_mesh.mesh.material as ShaderMaterial
	var t = create_tween()
	# Reset fade_alpha so that when it always starts out visible
	t.tween_property(mat, "shader_parameter/fade_alpha", 1.0, 0.0)
	t.tween_property(mat, "shader_parameter/progress", 1.2, appear_time).from(0.0).set_ease(Tween.EASE_IN_OUT)
	t.tween_interval(bright_time)
	t.tween_property(cloud_particles, "emitting", false, 0.0)
	t.tween_property(mat, "shader_parameter/fade_alpha", 0.0, fade_time).from(1.0)
	t.tween_interval(disappear_time)
	t.tween_callback(destroy_self)

func destroy_self():
	queue_free()
