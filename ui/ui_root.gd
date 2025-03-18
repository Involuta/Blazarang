extends Control

@onready var cotu_health_bar := $CotuHealthBar
@onready var cotu_damage_indicator := $CotuHealthBar/DamageIndicator
@onready var destab_icon := $DESTABILIZED
@onready var destab_gradient := $DESTABILIZED/Gradient
@onready var destab_shader = $DESTABILIZED.material
@onready var glitch_box := $GlitchBox
@onready var glitch_shader = $GlitchBox.material
@onready var time_left := $TimeLeft

@onready var update_score_anim := $UpdateScoreAnimation

@onready var roserang_buff_icon1 := $RoserangBuffIcon1Pivot/RoserangBuffIcon1
var roserang_buff1_applied := false

@onready var axrang_buff_icon1 := $AxrangBuffIcon1Pivot/AxrangBuffIcon1
var axrang_buff1_applied := false

@onready var roserang_buff_anims := $RoserangBuffAnimations
@onready var axrang_buff_anims := $AxrangBuffAnimations

@onready var root := $/root/ViewControl
var cotu : Node3D
var cotu_hurtbox : Node3D
var cotu_icon : Node3D

@export var destab_shader_opacity := .5
@export var glitch_shader_shake_power := .03
@export var glitch_shader_shake_color_rate := .02

@onready var combo_display := $ComboDisplay
@onready var score_num_display := $ScoreNumDisplay

func _ready():
	cotu = root.find_child("cotuCB")
	cotu_hurtbox = cotu.find_child("Hurtbox")
	cotu_icon = root.find_child("Icon")

	cotu_health_bar.modulate = Color.WHITE
	cotu_damage_indicator.max_value = cotu_hurtbox.max_health
	glitch_box.visible = false
	destab_icon.visible = false
	roserang_buff_icon1.visible = false
	
	Globals.score_updated.connect(on_score_updated)
	Globals.destabilize.connect(on_destabilize)
	Globals.stabilize.connect(on_stabilize)
	
	for rose_buff in cotu.roserang_buff_list:
		match(rose_buff):
			Globals.BUFFS.DAMAGE:
				roserang_buff_icon1.texture = load("res://textures/buff_DMG-clear.png")
	for ax_buff in cotu.axrang_buff_list:
		match(ax_buff):
			Globals.BUFFS.DAMAGE:
				axrang_buff_icon1.texture = load("res://textures/buff_DMG-clear.png")

func roserang_buffs_cleared():
	return not roserang_buff1_applied

func axrang_buffs_cleared():
	return not axrang_buff1_applied

func awaken():
	$BlackScreenAnimations.play("awaken")

func hide_black_screen():
	$BlackScreen.modulate = Color(0,0,0,0)

func _physics_process(_delta):
	time_left.text = str("Time left: ", Globals.time_left)
	
	cotu_health_bar.max_value = cotu_hurtbox.max_health
	cotu_health_bar.value = cotu_hurtbox.health
	cotu_damage_indicator.value = cotu_hurtbox.damage_indicator_value
	destab_shader.set_shader_parameter("opacity", destab_shader_opacity)
	glitch_shader.set_shader_parameter("shake_power", glitch_shader_shake_power)
	glitch_shader.set_shader_parameter("shake_color_rate", glitch_shader_shake_color_rate)
	
	if cotu_hurtbox.parent.global_position.y < 0:
		$BlackScreenAnimations.play("death_fall")

func return_to_hub():
	get_tree().change_scene_to_file("res://levels/hub/hub_viewcontrol.tscn")

func on_destabilize():
	$DestabilizeAnimation.play("destabilize")
	$HealthBarAnimation.play("destabbed_health")

func on_stabilize():
	$DestabilizeAnimation.play("stabilize")
	$HealthBarAnimation.stop()
	$CotuHealthBar.modulate = Color.WHITE

func on_score_updated(score_change):
	score_num_display.text = str("SCORE: ", Globals.score)
	update_score_anim.stop()
	if score_change <= 1:
		update_score_anim.play("small_update_score")
	elif score_change <= 1.5:
		update_score_anim.play("med_update_score")
	elif score_change <= 2:
		update_score_anim.play("big_update_score")
	
	Globals.combo_count += 1
	combo_display.text = str("COMBO: ", Globals.combo_count)

func clear_roserang_buffs():
	roserang_buff1_applied = false
	roserang_buff_anims.play("clear_roserang_buffs")

func apply_roserang_buff1():
	if not roserang_buff1_applied:
		print("Roserang buffed!")
		roserang_buff1_applied = true
		roserang_buff_anims.play("apply_roserang_buff1")

func clear_axrang_buffs():
	print("Axrang buffs cleared!")
	axrang_buff1_applied = false
	axrang_buff_anims.play("clear_axrang_buffs")

func apply_axrang_buff1():
	if not axrang_buff1_applied:
		print("Axrang buffed!")
		axrang_buff1_applied = true
		axrang_buff_anims.play("apply_axrang_buff1")

func test():
	print("Test")
