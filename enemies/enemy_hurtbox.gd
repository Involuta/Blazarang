class_name EnemyHurtbox
extends Hurtbox

var hit_score := 1.0
var kill_score := 1.0
var death_particle := preload("res://enemies/death_particle.tscn")

func _ready():
	var enemy_name = parent.entity_name
	max_health = Globals.enemy_hurtbox_data[enemy_name][0]
	health = max_health
	hit_score = Globals.enemy_hurtbox_data[enemy_name][1]
	kill_score = Globals.enemy_hurtbox_data[enemy_name][2]
	super()

func receive_hit(damage: float, hitter):
	Globals.award_score(hit_score)
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
	Globals.award_score(kill_score)
	death_effect()
	super()
