extends Level

var ui_root : Control
var frostbite_bar : Control
var frostbite_bar_damage_indicator : Control
var cotu_hurtbox : Node3D
var clarity : Node3D

func _ready():
	super()
	ui_root = root.find_child("UIRoot", true, false)
	frostbite_bar = ui_root.find_child("FrostbiteBar")
	frostbite_bar_damage_indicator = frostbite_bar.find_child("DamageIndicator")
	frostbite_bar_damage_indicator.value = 100
	cotu_hurtbox = cotu.find_child("Hurtbox")
	clarity = root.find_child("Clarity", true, false)
	ui_root.hide_black_screen()

func _physics_process(_delta):
	# Update UI
	frostbite_bar.max_value = cotu_hurtbox.current_frostbite_threshold
	frostbite_bar.value = cotu_hurtbox.frostbite_buildup

