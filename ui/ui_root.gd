extends Control

@onready var cotu_health_bar := $CotuHealthBar
@onready var cotu_damage_indicator := $CotuHealthBar/DamageIndicator
@onready var destab_icon := $DESTABILIZED
@onready var cotu_hurtbox := $/root/Level/cotuCB/Hurtbox

var destabilized = false

func _physics_process(delta):
	cotu_health_bar.max_value = cotu_hurtbox.max_health
	cotu_health_bar.value = cotu_hurtbox.health
	cotu_damage_indicator.value = cotu_hurtbox.damage_indicator_value
	if cotu_hurtbox.destabilized and not destabilized:
		show_destabilized()

func show_destabilized():
	destabilized = true
	destab_icon.visible = true
	var i = 0
	while i < 1:
		destab_icon.modulate = Color(1,1,1,i)
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
		i += .1
