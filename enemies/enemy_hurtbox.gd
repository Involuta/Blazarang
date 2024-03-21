class_name EnemyHurtbox
extends Hurtbox

var death_particle := preload("res://enemies/death_particle.tscn")

func death_effect():
	for i in range(dp_count):
		var dp = death_particle.instantiate()
		arena.add_child(dp)
		dp.global_position = global_position
		dp.apply_central_impulse(Vector3(rng.randf_range(-dp_impulse_limit, dp_impulse_limit), dp_impulse_limit*rng.randf(), rng.randf_range(-dp_impulse_limit, dp_impulse_limit)))

func die():
	death_effect()
	super()
