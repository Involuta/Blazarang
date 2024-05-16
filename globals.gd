extends Node

# Update this list before the layer names in Project Settings
const PLAYER_COL_LAYER := 1
const ARENA_COL_LAYER := 2
const PARTICLE_COL_LAYER := 3
const ENEMY_COL_LAYER := 4
const COTU_COL_LAYER := 5
const TARGET_COL_LAYER := 6
const THICK_ENEMY_COL_LAYER := 7

func make_mask(layers):
	var mask := 0.0
	for layer in layers:
		mask += pow(2, layer-1)
	return mask

var score := 0
var multiplier := 50

const DODGE_SCORE = 1
const INSTANT_RETHROW_SCORE = 1
const MELEE_HIT_SCORE = 1
const MELEE_KILL_SCORE = 2
const GUNNER_HIT_SCORE = 1
const GUNNER_KILL_SCORE = 2
const RICOCHET_HIT_SCORE = 1
const RAPIDORBIT_HIT_SCORE = 1

func award_score(points):
	# Apply multipliers/modifiers
	score += points * multiplier

enum BUFFS {
	DAMAGE,
	DEFENSE
}
