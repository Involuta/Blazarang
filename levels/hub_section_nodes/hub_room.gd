extends Node3D

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
	exit_door.position = Vector3(-10.25, 4.25, 0)

func _on_exit_room_body_entered(_body):
	# Move ExitDoor y pos from 4.25 to 1.75
	var tween = get_tree().create_tween()
	tween.tween_property(exit_door, "position", Vector3(-10.25, 1.75, 0), 1)
	tween.tween_property($OmniLight3D, "omni_range", 10, 1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(level_list.values()[level_list_pos])

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
	if Input.is_action_just_pressed("UIScrollLeft"):
		switch_panel_left()
	elif Input.is_action_just_pressed("UIScrollRight"):
		switch_panel_right()
