extends Level

var ui_root : Control
var frostbite_bar : Control
var frostbite_bar_damage_indicator : Control
var cotu_hurtbox : Node3D
@onready var blizzard_particles := $BlizzardParticles

func _ready():
	super()
	ui_root = root.find_child("UIRoot", true, false)
	frostbite_bar = ui_root.find_child("FrostbiteBar")
	frostbite_bar_damage_indicator = frostbite_bar.find_child("DamageIndicator")
	# Damage indicator is the background for the frostbite bar, so it's set to its max value
	frostbite_bar_damage_indicator.value = 100
	cotu_hurtbox = cotu.find_child("Hurtbox")
	ui_root.hide_black_screen()

func _physics_process(_delta):
	frostbite_bar.max_value = cotu_hurtbox.current_frostbite_threshold
	frostbite_bar.value = cotu_hurtbox.frostbite_buildup
	blizzard_particles.global_position = cotu.global_position + 30 * Vector3.UP
