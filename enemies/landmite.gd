extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D
@onready var anim_player := $LandmiteMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var hitbox : Node3D
var target : Node3D
var aiming_at_target := true
enum {
	FOLLOW,
	BITE,
	LEAP,
}
var behav_state := FOLLOW
@export var target_distance := 2.0 # Dist from target necessary to bite
var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

@export var max_leap_interval := 5.0 # Max time btwn leaps
@export var min_leap_interval := 1.0 # Min time btwn leaps
var time_until_next_leap := 5.0
@export var leap_secs := 1.4
@export var leap_lateral_speed := 10.0
@export var leap_vertical_speed := 3.0

@export var follow_speed := 3.0
@export var follow_turn_speed := .1
@export var bite_dist := 2.0
@export var bite_secs := 1.833
@export var bite_cooldown_secs := 2.5
var bite_cooldown_remaining := 2.5

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	time_until_next_leap = leap_secs
	bite_cooldown_remaining = bite_cooldown_secs

func _physics_process(delta):
	match(behav_state):
		FOLLOW: 
			follow(delta)
		BITE:
			stop_lateral_mvmt()
		LEAP:
			pass
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func lerp_look_at_follow_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(velocity.x, velocity.z), turn_speed)

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW:
		if is_on_floor():
			# This line accelerates the agent rather than setting its velocity to its desired velocity directly, preventing it from getting caught on corners
			velocity = velocity.move_toward(safe_velocity, .25)
		else:
			# If the enemy is in the air, don't use navigation agent at all
			var move_dir = global_position.direction_to(target_position)
			velocity.x = follow_speed * move_dir.x
			velocity.z = follow_speed * move_dir.z
	move_and_slide()

func follow(delta):
	target_position = target.global_position
	
	lerp_look_at_follow_dir(follow_turn_speed)
	global_rotation.x = 0
	global_rotation.z = 0
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# If player isn't in sight, reduce target distance to a very small number
	if can_see_target():
		nav_agent.target_desired_distance = target_distance
	else:
		nav_agent.target_desired_distance = .1
		
	bite_cooldown_remaining -= delta
	if bite_cooldown_remaining <= 0 and global_position.distance_to(target.global_position) < bite_dist:
		bite_cooldown_remaining = bite_cooldown_secs
		behav_state = BITE
		await bite()
		behav_state = FOLLOW
	
	time_until_next_leap -= delta
	if time_until_next_leap <= 0:
		time_until_next_leap = rng.randf_range(min_leap_interval, max_leap_interval)
		behav_state = LEAP
		await leap()
		behav_state = FOLLOW

func bite():
	stop_lateral_mvmt()
	#anim_tree.set("parameters/StateMachine/conditions/bite", true)
	await get_tree().create_timer(bite_secs).timeout
	#anim_tree.set("parameters/StateMachine/conditions/bite", false)

func stop_lateral_mvmt():
	velocity.x = 0
	velocity.z = 0

func leap():
	#anim_tree.set("parameters/StateMachine/conditions/leap", true)
	velocity = leap_lateral_speed * -transform.basis.z
	velocity.y = leap_vertical_speed
	await get_tree().create_timer(leap_secs).timeout
	stop_lateral_mvmt()
	#anim_tree.set("parameters/StateMachine/conditions/leap", false)

func stop_aiming_at_target():
	aiming_at_target = false

func can_see_target():
	var space_state := get_world_3d().direct_space_state
	var sight_dir := global_position.direction_to(target.global_position)
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + nav_agent.neighbor_distance * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER, Globals.TARGET_COL_LAYER])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if not result:
		return true
	if result.collider.collision_layer == Globals.ARENA_COL_LAYER:
		return false
	else:
		return true
