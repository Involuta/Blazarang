extends Node3D

@onready var upper_panel := $UpperPanel
@onready var middle_panel := $MiddlePanel
@onready var lower_panel := $LowerPanel
@onready var anim_player := $AnimationPlayer
@onready var exit_door := $ExitDoor

var panel_selected := false

@export var texture_value_dict := {
	"res://textures/3-VAR1_1.webp" : "res://levels/gauntlet_level1.tscn",
	"res://textures/8164.webp" : "res://levels/x_boss_level1.tscn"
}

var texture_value_dict_pos := 1

func _ready():
	middle_panel.position = Vector3(11.5, 3.5, -3)
	middle_panel.scale = .3 * Vector3.ONE
	middle_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])
	exit_door.position = Vector3(-10.25, 4.25, 0)

func _on_exit_room_body_entered(_body):
	# Move ExitDoor y pos from 4.25 to 1.75
	var tween = get_tree().create_tween()
	tween.tween_property(exit_door, "position", Vector3(-10.25, 1.75, 0), 1)
	tween.tween_property($OmniLight3D, "omni_range", 10, 1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file(texture_value_dict.values()[texture_value_dict_pos])

func scroll_up():
	middle_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])
	texture_value_dict_pos = (texture_value_dict_pos + 1) % texture_value_dict.size()
	lower_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])
	anim_player.play("scroll_up")
	
func scroll_down():
	middle_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])
	# mod (%) doesn't work because in Godot, negative mod positive is negative. According to Google, -1 mod 2 is 1, but in Godot, -1 mod 2 is -1.
	texture_value_dict_pos -= 1
	if texture_value_dict_pos <= -1:
		texture_value_dict_pos = texture_value_dict.size()-1
	lower_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])
	anim_player.play("scroll_down")

func file_to_texture(file):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	return texture

func _physics_process(_delta):
	if panel_selected:
		if Input.is_action_just_pressed("UIScrollUp"):
			scroll_up()
		elif Input.is_action_just_pressed("UIScrollDown"):
			scroll_down()
