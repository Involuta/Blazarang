class_name ClarityShardHurtbox
extends EnemyHurtbox

func death_effect():
	if "death_effect" in hb_owner:
		hb_owner.death_effect()
		return
	for i in range(dp_count):
		var dp = death_particle.instantiate()
		level.add_child(dp)
		dp.global_position = global_position
		dp.get_node("MeshInstance3D").mesh.material.albedo_color = hit_particle_color
		dp.apply_central_impulse(Vector3(rng.randf_range(-dp_impulse_limit, dp_impulse_limit), dp_impulse_limit*rng.randf(), rng.randf_range(-dp_impulse_limit, dp_impulse_limit)))

func die():
	# To do: make effect for death
	hb_owner.visible = false
	# Even when process mode is disabled, this script can have its methods called by outside scripts, so Clarity can call regen()
	process_mode = Node.PROCESS_MODE_DISABLED

func regen():
	# To do: make effect for death
	hb_owner.visible = true
	process_mode = Node.PROCESS_MODE_INHERIT
