extends CharacterBody3D

var spitweb := preload("res://enemies/spitweb.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $JumpingSpiderProcAnimMeshes
@onready var physical_collider := $CollisionShape3D
@onready var hurtbox := $JumpingSpiderProcAnimMeshes/JumpingSpiderMeshes/EnemyHurtbox
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
	FARAWAY,
	HISS,
	AIM,
	READY,
	ATTACK,
	RETREAT,
}
var behav_state := WALK

@export var arena_max_radius := 120.0 # Spider won't set walk dest to any point laterally outside this value

@export var target_fov_angle := PI/4 # Max angle btwn target's body's fwd dir and dir from target to spider necessary for spider to be considered in target's FOV
@export var leg_step_time_moving := .0167 # Time it takes for each leg to make a step when spider is walking/retreating
@export var leg_step_time_stationary := .1 # Time it takes for each leg to make a step when spider is aiming/ready

var walk_dest := Vector3.ZERO
@export var walk_max_duration := 6.0 # If spider keeps recalculating walk dest and never makes it to the dest, it stops walking after this many seconds
var walk_duration := 6.0 # Set to walk_max_duration at start of walk state
@export var walk_dest_dist_from_target := 60.0 # Starting from the target, go walk_dest_dist_from_target opposite the dir the target is facing. Get a flat circle around this point w radius walk_dest_radius. Get a random cardinal pt on the circumference of this circle, then fire a ray from high above onto the pt. If it's a valid pt, choose it. If not, increase the size of the circle, get another random pt, and fire another ray. Repeat until the pt is valid
@export var walk_dest_radius := 10.0
@export var walk_turn_speed := .5
@export var walk_speed := 60.0
@export var walk_min_speed := 30.0 # Unless the spider wants to move at least this fast, it doesn't move at all. This prevents it from drifting slowly when changing direction and makes its mvmt more erratic
var can_stop := false # Once the spider reaches above walk_min_speed, can_stop is true. When the spider goes below walk_min_speed and can_stop, it stops moving instead of moving slowly, and can_stop is set to false. After being stopped for a bit, it's allowed to accelerate again
@export var stop_time_min := .1 # Min length of time spider stops moving due to reaching low speed
@export var stop_time_max := 1.0 # Min length of time spider stops moving due to reaching low speed
var stop_time_remaining := 1.0 # Stop time remaining before spider can accelerate again

@export var faraway_chance := .5 # Chance of choosing faraway instead of walk
@export var faraway_dest_radius := 90.0 # Dist from arena center that a faraway dest usually is

@export var leave_chance := .5 # Chance of jumping out of arena (i.e. at walk_dest at edge of arena) instead of at target whenever entering aim state
var aiming_at_target := true # If this is false, then aim, ready, and jump states aim at walk_dest instead of target
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
@export var ready_min_full_duration := 2.5
@export var ready_max_full_duration := 5.0
var ready_full_duration := 1.0 # The duration of the ready state when no action triggers the spider to jump. Set to a random number btwn min and max ready duration when ready state starts. Always decreases during Ready state
var ready_triggered := false # Set to true when Cotu does an action that triggers the spider jump
@export var ready_max_trigger_duration := .4
var ready_trigger_duration := .25 # The duration of the ready state when an action triggers the spider to jump. Set to ready_max_trigger_duration when ready state begins. Only decreases when ready_triggered is true
@export var ready_front_leg_raise_time := .2 # When either ready_duration is <= ready_front_leg_raise_time, front legs begin to rise. Actual time it takes for front legs to rise is set in transition from idle to ready state in anim tree

@export var attack_jump_duration := .25 # Duration of jump in secs
@export var attack_stop_dist := 3.0 # Max dist from spider to jump dest needed to stop jump mvmt
var attack_jump_completed := false # Set to true when landing after jump, set to false at start of attack
@export var attack_total_duration := 3.0 # Duration of jump + chase in secs
var attack_time_remaining := 5.0 # Decreases every frame, reset to attack_total_duration before every jump
var hit_received_while_attacking := false # Set to true when spider is hit while attacking, false outside of attack state

@export var retreat_min_dist := 60.0 # Min dist spider runs away from target when retreating

func _ready():
	level = root.find_child("Level")
	# Jumping spider targets Cotu's body, not icon
	target = root.find_child("cotuCB")
	inner_hitbox = find_child("InnerMeleeHitboxPivot")
	outer_hitbox = find_child("OuterMeleeHitboxPivot")
	# Walk dest mesh may or may not exist
	walk_dest_mesh = root.find_child("WalkDestMesh")
	inner_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	outer_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	anim_tree.active = true
	
	# Ensure that homing attacks hit the hurtbox and not the parent node, which stays on the ground. For any enemy whose hurtbox is at the same position as the parent node, this line can just be add_to_group("lockonables"), which makes the parent a lockonable
	hurtbox.add_to_group("lockonables")
	
	Globals.cotu_dodge.connect(ready_action_trigger)
	# Spider doesn't attack when you throw because the rose stuns it
	Globals.cotu_normal_throw_rose.connect(ready_action_trigger)
	hurtbox.hit_received.connect(receive_hit_from_hurtbox)
	
	switch_to_walk()

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		if can_stop:
			print("I can stop! ", stop_time_remaining)
		else:
			print("I can't stop! ", stop_time_remaining)
		match(behav_state):
			WALK: 
				print("walk")
			FARAWAY:
				print("faraway")
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
		FARAWAY:
			faraway_frame(delta)
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
	
	if stop_time_remaining > 0:
		stop_time_remaining -= delta
		if stop_time_remaining <= 0:
			can_stop = false
	
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
	if behav_state == WALK or behav_state == FARAWAY:
		# If you are already stopped, stay stopped
		# Note: the only stop time functionality not stored here is setting can_stop to false when stop_time_remaining ends, which occurs in physics_process since it can decrement stop_time_remaining using delta
		if stop_time_remaining > 0:
			velocity = Vector3.ZERO
		# If you're not already stopped, and you can stop, and are below the min speed, stop moving and start the stop timer
		elif can_stop and velocity.length() < walk_min_speed:
			stop_time_remaining = rng.randf_range(stop_time_min, stop_time_max)
			velocity = Vector3.ZERO
		# If you're not already stopped, and you can stop, and are above the min speed, keep moving as normal
		elif can_stop and velocity.length() >= walk_min_speed:
			velocity = velocity.move_toward(safe_velocity, .9)
		# If you cannot stop, allow yourself to accelerate again and accelerate quickly
		elif not can_stop:
			velocity = safe_velocity
			# If you cannot stop and your speed is over the min speed, you can stop again
			if velocity.length() >= walk_min_speed + 5:
				can_stop = true
	# When attacking, don't stop so you can continuously chase. Since it's a short range walk, move smoothly
	elif (behav_state == ATTACK and attack_jump_completed):
		velocity = velocity.move_toward(safe_velocity, .5)
	# When retreating, don't stop so you can escape danger quickly. Since it's a long range walk, move abruptly
	elif behav_state == RETREAT:
		velocity = safe_velocity

func choose_walk_dest():
	"""
	Starting from the target, go walk_dest_dist_from_target opposite the dir the target is facing.
	Get a flat circle (or square) around this point w radius walk_dest_radius.
	Get a random cardinal pt on the circumference of the circle (north, south, east, west), then fire a ray from high above onto the pt.
	If it's a valid pt, choose it. If not, increase the size of the area, get another random pt, and fire another ray. Repeat until the pt is valid
	Failsafe: set walk_dest to global pos
	"""
	var target_face_dir = target.get_fwd_dir()
	var walk_dest_center = target.global_position - walk_dest_dist_from_target * target_face_dir
	var walk_dest_candidate = walk_dest_center
	# The longer the spider's been walking, the farther away it tries to get
	var temp_walk_dest_radius := walk_dest_radius * (1 + 1.5 * (walk_max_duration - walk_duration))
	var result = false
	var attempts := 10
	while not result and attempts > 0:
		attempts -= 1
		var randx = -1 if rng.randf() < .5 else 1
		var randz = -1 if rng.randf() < .5 else 1
		walk_dest_candidate.x = walk_dest_center.x + randx * temp_walk_dest_radius
		walk_dest_candidate.z = walk_dest_center.z + randz * temp_walk_dest_radius
		if Vector2(walk_dest_candidate.x, walk_dest_candidate.z).length() > arena_max_radius:
			# Increase temp_walk_dest_radius by 10% if walk_dest_candidate isn't valid
			temp_walk_dest_radius += walk_dest_radius * .1
			continue
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
	body_meshes.start_ik()
	behav_state = WALK
	# Set max walk time
	walk_duration = walk_max_duration
	# Set walk dest
	choose_walk_dest()
	body_meshes.set_leg_step_time(leg_step_time_moving)

func walk_frame(delta):
	if point_in_target_fov(walk_dest):
		choose_walk_dest()
	
	rotate_y_to_vec(velocity, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		switch_to_aim()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	walk_duration -= delta
	if walk_duration <= 0:
		switch_to_aim()

func choose_far_dest(on_rim: bool):
	"""
	Starting from the arena center, look in a random lateral dir, then move fwd faraway_dest_radius. At this lateral pos, get the y pos of the ground using a raycast from high above.
	Failsafe: set walk_dest to global pos
	"""
	var dest_dist := arena_max_radius if on_rim else faraway_dest_radius
	var arena_center := Vector3.ZERO
	var faraway_dest_dir = Vector3.FORWARD
	faraway_dest_dir = faraway_dest_dir.rotated(Vector3.UP, rng.randf_range(0, 2*PI))
	var faraway_dest = dest_dist * faraway_dest_dir + arena_center
	var space_state := get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(faraway_dest + Vector3.UP * 100, faraway_dest + Vector3.DOWN * 200)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if result:
		walk_dest = result.position
		return
	# Failsafe: set walk_dest to current position
	walk_dest = global_position

func switch_to_faraway():
	body_meshes.start_ik()
	behav_state = FARAWAY
	# Set walk dest (choose_far_dest sets walk_dest)
	choose_far_dest(false)
	body_meshes.set_leg_step_time(leg_step_time_moving)

func faraway_frame(_delta):
	rotate_y_to_vec(velocity, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		# TO DO: SWITCH TO POST-FARAWAY STATE (LEAVE, AIM)
		switch_to_aim()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func switch_to_aim():
	behav_state = AIM
	if rng.randf() > leave_chance:
		aiming_at_target = true
		aim_duration = rng.randf_range(aim_min_duration, aim_max_duration)
	else:
		aiming_at_target = false
		aim_duration = aim_min_duration / 2
		choose_far_dest(true) # Set walk dist to pt on rim
	body_meshes.set_leg_step_time(leg_step_time_stationary)

func aim_frame(delta):
	var target_pos : Vector3
	if aiming_at_target:
		target_pos = target.global_position
	else:
		target_pos = walk_dest
	
	velocity = Vector3.ZERO
	#  If y-axis angle btwn spider's forward dir and the dir from spider to target ("vec angle") is too high, turn towards target
	var body_fwd_dir = body_meshes.transform.basis.z
	var dir_to_target := global_position.direction_to(target_pos)
	var angle_btwn_vecs := angle_btwn_3d_vecs(body_fwd_dir, dir_to_target)
	# Start turning when vec angle is above start_vec_angle
	if not aim_turning and angle_btwn_vecs > aim_turning_start_vec_angle:
		aim_turning_start_vec_angle = rng.randf_range(aim_turning_start_vec_angle_min, aim_turning_start_vec_angle_max)
		aim_turning = true
	if aim_turning:
		rotate_y_to_vec(target_pos - global_position, aim_turn_speed)
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
	if aiming_at_target:
		ready_full_duration = rng.randf_range(ready_min_full_duration, ready_max_full_duration)
	else:
		ready_full_duration = ready_min_full_duration / 2
	ready_trigger_duration = ready_max_trigger_duration
	body_meshes.set_leg_step_time(leg_step_time_stationary)

func ready_frame(delta):
	var target_pos : Vector3
	if aiming_at_target:
		target_pos = target.global_position
	else:
		target_pos = walk_dest
	
	velocity = Vector3.ZERO
	rotate_y_to_vec(target_pos - global_position, ready_turn_speed)
	ready_full_duration -= delta
	if ready_triggered:
		ready_trigger_duration -= delta
	if ready_full_duration <= ready_front_leg_raise_time or ready_trigger_duration <= ready_front_leg_raise_time:
		body_meshes.stop_ik_front_legs()
	if ready_full_duration <= 0.0 or ready_trigger_duration <= 0.0:
		ready_triggered = false
		switch_to_attack()

func switch_to_attack():
	behav_state = ATTACK
	inner_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	outer_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	# Reset attack_time_remaining and attack_jump_completed. Remember that attack_time_remaining includes both the jump and chase
	if aiming_at_target:
		attack_time_remaining = attack_total_duration
	else:
		attack_time_remaining = attack_total_duration / 3 # Let the spider jump, but not chase
	attack_jump_completed = false
	# Stop body meshes IK
	body_meshes.stop_ik()
	# Jump towards jump dest (target + its vel - vec from spider to jump dest)
	# Vel = distance / seconds
	# walk_dest functions as jump_dest here
	if aiming_at_target:
		walk_dest = target.global_position + (target.velocity * get_physics_process_delta_time())
	# Subtract spider to jump dest vec slghtly so that spider doesn't aim directly for the jump dest, but slightly back from it
	walk_dest -= .5 * global_position.direction_to(walk_dest)
	velocity = .91 * (walk_dest - global_position) / attack_jump_duration

func receive_hit_from_hurtbox():
	if behav_state == AIM:
		switch_to_walk()
	if behav_state == ATTACK and attack_jump_completed:
		hit_received_while_attacking = true

func attack_frame(delta):
	# Make attack_stop_dist very low when not aiming at target so spider slides out of arena
	var temp_attack_stop_dist := attack_stop_dist if aiming_at_target else 0.0
	
	# If spider reached its dest, stop checking if spider reached its dest, turn on body meshes IK, and set vel to 0
	if not attack_jump_completed and global_position.distance_to(walk_dest) < temp_attack_stop_dist:
		attack_jump_completed = true
		body_meshes.start_ik()
		velocity = Vector3.ZERO
	
	# Decrease attack time remaining. If it's <= 0 or you touched the floor and got hit or (you completed your jump and are not aiming at the target), switch to retreat
	attack_time_remaining -= delta
	if attack_time_remaining <= 0 or hit_received_while_attacking:
		hit_received_while_attacking = false
		# Hitboxes are enabled by default to make spider a threat even when just running to a destination
		inner_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		outer_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		# When switching states, spider could be moving, so set its lateral speed to 0 and remove upward speed
		velocity.x = 0
		velocity.z = 0
		if velocity.y > 0:
			velocity.y = 0
		switch_to_retreat()
	
	# While in the air, look in the direction you're moving so that if you bounce off of something, it'll still look like you're moving forward and you meant to do that
	if not attack_jump_completed:
		rotate_y_to_vec(velocity, 1)
		return
	
	# If you already landed and are still attacking, chase target
	rotate_y_to_vec(target.global_position - global_position, walk_turn_speed)
	nav_agent.set_target_position(target.global_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

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
	# This is here if attack_time_remaining finishes and spider didn't complete its jump, which happens when it leaves the arena
	body_meshes.start_ik()
	behav_state = RETREAT
	choose_retreat_dest()
	body_meshes.set_leg_step_time(leg_step_time_moving)

func retreat_frame(_delta):
	rotate_y_to_vec(velocity, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		if rng.randf() > faraway_chance:
			switch_to_walk()
		else:
			switch_to_faraway()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

