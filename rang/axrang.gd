extends CharacterBody3D

enum {
	FWD,
	EXPLODE,
	RETURN
}
var mvmt_state = FWD

var invincible := true
var invincibility_secs := .5
var cotu_collider_radius := 1.4 
signal caught
signal hit_enemy

@export var rotate_speed := .5

var speed_buff_level := 0 
@export var fwd_speed := 55.0
@export var fwd_max_dist := 60.0
@export var return_speed := 55.0

@export var min_detonation_dist := 5.0 # Minimum distance required to detonate
@onready var start_pos := global_position

# PMD = pre-multiplier damage
var damage_multiplier := 1.0 
var main_hitbox_pmd := 0.0
var explosion_hitbox_pmd := 0.0

@onready var root := get_tree().root
var level : Node3D
var cotu : Node3D
var icon : Node3D

@onready var main_hitbox := $PlayerHitbox
@onready var pivot := $Pivot
@onready var explosion_hitbox := $ExplosionPivot/PlayerHitbox
@onready var explosion_particles := $ExplosionPivot/GPUParticles3D

@onready var flying_sfx := $FlyingAudioStream

func _ready():
	level = root.find_child("Level", true, false)
	cotu = root.find_child("cotuCB", true, false)
	icon = level.find_child("Icon")
	
	main_hitbox_pmd = Globals.player_hitbox_data.AxrangBaseDirectDamage
	explosion_hitbox_pmd = Globals.player_hitbox_data.AxrangBaseExplosionDamage
	update_hitbox_damage()
	
	global_position = cotu.global_position
	start_pos = global_position # Initialize the start position
	rotation.y = cotu.get_rang_throw_y_angle() + PI
	velocity = fwd_speed * transform.basis.z
	
	explosion_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	flying_sfx.play()

func set_direction(dir : Vector3):
	velocity = fwd_speed * dir

func _physics_process(_delta):
	if invincible and global_position.distance_to(cotu.global_position) > cotu_collider_radius:
		invincible = false
	
	if not invincible and global_position.distance_to(cotu.global_position) < cotu_collider_radius:
		caught.emit()
		queue_free()

	match(mvmt_state):
		FWD:
			pivot.rotate_x(rotate_speed)
			look_at(global_position + velocity)
			move_and_slide()
			
			if global_position.distance_to(cotu.global_position) > fwd_max_dist:
				advance_state()
		EXPLODE:
			pass
		RETURN:
			pivot.rotate_x(-rotate_speed)
			velocity = return_speed * global_position.direction_to(cotu.global_position)
			look_at(global_position + velocity)
			move_and_slide()

func advance_state():
	match(mvmt_state):
		FWD:
			# Check if we have traveled far enough from the starting point
			if global_position.distance_to(start_pos) >= min_detonation_dist:
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
	
	# Reset Speed
	speed_buff_level = 0
	fwd_speed = Globals.player_speed_data.AxrangFwdSpeedBase
	return_speed = Globals.player_speed_data.AxrangReturnSpeedBase

func buff_damage():
	main_hitbox_pmd = Globals.player_hitbox_data.AxrangDirectDamageBuff1
	explosion_hitbox_pmd = Globals.player_hitbox_data.AxrangExplosionDamageBuff1
	update_hitbox_damage()

func apply_damage_multiplier(mult: float):
	# Multipliers accumulate multiplicatively
	damage_multiplier *= 1 + mult
	update_hitbox_damage()

func buff_speed():
	speed_buff_level = clampi(speed_buff_level + 1, 0, 3)
	match speed_buff_level:
		1:
			fwd_speed = Globals.player_speed_data.AxrangFwdSpeedBuff1
			return_speed = Globals.player_speed_data.AxrangReturnSpeedBuff1
		2:
			fwd_speed = Globals.player_speed_data.AxrangFwdSpeedBuff2
			return_speed = Globals.player_speed_data.AxrangReturnSpeedBuff2
		3:
			fwd_speed = Globals.player_speed_data.AxrangFwdSpeedBuff3
			return_speed = Globals.player_speed_data.AxrangReturnSpeedBuff3
	update_speed()

func update_speed():
	if mvmt_state == FWD:
		# Maintain current direction but apply new forward speed
		velocity = velocity.normalized() * fwd_speed
	elif mvmt_state == RETURN:
		# Return logic calculates velocity dynamically, 
		# but we can cap it immediately to prevent a "jump" next frame
		velocity = velocity.limit_length(return_speed)

# Connected to main_hitbox's body_entered signal
func _on_hit_enemy(_body):
	hit_enemy.emit()
