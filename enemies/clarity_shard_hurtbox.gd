class_name ClarityShardHurtbox
extends EnemyHurtbox

var shard_destroyed := false
var mesh : MeshInstance3D
var mat : Material
var hitbox : Area3D

func _ready():
	super()
	# ClarityShardHurtbox is child of ShardOffset, which is a child of the dress shard bone, which contains everything needed by this script
	# Why not just put the DS bone in this script's Hurtbox Owner slot in the inspector? Because it keeps getting cleared whenever I reimport ClarityDressShards.glb for some reason
	
	hb_owner = get_parent().get_parent()
	# This is adjusted in code instead of inspector to save time (otherwise I'd have to click into every ClarityShardHurtbox and change all their colors individually)
	hit_particle_color = Color8(182, 222, 255)
	mesh = hb_owner.find_children("*", "MeshInstance3D", true, false)[0]
	mat = mesh.get_surface_override_material(0)
	hitbox = hb_owner.find_children("EnemyHitbox", "Area3D", true, false)[0]

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
	shard_destroyed = true
	# To do: make effect for death
	hb_owner.visible = false
	# Disable collision
	# set_deferred ensures that monitoring is only set outside of a physics frame, not during. If monitoring is set during a physics frame, the game breaks bc it has to calculate collision
	set_deferred("monitoring", false)
	hitbox.set_deferred("monitorable", false)

func regen():
	shard_destroyed = false
	# To do: make effect for regen
	hb_owner.visible = true
	# Restore collision
	# set_deferred ensures that monitoring is only set outside of a physics frame, not during. If monitoring is set during a physics frame, the game breaks bc it has to calculate collision
	set_deferred("monitoring", true)
	hitbox.set_deferred("monitorable", true)
	health = max_health
	
	# Make shards glow near ground level as they're pulled out of the ground
	var t = get_tree().create_tween()
	t.tween_property(mat, "shader_parameter/ground_glow_intensity", 2.4, 0)
	t.tween_property(mat, "shader_parameter/ground_glow_gradient_height", 3.6, 0)
	t.tween_property(mat, "shader_parameter/ground_glow_gradient_height", 0.0, 10.0)

func receive_hit(hitbox, hitter):
	# Glow to dim effect
	var t = get_tree().create_tween()
	t.tween_property(mat, "shader_parameter/emission_energy", 0.75, 0)
	t.tween_property(mat, "shader_parameter/emission_energy", 0.0, 0.6)
	super(hitbox, hitter)

func receive_hit_no_hitbox(damage):
	# Glow to dim effect
	var t = get_tree().create_tween()
	t.tween_property(mat, "emission_energy_multiplier", 1.2, 0)
	t.tween_property(mat, "emission_energy_multiplier", 0.0, 0.6)
	super(damage)
