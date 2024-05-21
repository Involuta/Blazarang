extends Control

@onready var cotu_health_bar := $CotuHealthBar
@onready var cotu_hurtbox = $/root/Level/cotuCB/Hurtbox

func _process(delta):
	cotu_health_bar.value = cotu_hurtbox.health
