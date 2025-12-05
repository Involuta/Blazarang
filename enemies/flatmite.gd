extends CharacterBody3D

var spitweb := preload("res://enemies/spitweb.tscn")
@onready var physical_collider := $CollisionShape3D
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $FlatmiteMeshes
@onready var target_pos_mesh := $TargetPosMesh
@onready var hurtbox := $EnemyHurtbox # When mite falls off the map, it calls hurtbox's die func
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
	LEAP,
	LEAVE
}
var behav_state := FOLLOW
@export var target_position_distance := 2.0 # Dist from target position mite must be within in order to consider that location visited
var target_position := Vector3.ZERO # Position mite moves to

# Pre-leap startup
var can_leap := true
@export var max_leap_cooldown := 5.0 # Max time after a leap ends before you can leap (startup) again
@export var min_leap_cooldown := 2.0 # Min time after a leap ends before you can leap (startup) again
var time_until_can_leap := 5.0 # Set to random(min_leap_cooldown, max_leap_cooldown) when reset
@export var roserang_leap_proximity := 25.0 # When the rang is this far or farther from the mite, the mite leaps

# Leap startup
var in_leap_startup := false # Becomes true during leap startup; used to know whether to run twds target or not
@export var leap_startup_proximity := 10.0 # Dist from target needed during leap startup to initiate a leap

# Leap
@export var leap_secs := 1.2
@export var leap_length_threshold := 12.0 # If mite is farther than this value from target, it'll do long leap; otherwise, short leap
@export var leap_short_lateral_speed := 4.0
@export var leap_long_lateral_speed := 8.0
@export var leap_vertical_speed := 8.0
@export var spitweb_num := 10 # Number of spitweb projectiles shot
@export var spitweb_speed := 20.0 # Speed of a spitweb projectile
@export var spitweb_spread := .5 # X and Z vel of projectiles are changed by a random num btwn -spitweb_spread and spitweb_spread
var spitwebs_shot := false # Set to true after spitwebs are shot during leap; used to know whether to switch to follow upon touching floor

@export var follow_speed := 13.0
@export var follow_turn_speed := .2
@export var follow_random_dest_radius := 15.0 # Radius around target that mite target position can be within

var leaving := false # Used to know whether to leave arena
@export var leave_points := [ # Mite runs to the nearest point when evicted
	Vector3(96,28,96),
	Vector3(-96,28,96),
	Vector3(96,28,-96),
	Vector3(-96,28,-96),
]

@export var dp_impulse_limit := 5.0

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	#hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
	can_leap = true
	
	await get_tree().create_timer(1.0).timeout
	set_new_target_random_dest()

# Called by mite level main arena to clear arena for jumping spider
func evict():
	leaving = true

# Called by flatmite meshes to know whether to do ground slope orientation & offset correction
func is_leaping():
	return behav_state == LEAP

func _physics_process(delta):
	target_pos_mesh.global_position = target_position
	match(behav_state):
		FOLLOW: 
			follow_frame(delta)
		LEAP:
			leap_frame(delta)
		LEAVE:
			leave_frame()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	
	if global_position.y < -100:
		hurtbox.die()

func set_active(active):
	if active:
		process_mode = Node.PROCESS_MODE_INHERIT
		physical_collider.process_mode = Node.PROCESS_MODE_INHERIT
		add_to_group("lockonables")
		if hurtbox:
			hurtbox.health = hurtbox.max_health
	else:
		global_position.y = -50
		process_mode = Node.PROCESS_MODE_DISABLED
		remove_from_group("lockonables")
	visible = active
	set_process(active)
	set_physics_process(active)

# Equivalent of lerp_look_at_move_dir or lerp_look_at_target in other enemies. This func is necessary for mites bc the mesh itself needs to rotate independently of the parent
# Rotate body meshes y rotation so that it meshes look in the direction of the vector, which is a 3D vec whose y value is ignored
func rotate_y_to_vec(to_vec : Vector3, turn_speed : float):
	var rotation_amt = atan2(to_vec.x, to_vec.z) - body_meshes.rotation.y
	body_meshes.rotate_object_local(Vector3.UP, rotation_amt * turn_speed)

func set_new_target_random_dest():
	# From a point at the target's lateral pos but far above the floor, cast a ray straight down. If it hits the ground, set the target pos to that. If not, choose again
	var result = null
	while not result:
		var target_position_x = target.global_position.x + rng.randf_range(-follow_random_dest_radius, follow_random_dest_radius)
		var target_position_z = target.global_position.z + rng.randf_range(-follow_random_dest_radius, follow_random_dest_radius)
		target_position = Vector3(target_position_x, target.global_position.y, target_position_z)
		result = get_result_from_downray_at(target_position)
		if result:
			target_position.y = result.position.y

# Ray origin pos is just a lateral pos; its y doesn't matter
func get_result_from_downray_at(ray_origin_pos : Vector3) -> Dictionary:
	var space_state := get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ray_origin_pos + 30 * Vector3.UP, ray_origin_pos + 60.0 * Vector3.DOWN)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	return result

func _on_navigation_agent_3d_target_reached():
	if in_leap_startup:
		in_leap_startup = false
		switch_to_leap()
	else:
		set_new_target_random_dest()

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

func follow_frame(delta):
	if leaving:
		switch_to_leave()
		return
	
	if in_leap_startup:
		target_position = target.global_position
	
	rotate_y_to_vec(velocity, follow_turn_speed)
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# If player isn't in sight, reduce target distance to a very small number
	if in_leap_startup:
		nav_agent.target_desired_distance = leap_startup_proximity
	else:
		nav_agent.target_desired_distance = target_position_distance
	
	if can_leap:
		if far_from_roserang():
			can_leap = false
			in_leap_startup = true
			return
	else:
		time_until_can_leap -= delta
		if time_until_can_leap <= 0:
			time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
			can_leap = true

func far_from_roserang():
	var roserang = root.find_child("Roserang", true, false)
	if roserang == null:
		return false
	else:
		return global_position.distance_to(roserang.global_position) > roserang_leap_proximity

func stop_lateral_mvmt():
	velocity.x = 0
	velocity.z = 0

func switch_to_leap():
	behav_state = LEAP
	body_meshes.alignment_disabled = true
	spitwebs_shot = false
	
	if global_position.distance_to(target_position) > leap_length_threshold:
		velocity = (leap_long_lateral_speed + rng.randf_range(-.5,.5)) * body_meshes.transform.basis.z
	else:
		velocity = (leap_short_lateral_speed + rng.randf_range(-.5,.5)) * body_meshes.transform.basis.z
	velocity.y = leap_vertical_speed + rng.randf_range(-.5,.5)
	physical_collider.process_mode = Node.PROCESS_MODE_DISABLED
	await get_tree().create_timer(leap_secs/2).timeout
	shoot_spitwebs()
	spitwebs_shot = true
	physical_collider.process_mode = Node.PROCESS_MODE_INHERIT

func shoot_spitwebs():
	target_position = target.global_position
	for i in range(spitweb_num):
		var sw_inst = spitweb.instantiate()
		level.add_child.call_deferred(sw_inst)
		await sw_inst.tree_entered
		sw_inst.global_position = hitbox.global_position
		var spit_dir := hitbox.global_position.direction_to(target_position)
		spit_dir += Vector3(rng.randf_range(-spitweb_spread, spitweb_spread), rng.randf_range(0, spitweb_spread/2), rng.randf_range(-spitweb_spread, spitweb_spread))
		sw_inst.velocity = spitweb_speed * spit_dir

func leap_frame(_delta):
	rotate_y_to_vec(target_position - global_position, follow_turn_speed)
	if spitwebs_shot and is_on_floor():
		switch_to_follow()

func switch_to_follow():
	behav_state = FOLLOW
	body_meshes.alignment_disabled = false
	stop_lateral_mvmt()

func stop_aiming_at_target():
	aiming_at_target = false

func switch_to_leave():
	behav_state = LEAVE
	# Get closest leave point to current global position
	target_position = leave_points[0]
	for i in range(1, len(leave_points)):
		var current_leave_point = leave_points[i]
		if global_position.distance_to(current_leave_point) < global_position.distance_to(target_position):
			target_position = current_leave_point

func leave_frame():
	rotate_y_to_vec(velocity, follow_turn_speed)
	if global_position.distance_to(target_position) < leap_length_threshold:
		# When close to the target position, maintain velocity (do nothing)
		start_leave_leap()
		return
	
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# Scale anim playback speed based on movement speed
	anim_tree.set("parameters/playback_speed", clamp(velocity.length() / follow_speed, 0.01, 10))

func start_leave_leap():
	behav_state = LEAP
	var arena_center := Vector3.ZERO
	var leap_dir = arena_center.direction_to(global_position)
	
	body_meshes.alignment_disabled = true
	
	velocity = (leap_short_lateral_speed + rng.randf_range(-.5,.5)) * leap_dir
	velocity.y = 2 * leap_vertical_speed + rng.randf_range(-.5,.5)
	
	rotate_y_to_vec(velocity, 1)

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
