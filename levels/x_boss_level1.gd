extends Level

@onready var x_health_bar := $UIRoot/XHealthBar
@onready var x_damage_indicator := $UIRoot/XHealthBar/DamageIndicator
@onready var x_hurtbox := $XBossArena1/XBoss/EnemyHurtbox

func _ready():
	$UIRoot.hide_black_screen()
	x_damage_indicator.max_value = x_hurtbox.max_health

func _physics_process(delta):
	x_health_bar.max_value = x_hurtbox.max_health
	x_health_bar.value = x_hurtbox.health
	x_damage_indicator.value = x_hurtbox.damage_indicator_value
