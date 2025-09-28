extends CharacterBody3D

var tiny_mite := preload("res://enemies/tiny_mite.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $HarvestmanProcAnimMeshes
@onready var anim_player := $HarvestmanProcAnimMeshes/HarvestmanMeshes/AnimationPlayer
@onready var poke_hitbox := $HarvestmanProcAnimMeshes/DamageOverTimeArea
@onready var anim_tree := $AnimationTree
@onready var hurtbox := $EnemyHurtbox
@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var level : Node3D
var mouth : Node3D # Position from which mites are spat from
var target : Node3D
var aiming_at_target := true
enum {
	FOLLOW,
	SPIT,
}
var behav_state := FOLLOW
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
@export var leap_short_lateral_speed := 9.0
@export var leap_long_lateral_speed := 18.0
@export var leap_vertical_speed := 5.0

@export var follow_speed := 3.5
@export var follow_turn_speed := .1
@export var spit_dist := 16.0
@export var spit_secs := 2.0
@export var spit_projectile_count := 20.0
@export var spit_projectile_spread := 3.0 # Max dist (on a single axis) btwn target pos and actual projectile landing pos
@export var spit_cooldown_secs := 8.0
var spit_cooldown_remaining := 2.5

@export var poke_dist := 5.0 # Dist from harvestman's parent node necessary to start poking with the middle legs

@export var dp_impulse_limit := 5.0

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	mouth = find_child("Mouth")
	anim_tree.active = true
	nav_agent.target_desired_distance = spit_dist - 1.0
	
	time_until_can_leap = rng.randf_range(min_leap_cooldown, max_leap_cooldown)
	can_leap = true
	time_until_forced_leap = can_leap_window
	
	spit_cooldown_remaining = spit_cooldown_secs
	
	# Ensure that homing attacks hit the hurtbox and not the parent node, which stays on the ground. For any enemy whose hurtbox is at the same position as the parent node, this line can just be add_to_group("lockonables")
	hurtbox.add_to_group("lockonables")

func _physics_process(delta):
	# Target position is used during both follow and spit states
	target_position = target.global_position
	
	match(behav_state):
		FOLLOW:
			follow(delta)
		SPIT:
			stop_lateral_mvmt()
	
	if not is_on_floor():
		velocity.y -= gravity * delta
	#move_and_slide()
	
	hurtbox.global_position = body_meshes.global_position
	
	if poke_hitbox.global_position.distance_to(target_position) < poke_dist:
		if poke_hitbox.process_mode != Node.PROCESS_MODE_INHERIT:
			poke_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		if poke_hitbox.process_mode != Node.PROCESS_MODE_DISABLED:
			poke_hitbox.process_mode = Node.PROCESS_MODE_DISABLED

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
	move_and_slide()

func follow(delta):
	rotate_y_to_vec(target_position - global_position, follow_turn_speed)
	if global_position.distance_to(target_position) <= nav_agent.target_desired_distance:
		nav_agent.set_target_position(global_position)
	else:
		nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# Turn this into mite spitting
	spit_cooldown_remaining -= delta
	if spit_cooldown_remaining <= 0 and global_position.distance_to(target.global_position) < spit_dist:
		spit_cooldown_remaining = spit_cooldown_secs
		behav_state = SPIT
		await spit()
		behav_state = FOLLOW

func random_spread(s: float) -> Vector3:
	return Vector3(rng.randf_range(-s, s), rng.randf_range(-s, s), rng.randf_range(-s, s))

func spit():
	stop_lateral_mvmt()
	for i in range(spit_projectile_count):
		# Projectile must travel lateral dist to target in t time
		# t is time it takes for projectile to fall to the ground from its current height
		# d0 + s0t + 1/2at^2 = d
		# 1/2gt^2 = d
		# t^2 = 2 * body_meshes.height / gravity
		var tm_landing_pos = target_position + random_spread(spit_projectile_spread)
		var t = sqrt(2 * body_meshes.position.y / gravity)
		var tm_speed = global_position.distance_to(tm_landing_pos) / t
		var tm_inst = tiny_mite.instantiate()
		level.add_child.call_deferred(tm_inst)
		await tm_inst.tree_entered
		tm_inst.global_position = mouth.global_position
		tm_inst.velocity = tm_speed * global_position.direction_to(tm_landing_pos)
		await get_tree().create_timer(spit_secs / spit_projectile_count).timeout

func stop_lateral_mvmt():
	velocity.x = 0
	velocity.z = 0

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
