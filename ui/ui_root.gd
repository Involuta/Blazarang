extends Control

@onready var cotu_health_bar := $CotuHealthBar
@onready var cotu_damage_indicator := $CotuHealthBar/DamageIndicator
@onready var destab_icon := $DESTABILIZED
@onready var destab_gradient := $DESTABILIZED/Gradient
@onready var destab_shader = $DESTABILIZED.material
@onready var glitch_box := $GlitchBox
@onready var glitch_shader = $GlitchBox.material
@onready var cotu_hurtbox := $/root/Level/cotuCB/Hurtbox

var destabilized = false

@export var destab_shader_opacity := .5
@export var glitch_shader_shake_power := .03
@export var glitch_shader_shake_color_rate := .02

func _ready():
	cotu_health_bar.modulate = Color.WHITE
	glitch_box.visible = false
	destab_icon.visible = false

func _physics_process(delta):
	cotu_health_bar.max_value = cotu_hurtbox.max_health
	cotu_health_bar.value = cotu_hurtbox.health
	cotu_damage_indicator.value = cotu_hurtbox.damage_indicator_value
	if cotu_hurtbox.parent.destabilized and not destabilized:
		destab_anim()
	destab_shader.set_shader_parameter("opacity", destab_shader_opacity)
	glitch_shader.set_shader_parameter("shake_power", glitch_shader_shake_power)
	glitch_shader.set_shader_parameter("shake_color_rate", glitch_shader_shake_color_rate)

func destab_anim():
	destabilized = true
	$DestabilizeAnimation.play("destabilize")
	$HealthBarAnimation.play("destabbed_health")
