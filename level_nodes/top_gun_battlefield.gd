extends Level

@onready var platform = $FloatingPlatform
@export var platform_center := Vector3(-87, 40, 0)
@export var platform_angle_speed := 0.01
@export var platform_radius := 30
var platform_angle := 0.0
@onready var super_jump_pad = $JumpPads/SuperJumpPad
@export var wall_jump_pad_speed := 23
@export var floor_jump_pad_speed := 20
@export var super_jump_pad_speed := 45
var super_jump_pad_activated := false

func _ready():
	super()
	for child in $JumpPads.get_children():
		if child.name.contains("JumpPadWall"):
			child.constant_linear_velocity.y = wall_jump_pad_speed
		elif child.name.contains("JumpPadFloor"):
			child.constant_linear_velocity.y = floor_jump_pad_speed

func _physics_process(delta):
	platform_angle += platform_angle_speed
	var platform_vec = platform_radius * Vector2.from_angle(platform_angle)
	var new_position = platform_center + Vector3(platform_vec.x, 0, platform_vec.y)
	platform.constant_linear_velocity = (new_position - platform.global_position) / delta
	platform.global_position = new_position
	
	if Input.is_action_just_pressed("Special"):
		super_jump_pad_activated = true
	
	if super_jump_pad_activated:
		super_jump_pad.constant_linear_velocity.y = super_jump_pad_speed
