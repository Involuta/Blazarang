class_name ClarityShardHurtbox
extends EnemyHurtbox

var mesh : Node3D

func _ready():
	super()
	mesh = hb_owner.find_children("*", "MeshInstance3D", false, false)[0]

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
	# To do: make effect for regen
	hb_owner.visible = true
	process_mode = Node.PROCESS_MODE_INHERIT

func receive_hit(hitbox, hitter):
	# Glow to dim effect
	var mat = mesh.get_surface_override_material(0)
	var t = get_tree().create_tween()
	t.tween_property(mat, "emission_energy_multiplier", 1, 0)
	t.tween_property(mat, "emission_energy_multiplier", 0.0, 0.6)
	super(hitbox, hitter)
