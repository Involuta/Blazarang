extends CharacterBody3D

@onready var anim_player := $MiniBallWalkerMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var hitbox : Node3D
var target : Node3D
enum {
	WALK,
	KICK,
	LEAP,
}
var behav_state := WALK
@export var max_leap_interval := 5.0 # Max time btwn leaps
@export var min_leap_interval := 1.0 # Min time btwn leaps
var time_until_next_leap := 5.0
var root_vel := Vector3.ZERO
var aiming_at_target := true

@export var follow_speed := 3.0
@export var turn_speed := .1
@export var kick_dist := 2.0
@export var kick_secs := 2.0
@export var leap_secs := 3.5

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true

func lerp_look_at_target(turn_speed):
	var dir_to_target := global_position.direction_to(target.global_position)
	rotation.y = lerp_angle(rotation.y, atan2(dir_to_target.x, dir_to_target.z), turn_speed)

func aim_at_target():
	aiming_at_target = true

func stop_aiming_at_target():
	aiming_at_target = false

func leap():
	velocity = 10 * transform.basis.z
	velocity.y += 3

func stop_mvmt():
	velocity = Vector3.ZERO

func _physics_process(delta):
	if aiming_at_target:
		lerp_look_at_target(turn_speed)
	
	match(behav_state):
		WALK:
			var current_rotation = transform.basis.get_rotation_quaternion()
			velocity = .08 * (current_rotation.normalized() * anim_tree.get_root_motion_position()) / delta
			
			if global_position.distance_to(target.global_position) < kick_dist:
				behav_state = KICK
				anim_tree.set("parameters/StateMachine/conditions/kick", true)
				await get_tree().create_timer(kick_secs).timeout
				anim_tree.set("parameters/StateMachine/conditions/kick", false)
				behav_state = WALK
			
			time_until_next_leap -= delta
			if time_until_next_leap <= 0:
				time_until_next_leap = rng.randf_range(min_leap_interval, max_leap_interval)
				behav_state = LEAP
				anim_tree.set("parameters/StateMachine/conditions/leap", true)
				await get_tree().create_timer(leap_secs).timeout
				anim_tree.set("parameters/StateMachine/conditions/leap", false)
				behav_state = WALK
		KICK:
			velocity = Vector3.ZERO
		LEAP:
			pass
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
