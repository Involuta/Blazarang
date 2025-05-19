extends CharacterBody3D

@onready var anim_player := $MiniBallWalkerMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hitbox : Node3D
var target : Node3D
@export var walk_moving := true # Whether walker is moving its central ball or not (it's not moving when both feet are on the ground and stationary). Exported so it can be changed in animation
var moving := true # Whether walker is approaching
var root_vel := Vector3.ZERO

@export var follow_speed := 3.0
@export var turn_speed := .1
@export var kick_dist := 2.0
@export var kick_secs := 1.5

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true

func lerp_look_at_target(turn_speed):
	var dir_to_target := global_position.direction_to(target.global_position)
	rotation.y = lerp_angle(rotation.y, atan2(dir_to_target.x, dir_to_target.z), turn_speed)

func _physics_process(delta):
	if moving:
		lerp_look_at_target(turn_speed)
		var current_rotation = transform.basis.get_rotation_quaternion()
		velocity = .08 * (current_rotation.normalized() * anim_tree.get_root_motion_position()) / delta
		velocity.y -= gravity
		move_and_slide()
		
		if global_position.distance_to(target.global_position) < kick_dist:
			moving = false
			anim_player.stop(false)
			anim_tree.set("parameters/StateMachine/conditions/kick", true)
			await get_tree().create_timer(kick_secs).timeout
			anim_tree.set("parameters/StateMachine/conditions/kick", false)
			moving = true
	else:
		velocity = Vector3.ZERO
