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
	FALL,
}
var behav_state := LAUNCH

@export var launch_vert_speed := 10.0 # Initial vertical launch speed (lateral speed is set by paramite spawner)

@export var fall_height := 6.0 # Height from ground necessary to fall
var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

@export var follow_speed := 3.0
@export var follow_turn_speed := .1

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	#velocity.y = launch_vert_speed

func _physics_process(delta):
	match(behav_state):
		LAUNCH: 
			launch_frame(delta)
		FOLLOW:
			follow(delta)
		FALL:
			fall_frame(delta)
	
	move_and_slide()

func lerp_look_at_move_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(velocity.x, velocity.z), turn_speed)

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW:
		"""
		if is_on_floor():
			# This line accelerates the agent rather than setting its velocity to its desired velocity directly, preventing it from getting caught on corners
			velocity = velocity.move_toward(safe_velocity, .25)
		else:
			# If the enemy is in the air, don't use navigation agent at all
			var move_dir = global_position.direction_to(target_position)
			velocity.x = follow_speed * move_dir.x
			velocity.z = follow_speed * move_dir.z
		"""
		velocity = velocity.move_toward(safe_velocity, .25)
		#velocity.y = -.5
	move_and_slide()

func launch_frame(delta):
	if velocity.y <= .1:
		behav_state = FOLLOW
	
	if not is_on_floor():
		velocity.y -= gravity * delta

func follow(_delta):
	target_position = target.global_position
	
	lerp_look_at_move_dir(follow_turn_speed)
	global_rotation.x = 0
	global_rotation.z = 0
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func fall_frame(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
