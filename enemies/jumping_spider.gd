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
var hitbox : Node3D
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

var target_fov_angle := PI/4 # Max angle btwn target's body's fwd dir and dir from target to spider necessary for spider to be considered in target's FOV

var walk_dest := Vector3.ZERO
var walk_turn_speed := .5
var walk_speed := 30.0

var aim_turn_speed := .25
var aim_turning_start_vec_angle := PI/4 # Min y-axis angle btwn spider's fwd vec and vec from spider to target ("vec angle") necessary to start aim turning
var aim_turning := false # Activated when vec angle > start_vec_angle, deactivated when vec angle < stop_vec_angle
var aim_turning_stop_vec_angle := .05 # Max vec angle necessary to stop aim turning
var aim_duration := 1.0 # Set to a random number btwn min and max aim duration
var aim_min_duration := 2.0
var aim_max_duration := 4.0

var ready_turn_speed := .25
var ready_duration := 1.0 # Set to a random number btwn min and max aim duration
var ready_min_duration := 2.5
var ready_max_duration := 5.0

func _ready():
	level = root.find_child("Level")
	# Jumping spider targets Cotu's body, not icon
	target = root.find_child("cotuCB")
	hitbox = find_child("MeleeHitboxPivot")
	#hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	# Ensure that homing attacks hit the hurtbox and not the parent node, which stays on the ground. For any enemy whose hurtbox is at the same position as the parent node, this line can just be add_to_group("lockonables"), which makes the parent a lockonable
	hurtbox.add_to_group("lockonables")
	
	switch_to_walk()

func _physics_process(delta):
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
	var target_fwd_dir := -target.transform.basis.z
	return angle_btwn_3d_vecs(target_to_pt_dir, target_fwd_dir) < target_fov_angle

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == WALK or behav_state == RETREAT:
		velocity = velocity.move_toward(safe_velocity, .5)
	move_and_slide()

func switch_to_walk():
	# Stop IK since you're leaving the ground
	body_meshes.start_ik()
	behav_state = WALK
	# Set walk dest
	"""
	THE BELOW CODE IS TEST CODE. CHANGE IT
	"""
	walk_dest = target.global_position

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
	var body_fwd_dir := -transform.basis.z
	var dir_to_target := global_position.direction_to(target.global_position)
	var angle_btwn_vecs := angle_btwn_3d_vecs(body_fwd_dir, dir_to_target)
	# Start turning when vec angle is above start_vec_angle
	if not aim_turning and angle_btwn_vecs > aim_turning_start_vec_angle:
		aim_turning = true
	if aim_turning:
		rotate_y_to_vec(target.global_position - global_position, aim_turn_speed)
		# Stop turning when vec angle is below stop_vec_angle
		if angle_btwn_vecs < aim_turning_stop_vec_angle:
			aim_turning = false
	
	aim_duration -= delta
	if aim_duration <= 0:
		switch_to_ready()

func switch_to_ready():
	behav_state = READY
	ready_duration = rng.randf_range(ready_min_duration, ready_max_duration)

func ready_frame(delta):
	velocity = Vector3.ZERO
	rotate_y_to_vec(target.global_position - global_position, ready_turn_speed)
	ready_duration -= delta
	if ready_duration <= 0:
		switch_to_ready()

func switch_to_attack():
	behav_state = ATTACK

func attack_frame(delta):
	pass

func switch_to_retreat():
	behav_state = RETREAT

func retreat_frame(delta):
	pass
