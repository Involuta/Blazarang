extends FogVolume

@export var appear_duration := .8
@export var lifetime_duration := 16.0
@export var disappear_duration := .8
@export var lifetime_density := 4.0

func _ready():
	# Increase density from 0 to 4
	var mite_fog_material = material
	var start_density = mite_fog_material.get_shader_parameter("density")
	var density_tween := get_tree().create_tween()
	density_tween.tween_method(
		func(v): mite_fog_material.set_shader_parameter("density", v),
		0,
		lifetime_density,
		appear_duration
	)
	density_tween.tween_interval(lifetime_duration)
	density_tween.tween_method(
		func(v): mite_fog_material.set_shader_parameter("density", v),
		lifetime_density,
		0,
		appear_duration
	)
	density_tween.tween_callback(disappear)

func disappear():
	queue_free()

func set_active(_active: bool):
	# This func is necessary bc mite_egg_fog is spawned in by mite arena, and mite arena calls set active on everything it spawns
	pass
