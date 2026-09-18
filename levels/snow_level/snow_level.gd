extends Level

var ui_root : Control
var frostbite_bar : Control
var frostbite_bar_damage_indicator : Control
var cotu_hurtbox : Node3D
var clarity : Node3D
var clarity_health_bar : Control
var clarity_damage_indicator : Control
var clarity_hurtbox : Node3D

func _ready():
	super()
	ui_root = root.find_child("UIRoot", true, false)
	frostbite_bar = ui_root.find_child("FrostbiteBar")
	frostbite_bar_damage_indicator = frostbite_bar.find_child("DamageIndicator")
	frostbite_bar_damage_indicator.value = 100
	cotu_hurtbox = cotu.find_child("Hurtbox")
	clarity = root.find_child("Clarity", true, false)
	ui_root.hide_black_screen()
	
	clarity_health_bar = ui_root.find_child("ClarityHealthBar")
	clarity_damage_indicator = clarity_health_bar.find_child("DamageIndicator")
	clarity_hurtbox = clarity.find_child("HeadHurtbox")
	ui_root.hide_black_screen()
	clarity_damage_indicator.max_value = clarity_hurtbox.max_health

func _physics_process(_delta):
	# Update UI
	frostbite_bar.max_value = cotu_hurtbox.current_frostbite_threshold
	frostbite_bar.value = cotu_hurtbox.frostbite_buildup
	clarity_health_bar.max_value = clarity_hurtbox.max_health
	clarity_health_bar.value = clarity_hurtbox.health
	clarity_damage_indicator.value = clarity_hurtbox.damage_indicator_value
