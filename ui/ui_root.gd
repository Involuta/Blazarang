extends Control

@onready var cotu_health_bar := $CotuHealthBar
@onready var cotu_damage_indicator := $CotuHealthBar/DamageIndicator
@onready var cotu_hurtbox = $/root/Level/cotuCB/Hurtbox

func _physics_process(delta):
	cotu_health_bar.max_value = cotu_hurtbox.max_health
	cotu_health_bar.value = cotu_hurtbox.health
	cotu_damage_indicator.value = cotu_hurtbox.damage_indicator_value
