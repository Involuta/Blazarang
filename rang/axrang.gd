extends CharacterBody3D

enum {
	FWD,
	EXPLODE,
	RETURN
}
var mvmt_state = FWD

var invincible := true
var invincibility_secs := .5
signal caught
signal hit_enemy

@export var rotate_speed := .5

@export var fwd_speed := 55.0
@export var fwd_max_dist := 60.0

@export var max_return_speed := 55.0
@export var return_acc := 1.2

# PMD = pre-multiplier damage
var damage_multiplier := 1.0 # Each hitbox's damage is pre multiplier damage * damage_multiplier)
var main_hitbox_pmd := 0.0
var explosion_hitbox_pmd := 0.0

@onready var root := $/root/ViewControl
var level : Node3D
var cotu : Node3D
var icon : Node3D

@onready var main_hitbox := $PlayerHitbox
@onready var pivot := $Pivot
@onready var explosion_hitbox := $ExplosionPivot/PlayerHitbox
@onready var explosion_particles := $ExplosionPivot/GPUParticles3D

@onready var flying_sfx := $FlyingAudioStream

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	icon = level.find_child("Icon")
	
	main_hitbox_pmd = Globals.player_hitbox_data.AxrangBaseDirectDamage
	explosion_hitbox_pmd = Globals.player_hitbox_data.AxrangBaseExplosionDamage
	update_hitbox_damage()
	
	global_position = cotu.global_position
	rotation.y = cotu.get_rang_throw_y_angle() + PI
	velocity = fwd_speed * transform.basis.z
	
	explosion_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	flying_sfx.play()

func set_direction(dir : Vector3):
	velocity = fwd_speed * dir

func _physics_process(_delta):
	# Deactivate invincibility once you're far enough from Cotu's body (diameter of CotuCollider)
	if invincible and global_position.distance_to(cotu.global_position) > 2.8:
		invincible = false
	
	# Emit caught signal
	if not invincible and global_position.distance_to(cotu.global_position) < 1:
		caught.emit()
		queue_free()
	match(mvmt_state):
		FWD:
			pivot.rotate_x(rotate_speed)
			look_at(global_position + velocity)
			move_and_slide()
			
			# If too far from Cotu, stop moving
			if global_position.distance_to(cotu.global_position) > fwd_max_dist:
				advance_state()
		EXPLODE:
			pass
		RETURN:
			pivot.rotate_x(-rotate_speed)
			velocity = max_return_speed * global_position.direction_to(cotu.global_position)
			look_at(global_position + velocity)
			move_and_slide()

func advance_state():
	match(mvmt_state):
		FWD:
			switch_to_explode()
		EXPLODE:
			switch_to_return()
		RETURN:
			pass

func switch_to_explode():
	mvmt_state = EXPLODE
	flying_sfx.stop()
	velocity = Vector3.ZERO
	$AnimationPlayer.play("explode")

func switch_to_return():
	mvmt_state = RETURN
	flying_sfx.play()

func is_returning():
	return mvmt_state == RETURN

# Used by CotuControl.gd for mutuality ability, which preserves roserang buffs as long as the axrang isn't stationary
func is_stationary():
	return mvmt_state == EXPLODE

func update_hitbox_damage():
	# If damage is boosted by 25%, damage_multiplier is 1.25
	main_hitbox.damage = main_hitbox_pmd * damage_multiplier
	explosion_hitbox.damage = explosion_hitbox_pmd * damage_multiplier

func reset_buffs():
	# Reset damage
	main_hitbox_pmd = Globals.player_hitbox_data.AxrangBaseDirectDamage
	explosion_hitbox_pmd = Globals.player_hitbox_data.AxrangBaseExplosionDamage
	update_hitbox_damage()

func buff_damage():
	main_hitbox_pmd = Globals.player_hitbox_data.AxrangDirectDamageBuff1
	explosion_hitbox_pmd = Globals.player_hitbox_data.AxrangExplosionDamageBuff1
	update_hitbox_damage()

func apply_damage_multiplier(mult: float):
	# Multipliers accumulate multiplicatively
	damage_multiplier *= 1 + mult

# Connected to main_hitbox's body_entered signal
func _on_hit_enemy(_body):
	hit_enemy.emit()
