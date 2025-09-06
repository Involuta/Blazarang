extends CharacterBody3D

var spitweb := preload("res://enemies/spitweb.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $JumpingSpiderProcAnimMeshes
@onready var physical_collider := $CollisionShape3D
@onready var hurtbox := $EnemyHurtbox
@onready var anim_player := $JumpingSpiderProcAnimMeshes/JumpingSpiderMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var level : Node3D
var inner_hitbox : Node3D
var outer_hitbox : Node3D
var walk_dest_mesh : Node3D
var target : Node3D
enum {
	CURIOUS,
	WALK,
	AIM,
	READY,
	ATTACK,
	RETREAT,
}
var behav_state := WALK

@export var target_fov_angle := PI/4 # Max angle btwn target's body's fwd dir and dir from target to spider necessary for spider to be considered in target's FOV

var walk_dest := Vector3.ZERO
@export var walk_dest_dist_from_target := 30.0 # Starting from the target, go walk_dest_dist_from_target opposite the dir the target is facing. Get a flat circle around this point w radius walk_dest_dist_from_target. Get a random pt inside this circle, then fire a ray from high above onto the pt. If it's a valid pt, choose it. If not, increase the size of the circle, get another random pt, and fire another ray. Repeat until the pt is valid
@export var walk_dest_radius := 10.0
@export var walk_turn_speed := .5
@export var walk_speed := 50.0

@export var aim_turn_speed := .25
@export var aim_turning_start_vec_angle_max := PI/3.5
@export var aim_turning_start_vec_angle_min := PI/9
var aim_turning_start_vec_angle := PI/4 # Min y-axis angle btwn spider's fwd vec and vec from spider to target ("vec angle") necessary to start aim turning. Set to a random value btwn its max and min every turn
var aim_turning := false # Activated when vec angle > start_vec_angle, deactivated when vec angle < stop_vec_angle
@export var aim_turning_stop_vec_angle := .05 # Max vec angle necessary to stop aim turning
var aim_duration := 1.0 # Set to a random number btwn min and max aim duration
@export var aim_min_duration := 2.0
@export var aim_max_duration := 4.0

@export var ready_turn_speed := .25
@export var ready_min_duration := 2.5
@export var ready_max_duration := 5.0
var ready_duration := 1.0 # Set to a random number btwn min and max ready duration when ready state starts
var ready_triggered := false # Set to true when Cotu does an action that triggers the spider to initiate an attack
@export var ready_max_trigger_duration := .25
var ready_trigger_duration := .25 # Set to ready_max_trigger_duration when ready state begins. Only decreases when ready_triggered is true

@export var attack_total_duration := 1.0 # Duration of jump + endlag in secs
@export var attack_time_remaining := 1.0 # Decreases every frame, reset to attack_duration every attack
@export var attack_jump_duration := .25 # Duration of jump in secs
@export var attack_stop_dist := 3.3 # Max dist from spider to target needed to stop jump mvmt
var attack_jump_completed := false # Set to true when landing after jump, set to false at start of attack

@export var retreat_min_dist := 30.0 # Min dist spider runs away from target when retreating

func _ready():
	level = root.find_child("Level")
	# Jumping spider targets Cotu's body, not icon
	target = root.find_child("cotuCB")
	inner_hitbox = find_child("InnerMeleeHitboxPivot")
	outer_hitbox = find_child("OuterMeleeHitboxPivot")
	# Walk dest mesh may or may not exist
	walk_dest_mesh = root.find_child("WalkDestMesh")
	inner_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	outer_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	# Ensure that homing attacks hit the hurtbox and not the parent node, which stays on the ground. For any enemy whose hurtbox is at the same position as the parent node, this line can just be add_to_group("lockonables"), which makes the parent a lockonable
	hurtbox.add_to_group("lockonables")
	
	Globals.cotu_dodge.connect(ready_action_trigger)
	Globals.cotu_normal_throw_rose.connect(ready_action_trigger)
	
	switch_to_walk()

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		match(behav_state):
			WALK: 
				print("walk")
			AIM:
				print("aim")
			READY:
				print("ready")
			ATTACK:
				print("attack")
			RETREAT:
				print("retreat")
	match(behav_state):
		WALK: 
			walk_frame(delta)
		AIM:
			aim_frame(delta)
		READY:
			ready_frame(delta)
		ATTACK:
			attack_frame(delta)
		RETREAT:
			retreat_frame(delta)
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	if walk_dest_mesh:
		walk_dest_mesh.global_position = walk_dest
	move_and_slide()

# Equivalent of lerp_look_at_move_dir or lerp_look_at_target in other enemies. This func is necessary for mites bc the mesh itself needs to rotate independently of the parent
# Rotate body meshes y rotation so that its meshes look in the direction of the vector, which is a 3D vec whose y value is ignored
# Why not do rotation_amt = atan2(to_vec.x, to_vec.z) - body_meshes.rotation.y? It causes mites to spin around randomly for some reason
func rotate_y_to_vec(to_vec, turn_speed):
	var to_vec_2d = Vector2(to_vec.x, to_vec.z)
	var body_mesh_basis_z_2d = Vector2(body_meshes.transform.basis.z.x, body_meshes.transform.basis.z.z)
	var rotation_amt = body_mesh_basis_z_2d.angle_to(to_vec_2d)
	body_meshes.rotate_object_local(Vector3.UP, -rotation_amt * turn_speed)

# Get abs of angle btwn two 3D vecs that extend from the same point
func angle_btwn_3d_vecs(v1, v2) -> float:
	var v1_2D := Vector2(v1.x, v1.z)
	var v2_2D := Vector2(v2.x, v2.z)
	return abs(v1_2D.angle_to(v2_2D))

# Check whether a global position is within target's field of view (FOV)
func point_in_target_fov(pt: Vector3) -> bool:
	var target_to_pt_dir := target.global_position.direction_to(pt)
	var target_fwd_dir = target.get_fwd_dir()
	return angle_btwn_3d_vecs(target_to_pt_dir, target_fwd_dir) < target_fov_angle

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == WALK or behav_state == RETREAT:
		velocity = velocity.move_toward(safe_velocity, .5)
	move_and_slide()

func choose_walk_dest():
	"""
	Starting from the target, go walk_dest_dist_from_target opposite the dir the target is facing.
	Get a flat circle (or square) around this point w radius walk_dest_radius.
	Get a random pt inside this area, then fire a ray from high above onto the pt.
	If it's a valid pt, choose it. If not, increase the size of the area, get another random pt, and fire another ray. Repeat until the pt is valid
	Failsafe: set walk_dest to global pos
	"""
	var target_face_dir = target.get_fwd_dir()
	var walk_dest_center = target.global_position - walk_dest_dist_from_target * target_face_dir
	var walk_dest_candidate = walk_dest_center
	var temp_walk_dest_radius := walk_dest_radius
	var result = false
	var attempts := 10
	while not result or attempts > 0:
		attempts -= 1
		walk_dest_candidate.x = walk_dest_center.x + rng.randf_range(-temp_walk_dest_radius, temp_walk_dest_radius)
		walk_dest_candidate.z = walk_dest_center.z + rng.randf_range(-temp_walk_dest_radius, temp_walk_dest_radius)
		var space_state := get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(walk_dest_candidate + 100.0 * Vector3.UP, walk_dest_candidate + 200.0 * Vector3.DOWN)
		query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
		result = space_state.intersect_ray(query)
		if result:
			walk_dest = result.position
			return
		else:
			# Increase temp_walk_dest_radius by 10% if ray result isn't valid
			temp_walk_dest_radius += walk_dest_radius * .1
	# Failsafe: set walk_dest to current position
	walk_dest = global_position

func switch_to_walk():
	# Stop IK since you're leaving the ground
	body_meshes.start_ik()
	behav_state = WALK
	# Set walk dest
	choose_walk_dest()

func walk_frame(delta):
	rotate_y_to_vec(walk_dest - global_position, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		switch_to_aim()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func switch_to_aim():
	behav_state = AIM
	aim_duration = rng.randf_range(aim_min_duration, aim_max_duration)

func aim_frame(delta):
	velocity = Vector3.ZERO
	#  If y-axis angle btwn spider's forward dir and the dir from spider to target ("vec angle") is too high, turn towards target
	var body_fwd_dir = body_meshes.transform.basis.z
	var dir_to_target := global_position.direction_to(target.global_position)
	var angle_btwn_vecs := angle_btwn_3d_vecs(body_fwd_dir, dir_to_target)
	# Start turning when vec angle is above start_vec_angle
	if not aim_turning and angle_btwn_vecs > aim_turning_start_vec_angle:
		aim_turning_start_vec_angle = rng.randf_range(aim_turning_start_vec_angle_min, aim_turning_start_vec_angle_max)
		aim_turning = true
	if aim_turning:
		rotate_y_to_vec(target.global_position - global_position, aim_turn_speed)
		# Stop turning when vec angle is below stop_vec_angle
		if angle_btwn_vecs < aim_turning_stop_vec_angle:
			aim_turning = false
	
	aim_duration -= delta
	if aim_duration <= 0:
		switch_to_ready()

func ready_action_trigger():
	if behav_state == READY:
		ready_triggered = true

func switch_to_ready():
	behav_state = READY
	ready_duration = rng.randf_range(ready_min_duration, ready_max_duration)
	ready_trigger_duration = ready_max_trigger_duration

func ready_frame(delta):
	velocity = Vector3.ZERO
	rotate_y_to_vec(target.global_position - global_position, ready_turn_speed)
	ready_duration -= delta
	if ready_triggered:
		ready_trigger_duration -= delta
	if ready_duration <= 0.0 or ready_trigger_duration <= 0.0:
		#print("Ready duration: ", ready_duration)
		#print("Ready trigger duration: ", ready_trigger_duration)
		ready_triggered = false
		switch_to_attack()

func switch_to_attack():
	behav_state = ATTACK
	inner_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	outer_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	# Reset attack_time_remaining and attack_jump_completed
	attack_time_remaining = attack_total_duration
	attack_jump_completed = false
	# Stop body meshes IK
	body_meshes.stop_ik()
	# Jump towards target
	# Vel = distance / seconds
	velocity = .91 * (target.global_position - global_position) / attack_jump_duration

func attack_frame(delta):
	# If spider landed, stop checking if spider landed, turn on body meshes IK, and set vel to 0
	if not attack_jump_completed and global_position.distance_to(target.global_position) < attack_stop_dist:
		attack_jump_completed = true
		body_meshes.start_ik()
		velocity = Vector3.ZERO
	# Decrease attack time remaining. If it's <= 0, switch to retreat
	attack_time_remaining -= delta
	if attack_time_remaining <= 0:
		inner_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		outer_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		switch_to_retreat()

func choose_retreat_dest():
	"""
	Take the dir from target to spider, and starting from the target, go retreat_min_dist in that direction.
	Fire a ray from high above this point straight down.
	If it hits the arena, then set the walk dest to this.
	If not, reduce the dist by 10% and check again. Repeat until a valid point is obtained
	Failsafe: if a valid point is not found, set walk_dest to global pos
	"""
	# Raycast downward until you get result
	var temp_retreat_min_dist := retreat_min_dist
	var result = false
	while not result and temp_retreat_min_dist > 0:
		var retreat_vec := temp_retreat_min_dist * target.global_position.direction_to(global_position)
		var retreat_pt_candidate := target.global_position + retreat_vec
		var space_state := get_world_3d().direct_space_state
		var query = PhysicsRayQueryParameters3D.create(retreat_pt_candidate + 100.0 * Vector3.UP, retreat_pt_candidate + 200.0 * Vector3.DOWN)
		query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
		result = space_state.intersect_ray(query)
		if result:
			walk_dest = result.position
			return
		# Reduce vec by 10% if ray result isn't valid
		temp_retreat_min_dist -= retreat_min_dist * .1
	# Failsafe: set walk_dest to current position
	walk_dest = global_position

func switch_to_retreat():
	behav_state = RETREAT
	choose_retreat_dest()

func retreat_frame(delta):
	rotate_y_to_vec(walk_dest - global_position, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		switch_to_walk()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

