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

@onready var roserang_buff_icon0 := $RoserangBuffIcon0Pivot/RoserangBuffIcon0
@onready var roserang_buff_icon1 := $RoserangBuffIcon1Pivot/RoserangBuffIcon1
@onready var roserang_buff_icon2 := $RoserangBuffIcon2Pivot/RoserangBuffIcon2
var roserang_buff_icons := [] # List of icon nodes
var roserang_buff_applied := [] # List of bools, where bool i is whether buff i has been applied

@onready var axrang_buff_icon0 := $AxrangBuffIcon0Pivot/AxrangBuffIcon0
@onready var axrang_buff_icon1 := $AxrangBuffIcon1Pivot/AxrangBuffIcon1
@onready var axrang_buff_icon2 := $AxrangBuffIcon2Pivot/AxrangBuffIcon2
var axrang_buff_icons := [] # List of icon nodes
var axrang_buff_applied := [] # List of bools, where bool i is whether buff i has been applied

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
	
	roserang_buff_icons = [roserang_buff_icon0, roserang_buff_icon1, roserang_buff_icon2]
	roserang_buff_applied = [false, false, false]
	
	axrang_buff_icons = [axrang_buff_icon0, axrang_buff_icon1, axrang_buff_icon2]
	axrang_buff_applied = [false, false, false]
	
	Globals.score_updated.connect(on_score_updated)
	Globals.destabilize.connect(on_destabilize)
	Globals.stabilize.connect(on_stabilize)
	
	for i in range(len(cotu.roserang_buff_list)):
		match(cotu.roserang_buff_list[i]):
			Globals.ROSERANG_BUFFS.DAMAGE:
				roserang_buff_icons[i].texture = load("res://textures/buff_DMG-clear.png")
			Globals.ROSERANG_BUFFS.HOMING:
				roserang_buff_icons[i].texture = load("res://textures/buff_HMG-clear.png")
			_:
				pass
	for i in range(len(cotu.axrang_buff_list)):
		match(cotu.axrang_buff_list[i]):
			Globals.AXRANG_BUFFS.DAMAGE:
				axrang_buff_icons[i].texture = load("res://textures/buff_DMG-clear.png")
			_:
				pass

func roserang_buffs_cleared():
	return not (true in roserang_buff_applied)

func axrang_buffs_cleared():
	return not (true in axrang_buff_applied)

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
	
	if cotu_hurtbox.hb_owner.global_position.y < 0:
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
	roserang_buff_applied.fill(false)
	roserang_buff_anims.play("clear_roserang_buffs")

func apply_roserang_buff(buff_index: int):
	if not roserang_buff_applied[buff_index]:
		roserang_buff_applied[buff_index] = true
		roserang_buff_anims.play("apply_roserang_buff" + str(buff_index))

func clear_axrang_buffs():
	axrang_buff_applied.fill(false)
	axrang_buff_anims.play("clear_axrang_buffs")

func apply_axrang_buff(buff_index: int):
	if not axrang_buff_applied[buff_index]:
		axrang_buff_applied[buff_index] = true
		axrang_buff_anims.play("apply_axrang_buff" + str(buff_index))
