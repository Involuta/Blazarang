extends CharacterBody3D

@onready var anim_player := $MiniBallWalkerMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hitbox : Node3D
var target : Node3D
@export var walk_moving := true # Whether walker is moving its central ball or not (it's not moving when both feet are on the ground and stationary). Exported so it can be changed in animation
var moving := true # Whether walker is approaching

@export var follow_speed := 3.0
@export var turn_speed := .1
@export var kick_dist := 3.0
@export var kick_secs := 2.0

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	anim_player.play("walk")

func lerp_look_at_walk_dir(turn_speed):
	rotation.y = lerp_angle(rotation.y, atan2(velocity.x, velocity.z), turn_speed)

func _physics_process(_delta):
	if moving:
		velocity.y -= gravity
		var dir_to_target := global_position.direction_to(target.global_position)
		velocity.x = follow_speed * dir_to_target.x
		velocity.z = follow_speed * dir_to_target.z
		lerp_look_at_walk_dir(turn_speed)
		if walk_moving:
			move_and_slide()
		
		if global_position.distance_to(target.global_position) < kick_dist:
			moving = false
			anim_player.stop(false)
			anim_player.play("kick")
			await get_tree().create_timer(kick_secs).timeout
			anim_player.play("walk")
			moving = true
	else:
		velocity = Vector3.ZERO
