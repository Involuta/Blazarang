extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D
@onready var anim_player := $ParamiteMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hitbox : Node3D
var target : Node3D
enum {
	LAUNCH,
	FOLLOW,
	LEAP,
}
var behav_state := LAUNCH
@export var fall_height := 6.0 # Height from ground necessary to fall
var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

@export var follow_speed := 3.0
@export var follow_turn_speed := .1

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
