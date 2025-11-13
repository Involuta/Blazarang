extends CharacterBody3D

var spitweb := preload("res://enemies/spitweb.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $JumpingSpiderProcAnimMeshes
@onready var physical_collider := $CollisionShape3D
@onready var hurtbox := $JumpingSpiderProcAnimMeshes/JumpingSpiderMeshes/EnemyHurtbox
@onready var anim_player := $JumpingSpiderProcAnimMeshes/JumpingSpiderMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var fake_meshes_pivot := $FakeMeshesPivot
@onready var fake_meshes := $FakeMeshesPivot/FakeMeshes
@onready var fake_meshes_anim_player := $FakeMeshesPivot/FakeMeshes/AnimationPlayer
@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var level : Node3D
var arena : Node3D
var actual_collision_layer := collision_layer # collision_layer is set to actual_collision_layer upon spider becoming tangible at end of leave-descend state
var inner_hitbox : Node3D
var outer_hitbox : Node3D
var walk_dest_mesh : Node3D
var target : Node3D
enum {
	CURIOUS,
	WALK,
	FARAWAY,
	AIM,
	READY,
	ATTACK,
	RETREAT,
	LEAVE
}
var behav_state := WALK

@export var base_path_desired_dist := 2.0 # Used in normal mvmt circumstances (anything except attack chase)
@export var base_target_desired_dist := 10.0 # Used in normal mvmt circumstances (anything except attack chase)

@export var arena_max_radius := 115.0 # Spider won't set walk dest to any point laterally outside this value

@export var target_fov_angle := PI/4 # Max angle btwn target's body's fwd dir and dir from target to spider necessary for spider to be considered in target's FOV
@export var leg_step_time_moving := .0167 # Time it takes for each leg to make a step when spider is walking/retreating
@export var leg_step_time_stationary := .1 # Time it takes for each leg to make a step when spider is aiming/ready

var walk_dest := Vector3.ZERO
@export var walk_max_duration := 4.5 # If spider keeps recalculating walk dest and never makes it to the dest, it stops walking after this many seconds
var walk_duration := 6.0 # Set to walk_max_duration at start of walk state
@export var walk_dest_dist_from_target := 60.0 # Starting from the target, go walk_dest_dist_from_target opposite the dir the target is facing. Get a flat circle around this point w radius walk_dest_radius. Get a random cardinal pt on the circumference of this circle, then fire a ray from high above onto the pt. If it's a valid pt, choose it. If not, increase the size of the circle, get another random pt, and fire another ray. Repeat until the pt is valid
@export var walk_dest_radius := 10.0
@export var walk_turn_speed := .5
@export var walk_speed := 50.0
@export var walk_min_speed := 30.0 # Unless the spider wants to move at least this fast, it doesn't move at all. This prevents it from drifting slowly when changing direction and makes its mvmt more erratic
var can_stop := false # Once the spider reaches above walk_min_speed, can_stop is true. When the spider goes below walk_min_speed and can_stop, it stops moving instead of moving slowly, and can_stop is set to false. After being stopped for a bit, it's allowed to accelerate again
@export var stop_time_min := .1 # Min length of time spider stops moving due to reaching low speed
@export var stop_time_max := .75 # Min length of time spider stops moving due to reaching low speed
var stop_time_remaining := 1.0 # Stop time remaining before spider can accelerate again
@export var walk_to_attack_proximity := 36.0 # If spider stops this close to the target, it immediately attacks
@export var walk_to_faraway_proximity := 40.0 # If walk state ends and spider is within this dist to the target, it switches to faraway state

@export var faraway_dest_radius := 90.0 # Dist from arena center that a faraway dest usually is

var aiming_at_target := true # If this is false, then aim, ready, and jump states aim at walk_dest instead of target
@export var aim_turn_speed := .25
@export var aim_turning_start_vec_angle_max := PI/3.5
@export var aim_turning_start_vec_angle_min := PI/9
var aim_turning_start_vec_angle := PI/4 # Min y-axis angle btwn spider's fwd vec and vec from spider to target ("vec angle") necessary to start aim turning. Set to a random value btwn its max and min every turn
var aim_turning := false # Activated when vec angle > start_vec_angle, deactivated when vec angle < stop_vec_angle
@export var aim_turning_stop_vec_angle := .05 # Max vec angle necessary to stop aim turning
var aim_duration := 1.0 # Set to a random number btwn min and max aim duration
@export var aim_min_duration := 1.0
@export var aim_max_duration := 2.5

@export var ready_turn_speed := .25
@export var ready_min_full_duration := 1.0
@export var ready_max_full_duration := 3.5
var ready_full_duration := 1.0 # The duration of the ready state when no action triggers the spider to jump. Set to a random number btwn min and max ready duration when ready state starts. Always decreases during Ready state
var ready_triggered := false # Set to true when Cotu does an action that triggers the spider jump
@export var ready_max_trigger_duration := .4
var ready_trigger_duration := .25 # The duration of the ready state when an action triggers the spider to jump. Set to ready_max_trigger_duration when ready state begins. Only decreases when ready_triggered is true
@export var ready_front_leg_raise_time := .2 # When either ready_duration is <= ready_front_leg_raise_time, front legs begin to rise. Actual time it takes for front legs to rise is set in transition from idle to ready state in anim tree

@export var double_jump_chance := .5 # Chance that spider jumps behind target, then to target instead of directly to target
var will_double_jump := false # Set to true when spider decides to double jump and spider hasn't already decided to double jump
@export var attack_jump_duration := .25 # Duration of jump in secs
var jump_time_remaining := .25 # Decreases every frame while jumping, reset to attack_jump_duration before each jump
@export var attack_stop_dist := 1.6 # Max dist from spider to jump dest needed to stop jump mvmt
var attack_jump_completed := false # Set to true when landing after jump, set to false at start of attack
@export var attack_total_duration := 2.75 # Duration of jump + chase in secs
var attack_time_remaining := 2.75 # Decreases every frame, reset to attack_total_duration when a jump ends
var hit_received_while_attacking := false # Set to true when spider is hit while attacking, false outside of attack state

@export var retreat_min_dist := 60.0 # Min dist spider runs away from target when retreating
# When switching out of retreat, spider can leave, aim, faraway, or walk
@export var retreat_to_aim_chance := .2 # When switching out of retreat state, chance of choosing aim
@export var retreat_to_faraway_chance := .3 # When switching out of retreat state, chance of choosing faraway
@export var retreat_to_leave_chance := .2 # Chance of climbing out of arena after retreating

enum LEAVE_STATE {
	WALK,
	ASCEND,
	WAIT,
	DESCEND
}
var leave_behav_state := LEAVE_STATE.WALK
@export var leave_points := { # Points on arena where spider can climb up and out
	"Right": Vector3(0,29,135),
	"Left": Vector3(0,29,-135),
	"Forward": Vector3(135,29,0),
	"Back": Vector3(-135,29,0)
}
var leave_point_chosen := "Left"
var leave_height := 100.0 # global y level where spider leaves to
@export var leave_wait_time := 4.0
@export var leave_wait_time_var := 1.0 # leave_wait_time_remaining is set to leave_wait_time + rng within ±leave_wait_time_var
var leave_wait_time_remaining := 4.0
var leave_descend_speed := 40.0
@export var descend_ground_contact_height := 30.0

func _ready():
	level = root.find_child("Level")
	arena = level.find_child("MiteLevelMainArena")
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
	
	nav_agent.path_desired_distance = base_path_desired_dist
	nav_agent.target_desired_distance = base_path_desired_dist
	
	Globals.cotu_dodge.connect(ready_action_trigger)
	# Spider doesn't attack when you throw because the rose stuns it
	Globals.cotu_normal_throw_rose.connect(ready_action_trigger)
	hurtbox.hit_received.connect(receive_hit_from_hurtbox)
	
	# Disable fake spider to save a little computation
	fake_meshes_pivot.process_mode = Node.PROCESS_MODE_DISABLED
	
	switch_to_walk()

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
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
			LEAVE:
				print("leave")
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
		LEAVE:
			leave_frame(delta)
	
	if not is_on_floor() and not (behav_state == LEAVE and (leave_behav_state == LEAVE_STATE.ASCEND or leave_behav_state == LEAVE_STATE.DESCEND)):
		velocity.y -= gravity * delta
	
	if stop_time_remaining > 0:
		stop_time_remaining -= delta
		if stop_time_remaining <= 0:
			can_stop = false
			# If you start moving again close the target, go to ready state and attack ASAP
			if global_position.distance_to(target.global_position) < walk_to_attack_proximity:
				switch_to_ready()
				ready_full_duration = ready_min_full_duration
			# If you start moving again and you're far from your dest (maybe faraway_dest_radius distance), jump to it
			if global_position.distance_to(walk_dest) > faraway_dest_radius:
				aiming_at_target = false
				switch_to_aim()
	
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
	if behav_state == WALK or behav_state == FARAWAY or (behav_state == LEAVE and leave_behav_state == LEAVE_STATE.WALK):
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
		velocity = velocity.move_toward(safe_velocity, .9)
	# When retreating, don't stop so you can escape danger quickly. In leave-wait state, you're invisible so no need to move abruptly
	elif behav_state == RETREAT or (behav_state == LEAVE and leave_behav_state == LEAVE_STATE.WAIT):
		velocity = Vector3.ZERO if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance else safe_velocity
	# When leaving and leave state isn't walk, let leave state frame decide velocity
	elif behav_state == LEAVE:
		pass

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
		var ray_result = get_ray_result(walk_dest_candidate + 100.0 * Vector3.UP, walk_dest_candidate + 200.0 * Vector3.DOWN, [Globals.ARENA_COL_LAYER])
		if ray_result:
			walk_dest = ray_result.position
			return
		else:
			# Increase temp_walk_dest_radius by 10% if ray result isn't valid
			temp_walk_dest_radius += walk_dest_radius * .1
	# Failsafe: set walk_dest to current position
	walk_dest = global_position

func switch_to_walk():
	behav_state = WALK
	body_meshes.start_ik()
	# Spider is aiming at target by default if it's in walk state
	aiming_at_target = true
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
		# If you stop walking and end up too close to the target, switch to faraway
		if walk_dest.distance_to(target.global_position) < walk_to_faraway_proximity:
			switch_to_faraway()
		else:
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

func choose_far_dest(on_rim: bool, behind_target: bool):
	"""
	Starting from the arena center, look in a random lateral dir, then move fwd faraway_dest_radius. At this lateral pos, get the y pos of the ground using a raycast from high above.
	Failsafe: set walk_dest to global pos
	"""
	var dest_dist := arena_max_radius if on_rim else faraway_dest_radius
	var arena_center := Vector3.ZERO
	var faraway_dest_dir : Vector3
	if behind_target:
		faraway_dest_dir = global_position.direction_to(target.global_position)
		faraway_dest_dir.y = 0
	else:
		faraway_dest_dir = Vector3.FORWARD.rotated(Vector3.UP, rng.randf_range(0, 2*PI))
	var faraway_dest = dest_dist * faraway_dest_dir + arena_center
	var ray_result = get_ray_result(faraway_dest + Vector3.UP * 100, faraway_dest + Vector3.DOWN * 200, [Globals.ARENA_COL_LAYER])
	# Failsafe: set walk_dest to current position
	walk_dest = ray_result.position if ray_result else global_position

func switch_to_faraway():
	body_meshes.start_ik()
	body_meshes.set_leg_step_time(leg_step_time_moving)
	behav_state = FARAWAY
	# Set walk dest (choose_far_dest sets walk_dest)
	choose_far_dest(false, false)
	# If walk dest is too far (slightly farther than faraway_dest_radius), just jump to it
	if global_position.distance_to(walk_dest) > 1.2 * faraway_dest_radius:
		aiming_at_target = false
		switch_to_aim()

func faraway_frame(_delta):
	rotate_y_to_vec(velocity, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		# After reaching the dest, attack target
		aiming_at_target = true
		switch_to_aim()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func switch_to_aim():
	behav_state = AIM
	# Body meshes IK may be stopped due to coming out of leave-descend state
	body_meshes.start_ik()
	body_meshes.set_leg_step_time(leg_step_time_stationary)
	if aiming_at_target:
		aim_duration = rng.randf_range(aim_min_duration, aim_max_duration)
	else:
		aim_duration = aim_min_duration / 2

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
	# Reset jump_time_remaining and attack_jump_completed. Remember that attack_time_remaining only includes the chase, not the jump
	jump_time_remaining = attack_jump_duration
	attack_jump_completed = false
	# Stop body meshes IK
	body_meshes.stop_ik()
	# Jump towards jump dest (target + its vel - vec from spider to jump dest)
	# Vel = distance / seconds
	# walk_dest functions as jump_dest here
	if aiming_at_target:
		# Chance to jump at point behind target instead
		if rng.randf() <= double_jump_chance and not will_double_jump:
			will_double_jump = true
			choose_far_dest(false, true)
		else:
			will_double_jump = false
			# Set walk dest to ground pos beneath target + target's velocity. If ground pos not found, set walk dest to target pos + target vel
			var target_dest = target.global_position + target.velocity * get_physics_process_delta_time()
			var target_ground_ray_result = get_ray_result(target_dest + 15 * Vector3.UP, target_dest + 30 * Vector3.DOWN, [Globals.ARENA_COL_LAYER])
			walk_dest = target_ground_ray_result.position if target_ground_ray_result else target_dest
	# If you're not aiming at the target, walk_dest was set in an earlier state, likely in faraway_frame
	# Subtract spider to jump dest vec slghtly so that spider doesn't aim directly for the jump dest, but slightly back from it
	walk_dest -= .5 * global_position.direction_to(walk_dest)
	# Why isn't a tween used? CharacterBody3D snaps to the ground during tween, and setting floor snap length to 0, not calling is_on_floor, and adding upward vel didn't stop floor snapping
	velocity = .95 * (walk_dest - global_position) / attack_jump_duration
	collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	# When spider is chasing, it should try to get very close
	nav_agent.path_desired_distance = 1.5 # Why is this not 1? Sometimes (usually near slope changes) the spider chased a stationary point, which meant it was trying to get to a path point but was too far
	nav_agent.target_desired_distance = 1

func receive_hit_from_hurtbox():
	if behav_state == AIM:
		switch_to_walk()
	if behav_state == ATTACK and attack_jump_completed:
		hit_received_while_attacking = true

func attack_frame(delta):
	# If spider reached its dest or jumped for max jump time, complete jump
	if not attack_jump_completed and (jump_time_remaining <= 0 or global_position.distance_to(walk_dest) < attack_stop_dist):
		# Stop checking if spider reached its dest, turn on body meshes IK, turn on physical collision with Cotu and enemies, set vel to 0, and start attack_time_remaining
		attack_jump_completed = true
		collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER, Globals.ENEMY_COL_LAYER, Globals.COTU_COL_LAYER, Globals.THICK_ENEMY_COL_LAYER])
		body_meshes.start_ik()
		velocity = Vector3.ZERO
		attack_time_remaining = attack_total_duration
		# If you weren't attacking the target and were just jumping to a faraway pt, switch to aim state
		if not aiming_at_target:
			aiming_at_target = true
			switch_to_aim()
		# If you plan to double jump, switch back to ready and jump ASAP
		if will_double_jump:
			switch_to_ready()
			ready_full_duration = ready_min_full_duration
	
	# If you landed, decrease attack time remaining
	if attack_jump_completed:
		attack_time_remaining -= delta
	# Otherwise, decrease jump time and look in the direction you're moving so that if you bounce off of something, it'll still look like you're moving forward and you meant to do that
	else:
		jump_time_remaining -= delta
		rotate_y_to_vec(velocity, 1)
		return
	
	# If attack_time_remaining <= 0 or you touched the floor and got hit or (you completed your jump and are not aiming at the target), switch to retreat
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
	
	# If you already landed and are still attacking, chase target
	rotate_y_to_vec(target.global_position - global_position, .9)
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
		var ray_result = get_ray_result(retreat_pt_candidate + 100.0 * Vector3.UP, retreat_pt_candidate + 200.0 * Vector3.DOWN, [Globals.ARENA_COL_LAYER])
		if ray_result:
			walk_dest = ray_result.position
			return
		# Reduce vec by 10% if ray result isn't valid
		temp_retreat_min_dist -= retreat_min_dist * .1
	# Failsafe: set walk_dest to current position
	walk_dest = global_position

func teleport_outside_arena():
	"""
	Starting from the arena center, look in a random lateral dir, then move fwd arena_max_radius * 1.15. Teleport to this lateral pos
	Failsafe: set walk_dest to global pos
	"""
	var arena_center := Vector3.ZERO
	var tp_dest_dir = Vector3.FORWARD.rotated(Vector3.UP, rng.randf_range(0, 2*PI))
	var tp_dest = 1.15 * arena_max_radius * tp_dest_dir + arena_center
	global_position = tp_dest

func switch_to_retreat():
	# switch_to_attack changes path_desired_dist and target_desired_distance to a low number. Change them back
	nav_agent.path_desired_distance = base_path_desired_dist
	nav_agent.target_desired_distance = base_path_desired_dist

	behav_state = RETREAT
	choose_retreat_dest()
	body_meshes.set_leg_step_time(leg_step_time_moving)

func retreat_frame(_delta):
	rotate_y_to_vec(velocity, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		var choice = rng.randf()
		if choice > retreat_to_aim_chance + retreat_to_faraway_chance + retreat_to_leave_chance:
			switch_to_walk()
		elif choice > retreat_to_aim_chance + retreat_to_faraway_chance:
			switch_to_leave()
		elif choice > retreat_to_aim_chance:
			switch_to_faraway()
		else:
			switch_to_aim()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func choose_leave_dest():
	# Get closest leave point to current global position
	leave_point_chosen = leave_points.keys()[0]
	walk_dest = leave_points[leave_point_chosen]
	for i in range(1, len(leave_points.keys())):
		var current_leave_point = leave_points.keys()[i]
		if global_position.distance_to(leave_points[current_leave_point]) < global_position.distance_to(walk_dest):
			leave_point_chosen = current_leave_point
			walk_dest = leave_points[leave_point_chosen]

func switch_to_leave():
	behav_state = LEAVE
	leave_behav_state = LEAVE_STATE.WALK
	choose_leave_dest()
	body_meshes.set_leg_step_time(leg_step_time_moving)

func leave_frame(delta):
	match(leave_behav_state):
		LEAVE_STATE.WALK:
			leave_frame_walk()
		LEAVE_STATE.ASCEND:
			leave_frame_ascend()
		LEAVE_STATE.WAIT:
			leave_state_wait(delta)
		LEAVE_STATE.DESCEND:
			leave_state_descend()

func leave_frame_walk():
	rotate_y_to_vec(velocity, walk_turn_speed)
	if global_position.distance_to(walk_dest) <= nav_agent.target_desired_distance:
		switch_to_leave_ascend()
	else:
		nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func switch_to_leave_ascend():
	leave_behav_state = LEAVE_STATE.ASCEND
	
	# Teleport to base of ascend path and stop mvmt
	velocity = Vector3.ZERO
	
	# Make main spider body invisible and intangible
	body_meshes.visible = false
	collision_layer = 0
	
	# Disable mouth hitboxes
	inner_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	outer_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	# Make fake meshes active and visible and move them to main spider's pos (fake meshes are top level, so they don't inherit main spider's transform)
	fake_meshes_pivot.process_mode = Node.PROCESS_MODE_INHERIT
	fake_meshes_pivot.visible = true
	fake_meshes_pivot.global_position = global_position
	# Play ascend anim
	fake_meshes_anim_player.play("ascend")
	
	# Tilt fake meshes upward
	fake_meshes.rotation = .5 * PI * Vector3.LEFT
	# Rotate fake spider towards ascend path
	match(leave_point_chosen):
		"Left":
			fake_meshes_pivot.rotation = 0 * Vector3(0,1,0)
		"Right":
			fake_meshes_pivot.rotation = PI * Vector3(0,1,0)
		"Forward":
			fake_meshes_pivot.rotation = .5 * PI * Vector3(0,1,0)
		"Back":
			fake_meshes_pivot.rotation = 1.5 * PI * Vector3(0,1,0)

func leave_frame_ascend():
	# Move fake spider meshes up at a constant rate. Since walk_speed is in m/s and this func is called every frame, convert to m/f
	fake_meshes_pivot.global_position += 1.5 * walk_speed * get_physics_process_delta_time() * Vector3.UP
	if fake_meshes_pivot.global_position.y > leave_height:
		switch_to_leave_wait()

func switch_to_leave_wait():
	leave_behav_state = LEAVE_STATE.WAIT
	leave_wait_time_remaining = leave_wait_time + rng.randf_range(-leave_wait_time_var, leave_wait_time_var)
	
	# Hide and disable fake meshes since spider's far above the arena
	fake_meshes_pivot.process_mode = Node.PROCESS_MODE_DISABLED
	fake_meshes_pivot.visible = false
	
	# Set walk_dest to random position
	var dest_dist := rng.randf_range(0, faraway_dest_radius)
	var arena_center := Vector3.ZERO
	var dest_dir := Vector3.FORWARD.rotated(Vector3.UP, rng.randf_range(0, 2*PI))
	var lateral_walk_dest = dest_dist * dest_dir + arena_center
	var ray_result = get_ray_result(lateral_walk_dest + 50 * Vector3.UP, global_position + 100 * Vector3.DOWN, [Globals.ARENA_COL_LAYER])
	# If the ray fails for some reason (it should never fail) just use arena_center
	walk_dest = ray_result.position if ray_result else arena_center
	for i in range(rng.randi_range(4, 8)):
		pass#await get_tree().create_timer(leave_wait_time / 2 / 4).timeout
		arena.drop_egg_of_type(5)

func leave_state_wait(delta):
	# Movement stoppage when reaching walk_dest occurs in velocity_computed func
	
	nav_agent.set_target_position(walk_dest)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * walk_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	leave_wait_time_remaining -= delta
	if leave_wait_time_remaining <= 0:
		switch_to_leave_descend()

func switch_to_leave_descend():
	leave_behav_state = LEAVE_STATE.DESCEND
	# Show and activate fake meshes, move fake meshes above main spider, and play descend anim as spider descends
	fake_meshes_pivot.process_mode = Node.PROCESS_MODE_INHERIT
	fake_meshes_pivot.visible = true
	fake_meshes_pivot.global_position = global_position + leave_height * Vector3.UP
	fake_meshes_anim_player.play("descend")
	# Tilt fake meshes down
	fake_meshes.rotation = .5 * PI * Vector3.RIGHT

func leave_state_descend():
	fake_meshes_pivot.global_position += .75 * walk_speed * get_physics_process_delta_time() * Vector3.DOWN
	# Rotate fake meshes y towards target
	var to_vec := global_position.direction_to(target.global_position)
	var to_vec_2d = Vector2(to_vec.x, to_vec.z)
	var body_mesh_basis_z_2d = Vector2(fake_meshes_pivot.transform.basis.z.x, fake_meshes_pivot.transform.basis.z.z)
	var rotation_amt = body_mesh_basis_z_2d.angle_to(to_vec_2d)
	fake_meshes_pivot.rotate_object_local(Vector3.UP, -rotation_amt * walk_turn_speed)
	
	# Once the fake spider is close to the main spider,
	if fake_meshes_pivot.global_position.y - global_position.y < 1:
		# Make main spider body visible and tangible
		body_meshes.visible = true
		collision_layer = actual_collision_layer
		
		# Enable mouth hitboxes
		inner_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		outer_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		
		# Make fake meshes invisible and inactive
		fake_meshes_pivot.visible = false
		fake_meshes_pivot.process_mode = Node.PROCESS_MODE_DISABLED
		
		# After descending, aim
		switch_to_aim()
	# When the fake spider is almost close to the main spider,
	elif fake_meshes_pivot.global_position.y - global_position.y < descend_ground_contact_height:
		# Start ground contact anim
		fake_meshes_anim_player.play("ground_contact")

# Get result of casting a ray from "from" to "to". Will detect collisions with any object whose col layer is in the col_layer_list (e.g. [Globals.ARENA_COL_LAYER])
func get_ray_result(from: Vector3, to: Vector3, col_layer_list: Array):
	var space_state := get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(from, to)
	query.collision_mask = Globals.make_mask(col_layer_list)
	var result = space_state.intersect_ray(query)
	if result:
		return result
	else:
		return false
