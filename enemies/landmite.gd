extends CharacterBody3D

#var tiny_mite := preload("res://enemies/mite_death_particle.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $ParamiteMeshes
@onready var anim_player := $ParamiteMeshes/AnimationPlayer
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
var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

var strafing_left := true
@export var strafe_radius := 15.0 # Dist btwn target and strafe dest

var ground_normal := Vector3.UP # Normal of the ground, determined by the avg normal of the planes formed by points where feet hit the ground

var init_leap_dir := Vector3.ONE # Set by arena script to a nonzero value when egg spawns mite. In start_leap(), if this var is not Vector3.ZERO, then landmite leaps in init_leap_dir, then sets init_leap_dir to Vector3.ZERO. If it is Vector3.ZERO, landmite leaps in body_meshes.transform.z
var can_leap := false # Landmite isn't supposed to leap immediately upon spawning (but it can)
@export var max_leap_cooldown := 3.0 # Max time after a leap ends before you can leap again
@export var min_leap_cooldown := .25 # Min time after a leap ends before you can leap again
var time_until_can_leap := 5.0 # Set to random(min_leap_cooldown, max_leap_cooldown) when reset. Sometimes not reset if a leap refresh randomly occurs
@export var leap_refresh_chance := .25 # Random chance to not reset time_until_can_leap after mite can leap, allowing it to potentially jump multiple times in quick succession
@export var roserang_leap_proximity := 30.0 # When the rang is this close or closer to the mite, the mite leaps
@export var leap_y_proximity := 2.5 # When (abs of) difference in y pos btwn target and mite is within leap_y_proximity, leap is canceled
@export var can_leap_window := 5.0 # Time you are able to leap on your own before a forced leap occurs
var time_until_forced_leap := 5.0 # Set to can_leap_window when reset
@export var leap_length_threshold := 12.0 # If mite is farther than this value from target, it'll do long leap; otherwise, short leap
@export var leap_short_lateral_speed := 24.0
@export var leap_long_lateral_speed := 36.0
@export var leap_vertical_speed := 6.0

@export var follow_speed := 10.0
@export var follow_turn_speed := .15
@export var bite_proximity := 3.4 # Proximity to target required to start bite
@export var bite_secs := .2
@export var bite_cooldown_secs := .5
var bite_cooldown_remaining := 2.5

@export var dp_impulse_limit := 5.0

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	anim_tree.active = true
	
	nav_agent.target_desired_distance = bite_proximity
	
	# Landmite isn't supposed to leap immediately upon spawning (but it can)
	time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
	
	bite_cooldown_remaining = bite_cooldown_secs

func _physics_process(delta):
	match(behav_state):
		FOLLOW: 
			follow(delta)
		STRAFE:
			strafe(delta)
		BITE:
			pass
		LEAP:
			leap_frame()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	
	if global_position.y < -100:
		queue_free()

func set_active(active):
	set_process(active)
	set_physics_process(active)
	if active:
		process_mode = Node.PROCESS_MODE_INHERIT
		add_to_group("lockonables")
	else:
		global_position.y = -50
		process_mode = Node.PROCESS_MODE_DISABLED
		remove_from_group("lockonables")

# Equivalent of lerp_look_at_move_dir or lerp_look_at_target in other enemies. This func is necessary for mites bc the mesh itself needs to rotate independently of the parent
# Rotate body meshes y rotation so that meshes look in the direction of the vector, which is a 3D vec whose y value is ignored
# Why not do rotation_amt = atan2(to_vec.x, to_vec.z) - body_meshes.rotation.y? It causes mites to spin around randomly for some reason
func rotate_y_to_vec(to_vec, turn_speed):
	var to_vec_2d = Vector2(to_vec.x, to_vec.z)
	var body_mesh_basis_z_2d = Vector2(body_meshes.transform.basis.z.x, body_meshes.transform.basis.z.z)
	var rotation_amt = body_mesh_basis_z_2d.angle_to(to_vec_2d)
	body_meshes.rotate_object_local(Vector3.UP, -rotation_amt * turn_speed)

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

func follow(delta):
	target_position = target.global_position
	
	rotate_y_to_vec(velocity, follow_turn_speed)
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# Scale anim playback speed based on movement speed
	anim_tree.set("parameters/playback_speed", velocity.length() / follow_speed)
	
	bite_cooldown_remaining -= delta
	if bite_cooldown_remaining <= 0 and global_position.distance_to(target.global_position) < bite_proximity:
		bite_cooldown_remaining = bite_cooldown_secs
		behav_state = BITE
		await bite()
		behav_state = FOLLOW
	
	if can_leap:
		time_until_forced_leap -= delta
		if time_until_forced_leap <= 0 or close_to_roserang():
			time_until_forced_leap = can_leap_window
			behav_state = LEAP
			start_leap()
	else:
		time_until_can_leap -= delta
		if time_until_can_leap <= 0:
			# Random chance for mite be able to leap immediately after a leap
			if rng.randf() > leap_refresh_chance:
				time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
			can_leap = true

func leap_frame():
	if is_on_floor():
		body_meshes.alignment_disabled = false
		behav_state = FOLLOW
		can_leap = false
		stop_lateral_mvmt()

func close_to_roserang():
	var roserang = level.find_child("Roserang", true, false)
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
	
	rotate_y_to_vec(velocity, follow_turn_speed)
	global_rotation.x = 0
	global_rotation.z = 0
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	bite_cooldown_remaining -= delta
	if bite_cooldown_remaining <= 0 and global_position.distance_to(target.global_position) < bite_proximity:
		bite_cooldown_remaining = bite_cooldown_secs
		behav_state = BITE
		await bite()
		behav_state = FOLLOW
	
	if can_leap:
		time_until_forced_leap -= delta
		if time_until_forced_leap <= 0 or close_to_roserang():
			time_until_forced_leap = can_leap_window
			behav_state = LEAP
			start_leap()
	else:
		time_until_can_leap -= delta
		if time_until_can_leap <= 0:
			time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
			can_leap = true

func bite():
	stop_lateral_mvmt()
	await get_tree().create_timer(.5).timeout

func stop_lateral_mvmt():
	velocity.x = 0
	velocity.z = 0

func start_leap():
	if abs(target_position.y - global_position.y) > leap_y_proximity:
		return
	
	var leap_dir = body_meshes.transform.basis.z
	
	body_meshes.alignment_disabled = true
	
	if global_position.distance_to(target_position) > leap_length_threshold:
		velocity = (leap_long_lateral_speed + rng.randf_range(-.5,.5)) * leap_dir
	else:
		velocity = (leap_short_lateral_speed + rng.randf_range(-.5,.5)) * leap_dir
	velocity.y = leap_vertical_speed + rng.randf_range(-.5,.5)

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
