class_name CotuHurtbox
extends Hurtbox

@export var base_recovery_rate := .25
@export var fast_recovery_rate := .5
var recovery_rate := .5
@export var recovery_delay := 1.0
var recovery_delay_remaining := 1.0
var recovery_active := false

var damage_indicator_value := 100.0

var destabilized = false

func reset_recovery_delay():
	recovery_delay_remaining = recovery_delay
	recovery_active = false

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
	if recovery_active and health < max_health:
		health += recovery_rate
		damage_indicator_value -= recovery_rate

func die():
	# AKA destabilize
	print("died")
	self_heal(1000)
	destabilized = true
