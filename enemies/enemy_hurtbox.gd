class_name EnemyHurtbox
extends Hurtbox

@export var hit_score := 1
@export var kill_score := 1
var death_particle := preload("res://enemies/death_particle.tscn")

func receive_hit(damage: float, hitter):
	match(parent.name):
		"EnemyMeleeTier1":
			Globals.award_score(Globals.MELEE_HIT_SCORE)
		"EnemyGunnerTier2":
			Globals.award_score(Globals.GUNNER_HIT_SCORE)
	if hitter.name == "Roserang":
		if hitter.get_mvmt_state() == "RICOCHET":
			Globals.award_score(Globals.RICOCHET_HIT_SCORE)
		elif hitter.get_mvmt_state() == "RAPIDORBIT":
			Globals.award_score(Globals.RAPIDORBIT_HIT_SCORE)
	super(damage, hitter)

func death_effect():
	for i in range(dp_count):
		var dp = death_particle.instantiate()
		level.add_child(dp)
		dp.global_position = global_position
		dp.apply_central_impulse(Vector3(rng.randf_range(-dp_impulse_limit, dp_impulse_limit), dp_impulse_limit*rng.randf(), rng.randf_range(-dp_impulse_limit, dp_impulse_limit)))

func die():
	match(parent.name):
		"EnemyMelee":
			Globals.award_score(Globals.MELEE_KILL_SCORE)
		"EnemyGunner":
			Globals.award_score(Globals.GUNNER_KILL_SCORE)
	death_effect()
	super()
