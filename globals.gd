extends Node

signal score_updated(score_change)

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

# "collision.get_collider().collision_layer" will return a layer number as a power of 2, but we're comparing it to a counting integer used in the editor
func compare_layers(collision_layer, global_layer):
	return collision_layer == pow(2, global_layer-1)

var score := 0
var multiplier := 50

const DODGE_SCORE = 1
const INSTANT_RETHROW_SCORE = 1
const RICOCHET_HIT_SCORE = 1
const RAPIDORBIT_HIT_SCORE = 1

# health, hit score, kill score
const enemy_hurtbox_data = {
	"EnemyMeleeTier1" : [20, 1.0, 1.0],
	"EnemyMeleeTier2" : [30, 1.0, 1.5],
	"EnemyMeleeTier3" : [40, 1.5, 2.0],
	"EnemyMobileGunner" : [10, 1.0, 1.0],
	"EnemyStationaryGunner" : [10, 1.0, 1.0],
	"FirstMiniboss" : [500, 1.0, 10.0]
}

func award_score(points):
	# Apply multipliers/modifiers
	score += points * multiplier
	score_updated.emit(points)

enum BUFFS {
	DAMAGE,
	DEFENSE
}
