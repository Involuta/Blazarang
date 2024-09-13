extends Node3D

@onready var item_panel := $ItemPanel
@onready var level_panel := $LevelPanel
@onready var exit_door := $ExitDoor

var panel_list_pos := 0

var panel_list

func _ready():
	panel_list = [item_panel, level_panel]
	panel_list[panel_list_pos].selected = true
	exit_door.position = Vector3(-10.25, 4.25, 0)

func _on_exit_room_body_entered(_body):
	# Move ExitDoor y pos from 4.25 to 1.75
	var tween = get_tree().create_tween()
	tween.tween_property(exit_door, "position", Vector3(-10.25, 1.75, 0), 1)
	tween.tween_property($OmniLight3D, "omni_range", 10, 1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(level_panel.get_panel_value())

func file_to_texture(file):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	return texture

func switch_panel_left():
	panel_list[panel_list_pos].selected = false
	panel_list_pos -= 1
	if panel_list_pos <= -1:
		panel_list_pos = panel_list.size()-1
	panel_list[panel_list_pos].selected = true

func switch_panel_right():
	panel_list[panel_list_pos].selected = false
	panel_list_pos = (panel_list_pos + 1) % panel_list.size()
	panel_list[panel_list_pos].selected = true

func _physics_process(_delta):
	if Input.is_action_just_pressed("UIScrollLeft"):
		switch_panel_left()
	elif Input.is_action_just_pressed("UIScrollRight"):
		switch_panel_right()
