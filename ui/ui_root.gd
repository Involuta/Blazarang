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
	glitch_box.visible = false
	destab_icon.visible = false

func _physics_process(delta):
	cotu_health_bar.max_value = cotu_hurtbox.max_health
	cotu_health_bar.value = cotu_hurtbox.health
	cotu_damage_indicator.value = cotu_hurtbox.damage_indicator_value
	if cotu_hurtbox.destabilized and not destabilized:
		destab_anim()
	if (destab_shader != null):
		destab_shader.set_shader_parameter("opacity", destab_shader_opacity)
	glitch_shader.set_shader_parameter("shake_power", glitch_shader_shake_power)
	glitch_shader.set_shader_parameter("shake_color_rate", glitch_shader_shake_color_rate)

func show_destabilized():
	destabilized = true
	glitch_box.visible = true
	destab_icon.visible = true
	var i = 1
	while i >= 0:
		destab_gradient.modulate = Color(1,1,1,i)
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
		i -= .03
	await get_tree().create_timer(.5).timeout
	i = 1
	destab_icon.material = null
	while i >= 0:
		destab_icon.modulate = Color(1,1,1,i)
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
		i -= .06
	destab_icon.visible = false

func destab_anim():
	destabilized = true
	$AnimationPlayer.play("destabilize")

func remove_destab_material():
	destab_icon.material = null
