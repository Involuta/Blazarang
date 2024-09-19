class_name BossHurtbox
extends EnemyHurtbox

@export var recovery_rate := .5
@export var recovery_delay := 1.0
var recovery_delay_remaining := 1.0
var recovery_active := false

var damage_indicator_value := 100.0

func _ready():
	super()
	damage_indicator_value = max_health

func reset_recovery_delay():
	recovery_delay_remaining = recovery_delay
	recovery_active = false

func receive_hit(damage: float, hitter):
	if recovery_active:
		damage_indicator_value = health
	reset_recovery_delay()
	super(damage, hitter)

func _physics_process(delta):
	super(delta)
	recovery_delay_remaining -= delta
	if recovery_delay_remaining < 0:
		recovery_active = true
	if recovery_active and health < max_health:
		health += recovery_rate
		damage_indicator_value -= recovery_rate
