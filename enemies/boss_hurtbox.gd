class_name BossHurtbox
extends EnemyHurtbox

@export var recovery_rate := .5
@export var recovery_delay := 1.0
var recovery_delay_remaining := 1.0
var recovery_active := false

var damage_indicator_value := 100.0

@export var health_segment_thresholds := [0.0, .25, .5, .75, 1.0]
var health_segment_threshold_index := 3

func _ready():
	super()
	damage_indicator_value = max_health
	health_segment_threshold_index = health_segment_thresholds.size() - 2

func reset_recovery_delay():
	recovery_delay_remaining = recovery_delay
	recovery_active = false

func receive_hit(damage: float, hitter):
	if recovery_active:
		damage_indicator_value = health
	reset_recovery_delay()
	super(damage, hitter)
	if health_segment_threshold_index > 0 and health < max_health * health_segment_thresholds[health_segment_threshold_index]:
		health_segment_threshold_index -= 1
		print(health_segment_threshold_index + 1)

func _physics_process(delta):
	super(delta)
	recovery_delay_remaining -= delta
	if recovery_delay_remaining < 0:
		recovery_active = true
	if recovery_active:
		if health < max_health * health_segment_thresholds[health_segment_threshold_index + 1]:
			health += recovery_rate
		if damage_indicator_value > health:
			damage_indicator_value -= max_health * delta
