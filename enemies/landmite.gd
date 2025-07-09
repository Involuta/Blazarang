extends CharacterBody3D

#var tiny_mite := preload("res://enemies/mite_death_particle.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var meshes := $ParamiteProcAnimMeshes
@onready var anim_player := $ParamiteProcAnimMeshes/ParamiteMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var level : Node3D
var hitbox : Node3D
var target : Node3D
var aiming_at_target := true
enum {
	FOLLOW,
	STRAFE,
	BITE,
	LEAP,
}
var behav_state := FOLLOW
@export var target_distance := 1.0 # Dist from target necessary to bite
var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

var strafing_left := true
@export var strafe_radius := 15.0 # Dist btwn target and strafe dest

var ground_normal := Vector3.UP # Normal of the ground, determined by the avg normal of the planes formed by points where feet hit the ground

var can_leap := true
@export var max_leap_cooldown := 3.0 # Max time after a leap ends before you can leap again
@export var min_leap_cooldown := .25 # Min time after a leap ends before you can leap again
var time_until_can_leap := 5.0 # Set to random(min_leap_cooldown, max_leap_cooldown) when reset
@export var roserang_leap_proximity := 30.0 # When the rang is this close or closer to the mite, the mite leaps
@export var can_leap_window := 5.0 # Time you are able to leap on your own before a forced leap occurs
var time_until_forced_leap := 5.0 # Set to can_leap_window when reset
@export var leap_secs := 1.0
@export var leap_length_threshold := 12.0 # If mite is farther than this value from target, it'll do long leap; otherwise, short leap
@export var leap_short_lateral_speed := 5.0
@export var leap_long_lateral_speed := 11.0
@export var leap_vertical_speed := 5.0

@export var follow_speed := 3.5
@export var follow_turn_speed := .1
@export var bite_dist := 1.0
@export var bite_secs := .5
@export var bite_cooldown_secs := 2.5
var bite_cooldown_remaining := 2.5

@export var dp_impulse_limit := 5.0

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	#hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
	can_leap = true
	time_until_forced_leap = can_leap_window
	
	bite_cooldown_remaining = bite_cooldown_secs
	
	add_to_group("lockonables")

func _physics_process(delta):
	match(behav_state):
		FOLLOW: 
			follow(delta)
		STRAFE:
			strafe(delta)
		BITE:
			stop_lateral_mvmt()
		LEAP:
			pass
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func lerp_look_at_move_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, atan2(velocity.x, velocity.z), turn_speed)

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
	
	lerp_look_at_move_dir(follow_turn_speed)
	#print(ground_normal)
	global_rotation.x = 0#atan2(ground_normal.y, ground_normal.z)
	global_rotation.z = 0#atan2(ground_normal.y, ground_normal.x)
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
	
	if can_leap:
		time_until_forced_leap -= delta
		if time_until_forced_leap <= 0 or close_to_roserang():
			time_until_forced_leap = can_leap_window
			behav_state = LEAP
			await leap()
			behav_state = FOLLOW
			can_leap = false
	else:
		time_until_can_leap -= delta
		if time_until_can_leap <= 0:
			time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
			can_leap = true

func close_to_roserang():
	var roserang = root.find_child("Roserang", true, false)
	if roserang == null:
		return false
	else:
		return global_position.distance_to(roserang.global_position) < roserang_leap_proximity

func strafe(delta):
	var dir_to_target := global_position.direction_to(target.global_position)
	var dir_to_target2D := Vector2(dir_to_target.x, dir_to_target.z)
	var icon_vec := dir_to_target2D.orthogonal()
	if strafing_left:
		icon_vec *= -1
	target_position = target.global_position + strafe_radius * Vector3(icon_vec.x, 0, icon_vec.y)
	
	lerp_look_at_move_dir(follow_turn_speed)
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
	
	if can_leap:
		time_until_forced_leap -= delta
		if time_until_forced_leap <= 0 or close_to_roserang():
			time_until_forced_leap = can_leap_window
			behav_state = LEAP
			await leap()
			behav_state = FOLLOW
			can_leap = false
	else:
		time_until_can_leap -= delta
		if time_until_can_leap <= 0:
			time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
			can_leap = true

func bite():
	stop_lateral_mvmt()
	#anim_tree.set("parameters/StateMachine/conditions/bite", true)
	await get_tree().create_timer(bite_secs).timeout
	#anim_tree.set("parameters/StateMachine/conditions/bite", false)

func stop_lateral_mvmt():
	velocity.x = 0
	velocity.z = 0

func leap():
	# Stop IK
	meshes.stop_ik()
	#anim_tree.set("parameters/StateMachine/conditions/leap", true)
	if global_position.distance_to(target_position) > leap_length_threshold:
		velocity = (leap_long_lateral_speed + rng.randf_range(-.5,.5)) * transform.basis.z
	else:
		velocity = (leap_short_lateral_speed + rng.randf_range(-.5,.5)) * transform.basis.z
	velocity.y = leap_vertical_speed + rng.randf_range(-.5,.5)
	await get_tree().create_timer(leap_secs).timeout
	stop_lateral_mvmt()
	# Do IK again
	meshes.start_ik()
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

func death_effect():
	"""
	var me_inst = mite_explosion.instantiate()
	level.add_child.call_deferred(me_inst)
	await me_inst.tree_entered
	me_inst.global_position = global_position
	"""
	"""
	for i in range(10):
		var tm_inst = tiny_mite.instantiate()
		level.add_child.call_deferred(tm_inst)
		await tm_inst.tree_entered
		tm_inst.global_position = global_position
		tm_inst.apply_central_impulse(Vector3(rng.randf_range(-dp_impulse_limit, dp_impulse_limit), dp_impulse_limit*rng.randf(), rng.randf_range(-dp_impulse_limit, dp_impulse_limit)))
	"""
