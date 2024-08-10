extends Node3D

@onready var upper_level_panel := $UpperLevelPanel
@onready var middle_level_panel := $MiddleLevelPanel
@onready var lower_level_panel := $LowerLevelPanel
@onready var anim_player := $AnimationPlayer

var level_list := {
	"res://textures/3-VAR1_1.webp" : "res://levels/gauntlet_level1.tscn",
	"res://textures/8164.webp" : "res://levels/hub.tscn"
}

var level_list_pos := 0

var selected_level := "res://levels/gauntlet_level1.tscn"

func _ready():
	pass

func scroll_up():
	middle_level_panel.texture = load(level_list.keys()[level_list_pos])
	level_list_pos = (level_list_pos + 1) % level_list.keys().size()
	lower_level_panel.texture = load(level_list.keys()[level_list_pos])
	anim_player.play("scroll_up")
	
func scroll_down():
	middle_level_panel.texture = load(level_list.keys()[level_list_pos])
	level_list_pos = (level_list_pos - 1) % level_list.keys().size()
	upper_level_panel.texture = load(level_list.keys()[level_list_pos])
	anim_player.play("scroll_down")

func file_to_texture(file):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	return texture

func _physics_process(_delta):
	if Input.is_action_just_pressed("UIScrollUp"):
		scroll_up()
	elif Input.is_action_just_pressed("UIScrollDown"):
		scroll_down()
