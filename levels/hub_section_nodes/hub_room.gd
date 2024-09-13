extends Node3D

@onready var upper_level_panel := $LevelPanels/UpperLevelPanel
@onready var middle_level_panel := $LevelPanels/MiddleLevelPanel
@onready var lower_level_panel := $LevelPanels/LowerLevelPanel
@onready var anim_player := $AnimationPlayer
@onready var exit_door := $ExitDoor

enum PANELS {
	ITEM_PANEL,
	LEVEL_PANEL
}
var selected_panel := PANELS.ITEM_PANEL

var level_list := {
	"res://textures/3-VAR1_1.webp" : "res://levels/gauntlet_level1.tscn",
	"res://textures/8164.webp" : "res://levels/x_boss_level1.tscn"
}

var level_list_pos := 1

func _ready():
	middle_level_panel.position = Vector3(11.5, 3.5, -3)
	middle_level_panel.scale = .3 * Vector3.ONE
	middle_level_panel.texture = load(level_list.keys()[level_list_pos])
	exit_door.position = Vector3(-10.25, 4.25, 0)

func _on_exit_room_body_entered(_body):
	# Move ExitDoor y pos from 4.25 to 1.75
	var tween = get_tree().create_tween()
	tween.tween_property(exit_door, "position", Vector3(-10.25, 1.75, 0), 1)
	tween.tween_property($OmniLight3D, "omni_range", 10, 1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(level_list.values()[level_list_pos])

func scroll_up():
	middle_level_panel.texture = load(level_list.keys()[level_list_pos])
	level_list_pos = (level_list_pos + 1) % level_list.size()
	lower_level_panel.texture = load(level_list.keys()[level_list_pos])
	anim_player.play("scroll_up")
	
func scroll_down():
	middle_level_panel.texture = load(level_list.keys()[level_list_pos])
	# mod (%) doesn't work because in Godot, negative mod positive is negative. According to Google, -1 mod 2 is 1, but in Godot, -1 mod 2 is -1.
	level_list_pos -= 1
	if level_list_pos <= -1:
		level_list_pos = level_list.size()-1
	upper_level_panel.texture = load(level_list.keys()[level_list_pos])
	anim_player.play("scroll_down")

func file_to_texture(file):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	return texture

func switch_panel_left():
	selected_panel -= 1
	if selected_panel <= -1:
		selected_panel = PANELS.size()-1
	switch_panel()

func switch_panel_right():
	selected_panel = (selected_panel + 1) % PANELS.size()
	switch_panel()

func switch_panel():
	match(selected_panel):
		PANELS.ITEM_PANEL:
			print("item panel selected!")
		PANELS.LEVEL_PANEL:
			print("level panel selected!")
		_:
			pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("UIScrollUp"):
		scroll_up()
	elif Input.is_action_just_pressed("UIScrollDown"):
		scroll_down()
	elif Input.is_action_just_pressed("UIScrollLeft"):
		switch_panel_left()
	elif Input.is_action_just_pressed("UIScrollRight"):
		switch_panel_right()
