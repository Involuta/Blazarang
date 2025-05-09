class_name CotuHurtbox
extends Hurtbox

var original_max_health := 100.0

var base_recovery_rate := .25
var fast_recovery_rate := .5
var recovery_rate := .5

var recovery_delay := 1.0
var recovery_delay_remaining := 1.0
@export var recovery_disabled := false # Exported so that it can be set via anim keyframes
var recovery_active := false # This really means "Cotu is trying to recover". If recovery_disabled, recovery_active does not recover stability

var damage_indicator_value := 100.0

var destab_invin_time := 2.0

# When Cotu gets grabbed, his position is set to the hitbox's parent
@export var opponent_grab_hitboxes := []

func _ready():
	super()
	original_max_health = Globals.cotu_max_health
	base_recovery_rate = Globals.cotu_base_regen_rate
	fast_recovery_rate = Globals.cotu_fast_regen_rate
	recovery_delay = Globals.cotu_regen_delay
	destab_invin_time = Globals.cotu_destabilize_invincibility_time
	
	damage_indicator_value = max_health
	Globals.stabilize.connect(on_stabilize)

func on_stabilize():
	max_health = original_max_health
	health = original_max_health
	damage_indicator_value = max_health

func reset_recovery_delay():
	recovery_delay_remaining = recovery_delay
	recovery_active = false

func on_hit(hitbox):
	if hitbox.name in opponent_grab_hitboxes:
		parent.grab_pos_node = hitbox.grab_pos_node
		parent.start_grab_anim(hitbox.name)
	else:
		super(hitbox)

func receive_hit(damage: float, hitter):
	if recovery_active:
		damage_indicator_value = health
	reset_recovery_delay()
	super(damage, hitter)

func self_hit(damage: float):
	if recovery_active:
		damage_indicator_value = health
	reset_recovery_delay()
	health -= damage
	if health <= 0:
		die()

func self_heal(heal: float):
	health += heal
	if health >= max_health:
		health = max_health

func set_fast_recovery_rate(is_fast: bool):
	if is_fast:
		recovery_rate = fast_recovery_rate
	else:
		recovery_rate = base_recovery_rate

func _physics_process(delta):
	recovery_delay_remaining -= delta
	if recovery_delay_remaining < 0:
		recovery_active = true
	if not recovery_disabled and recovery_active and health < max_health:
		health += recovery_rate
		damage_indicator_value -= recovery_rate

func die():
	# AKA destabilize
	if parent.destabilized:
		Engine.time_scale = .1
		parent.get_node("DeathParticles/GPUParticles3D").emitting = true
		await get_tree().create_timer(.5).timeout
		Engine.time_scale = 1
		get_tree().change_scene_to_file("res://levels/hub/hub_viewcontrol.tscn")
		return
	Globals.destabilize.emit()
	set_invincibility(true)
	health = 1
	max_health = 1
	await get_tree().create_timer(destab_invin_time).timeout
	set_invincibility(false)
