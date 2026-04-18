extends Node

# Tells X whether he grabbed Cotu after a grab attempt. Set by CotuHurtbox and CotuControl.
var XBossGrab := false

var time_left := 0

signal cam_pos_updated(new_pos: Vector3)
signal cam_rot_updated(new_rot: Vector3)
signal score_updated(score_change: int)
signal cotu_dodge
signal cotu_normal_throw_rose
signal cotu_power_throw_rose
signal cotu_instant_rethrow_rose
signal cotu_throw_ax
signal enemy_killed(enemy_name: String)
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

enum ROSERANG_BUFFS {
	DAMAGE,
	HOMING,
	DUPLICATE,
}

# All roserang instances look at and use this
var roserang_buff_list := [Globals.ROSERANG_BUFFS.DAMAGE]

enum AXRANG_BUFFS {
	DAMAGE,
	SPEED,
}

enum SIGILS {
	EMPTY,
	MAX_STABILITY_BOOST,
	AUTO_ROSERANG_BUFF,
	REGENERATOR
}

enum DEBUFFS {
	NONE,
	SLOW,
	INFEST,
	FROSTBITE_S1,
	FROSTBITE_S2,
	FROSTBITE_S3,
}

const BUFF_SPRITES = {
	ROSERANG_BUFFS.DAMAGE : "res://textures/buff_DMG-clear.png"
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
	"AxrangBaseOverheadDamage" : 100,
	"ShurikenBaseDamage" : 1,
	"FireballBaseDamage" : 100,
	"MarkDetonationDamage" : 200,
}

const player_speed_data = {
	"AxrangFwdSpeedBase" : 55,
	"AxrangReturnSpeedBase" : 50,
	"AxrangFwdSpeedBuff1" : 110,
	"AxrangReturnSpeedBuff1" : 100,
	"AxrangFwdSpeedBuff2" : 165,
	"AxrangReturnSpeedBuff2" : 140,
	"AxrangFwdSpeedBuff3" : 210,
	"AxrangReturnSpeedBuff3" : 190,
}

# health, hit score, kill score
# Each key corresponds to an enemy's "entity name"
const enemy_hurtbox_data = {
	"TrainingDummy" : [999999999, 1.0, 1.0],
	
	"GauntletMeleeTier1" : [20, 1.0, 1.0],
	"GauntletMeleeTier2" : [30, 1.0, 1.5],
	"GauntletMeleeTier3" : [40, 1.5, 2.0],
	"GauntletMobileGunner" : [10, 1.0, 1.0],
	"GauntletStationaryGunner" : [10, 1.0, 1.0],
	"GauntletMiniboss" : [500, 1.0, 10.0],
	
	"RollerBall" : [100, 1.0, 1.0],
	"BouncerBall" : [10, 1.0, 2.0],
	"GiantRollerBall" : [30, 1.0, 2.0],
	"GiantBouncerBall" : [10, 1.0, 2.0],
	"SkullBall" : [70, 1.0, 3.0],
	"PopperBall" : [10, 1.0, 1.0],
	"BallWalkerArmor" : [100, 1.0, 1.0],
	"BallWalker" : [2000, 1.0, 1.0],
	
	"XBoss" : [400, 1.0, 100.0],
	
	"Landmite" : [75, 1.0, 1.0],
	"Paramite" : [35, 1.0, 1.0],
	"Flatmite" : [25, 1.0, 1.0],
	"Harvestman" : [10, 1.0, 1.0],
	"JumpingSpider" : [800, 1.0, 1.0],
	
	"Clarity" : [3000, 1.0, 100.0],
}

func rotate_toward(from: float, to: float, delta: float) -> float:
	var difference := wrapf(to - from, -PI, PI)
	var step = clamp(difference, -delta, delta)
	return from + step

func award_score(points):
	# Apply multipliers/modifiers
	score += points * multiplier
	score_updated.emit(points)

func basis_from_normal(transform, normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	
	return result
