extends Node

# Tells X whether he grabbed Cotu after a grab attempt. Set by CotuHurtbox and CotuControl.
var XBossGrab := false

var time_left := 0

signal cam_pos_updated(new_pos: Vector3)
signal cam_rot_updated(new_rot: Vector3)
signal score_updated(score_change: int)
signal destabilize
signal stabilize
signal health_segment_lost(seg_num: int)
signal activate_x_laser_combo_ball

# Update this list before the layer names in Project Settings
const ROSERANG_COL_LAYER := 1
const ARENA_COL_LAYER := 2
const PARTICLE_COL_LAYER := 3
const ENEMY_COL_LAYER := 4
const COTU_COL_LAYER := 5
const TARGET_COL_LAYER := 6
const THICK_ENEMY_COL_LAYER := 7
const ENEMY_BOUND_COL_LAYER := 8
const AXRANG_COL_LAYER := 9

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
var combo_count := 0

enum BUFFS {
	DAMAGE,
	DEFENSE
}

const BUFF_SPRITES = {
	BUFFS.DAMAGE : "res://textures/buff_DMG-clear.png"
}

const DODGE_SCORE = 1
const INSTANT_RETHROW_SCORE = 1
const RICOCHET_HIT_SCORE = 1
const RAPIDORBIT_HIT_SCORE = 1
const HOMING_HIT_SCORE = 1

# These are vars in case they change as the player progresses
var cotu_max_health := 100.0
var cotu_regen_delay := 1.0 # time after a loss in stability before regen begins
var cotu_base_regen_rate := .25
var cotu_fast_regen_rate := .5
var cotu_destabilize_invincibility_time := 2.0

const player_hitbox_data = {
	"RoserangBaseDamage" : 10,
	"RoserangDamageBuff1" : 20,
	"AxrangBaseDirectDamage" : 25,
	"AxrangBaseExplosionDamage" : 10,
	"AxrangDirectDamageBuff1" : 50,
	"AxrangExplosionDamageBuff1" : 20,
}

# health, hit score, kill score
# Each key corresponds to an enemy's "entity name"
const enemy_hurtbox_data = {
	"GauntletMeleeTier1" : [20, 1.0, 1.0],
	"GauntletMeleeTier2" : [30, 1.0, 1.5],
	"GauntletMeleeTier3" : [40, 1.5, 2.0],
	"GauntletMobileGunner" : [10, 1.0, 1.0],
	"GauntletStationaryGunner" : [10, 1.0, 1.0],
	"GauntletMiniboss" : [500, 1.0, 10.0],
	
	"RollerBall" : [10, 1.0, 1.0],
	"BouncerBall" : [10, 1.0, 2.0],
	"GiantRollerBall" : [30, 1.0, 2.0],
	"GiantBouncerBall" : [10, 1.0, 2.0],
	"SkullBall" : [60, 1.0, 3.0],
	"PopperBall" : [10, 1.0, 1.0],
	
	"XBoss" : [200, 1.0, 100.0],
	
}

func award_score(points):
	# Apply multipliers/modifiers
	score += points * multiplier
	score_updated.emit(points)
