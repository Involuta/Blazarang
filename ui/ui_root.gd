extends Control

@onready var cotu_health_bar := $CotuHealthBar
@onready var cotu_damage_indicator := $CotuHealthBar/DamageIndicator
@onready var destab_icon := $DESTABILIZED
@onready var destab_gradient := $DESTABILIZED/Gradient
@onready var destab_shader = $DESTABILIZED.material
@onready var glitch_box := $GlitchBox
@onready var glitch_shader = $GlitchBox.material

@onready var update_score_anim := $UpdateScoreAnimation

@onready var cotu_hurtbox := $/root/Level/cotuCB/Hurtbox

var destabilized = false

@export var destab_shader_opacity := .5
@export var glitch_shader_shake_power := .03
@export var glitch_shader_shake_color_rate := .02

@onready var score_num_display := $ScoreNumDisplay

func _ready():
	cotu_health_bar.modulate = Color.WHITE
	glitch_box.visible = false
	destab_icon.visible = false
	
	Globals.score_updated.connect(on_score_updated)

func awaken():
	$BlackScreenAnimations.play("awaken")

func hide_black_screen():
	$BlackScreen.modulate = Color(0,0,0,0)

func _physics_process(_delta):
	cotu_health_bar.max_value = cotu_hurtbox.max_health
	cotu_health_bar.value = cotu_hurtbox.health
	cotu_damage_indicator.value = cotu_hurtbox.damage_indicator_value
	if cotu_hurtbox.parent.destabilized and not destabilized:
		destab_anim()
	destab_shader.set_shader_parameter("opacity", destab_shader_opacity)
	glitch_shader.set_shader_parameter("shake_power", glitch_shader_shake_power)
	glitch_shader.set_shader_parameter("shake_color_rate", glitch_shader_shake_color_rate)
	
	if cotu_hurtbox.parent.global_position.y < 0:
		$BlackScreenAnimations.play("death_fall")

func return_to_hub():
	get_tree().change_scene_to_file("res://levels/hub.tscn")

func destab_anim():
	destabilized = true
	$DestabilizeAnimation.play("destabilize")
	$HealthBarAnimation.play("destabbed_health")

func on_score_updated(score_change):
	score_num_display.text = str(Globals.score)
	update_score_anim.stop()
	if score_change <= 1:
		update_score_anim.play("small_update_score")
	elif score_change <= 1.5:
		update_score_anim.play("med_update_score")
	elif score_change <= 2:
		update_score_anim.play("big_update_score")
