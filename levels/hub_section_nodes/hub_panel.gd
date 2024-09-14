extends Node3D

@onready var upper_panel := $UpperPanel
@onready var middle_panel := $MiddlePanel
@onready var lower_panel := $LowerPanel
@onready var anim_player := $AnimationPlayer

var selected := false

@export var texture_value_dict := {
	
}

var texture_value_dict_pos := 1

func _ready():
	middle_panel.scale = .3 * Vector3.ONE
	middle_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])

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
	upper_panel.texture = load(texture_value_dict.keys()[texture_value_dict_pos])
	anim_player.play("scroll_down")

func file_to_texture(file):
	var image = Image.load_from_file(file)
	var texture = ImageTexture.create_from_image(image)
	return texture

func get_panel_value():
	return texture_value_dict.values()[texture_value_dict_pos]

func _physics_process(_delta):
	if selected:
		if Input.is_action_just_pressed("UIScrollUp"):
			scroll_up()
		elif Input.is_action_just_pressed("UIScrollDown"):
			scroll_down()
