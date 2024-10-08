class_name EnemyHurtbox
extends Hurtbox

@export var hit_particle_color := Color.RED

var hit_score := 1.0
var kill_score := 1.0
var hit_particles := preload("res://enemies/enemy_hit_particles.tscn")
var rang_hit_particles := preload("res://rang/rang_hit_particles.tscn")
var rang_hit_effect := preload("res://rang/hit_effect1.tscn")
var death_particle := preload("res://enemies/death_particle.tscn")

func _ready():
	var enemy_name = parent.entity_name
	max_health = Globals.enemy_hurtbox_data[enemy_name][0]
	health = max_health
	hit_score = Globals.enemy_hurtbox_data[enemy_name][1]
	kill_score = Globals.enemy_hurtbox_data[enemy_name][2]
	super()

func receive_hit(damage: float, hitter):
	emit_hit_particles(hitter)
	if hitter.name == "Roserang":
		emit_hitter_effect(hitter)
	award_score(hitter)
	super(damage, hitter)

func emit_hit_particles(hitter):
	var inst := hit_particles.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = hitter.global_position
	inst.global_rotation.y = hitter.global_rotation.y + PI
	var particle_settings = inst.get_node("GPUParticles3D")
	particle_settings.emitting = true
	particle_settings.process_material.color = hit_particle_color

func emit_hitter_particles(hitter):
	var inst := rang_hit_particles.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = hitter.global_position
	inst.global_rotation.y = hitter.global_rotation.y + PI
	var particle_settings = inst.get_node("GPUParticles3D")
	particle_settings.emitting = true

func emit_hitter_effect(hitter):
	var inst := rang_hit_effect.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = hitter.global_position

func award_score(hitter):
	Globals.award_score(hit_score)
	if hitter.name == "Roserang":
		if hitter.get_mvmt_state() == "RICOCHET":
			Globals.award_score(Globals.RICOCHET_HIT_SCORE)
		elif hitter.get_mvmt_state() == "RAPIDORBIT":
			Globals.award_score(Globals.RAPIDORBIT_HIT_SCORE)
		elif hitter.get_mvmt_state() == "HOMING":
			Globals.award_score(Globals.HOMING_HIT_SCORE)

func death_effect():
	for i in range(dp_count):
		var dp = death_particle.instantiate()
		level.add_child(dp)
		dp.global_position = global_position
		dp.get_node("MeshInstance3D").mesh.material.albedo_color = hit_particle_color
		dp.apply_central_impulse(Vector3(rng.randf_range(-dp_impulse_limit, dp_impulse_limit), dp_impulse_limit*rng.randf(), rng.randf_range(-dp_impulse_limit, dp_impulse_limit)))

func die():
	Globals.award_score(kill_score)
	death_effect()
	super()
