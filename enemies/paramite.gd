extends CharacterBody3D

var spitweb := preload("res://enemies/spitweb.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $ParamiteProcAnimMeshes
@onready var physical_collider := $CollisionShape3D
@onready var hurtbox := $EnemyHurtbox
@onready var anim_player := $ParamiteProcAnimMeshes/ParamiteMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var level : Node3D
var hitbox : Node3D
var target : Node3D
enum {
	LAUNCH,
	FOLLOW,
	FALL,
	RETREAT,
}
var behav_state := LAUNCH

@export var launch_vert_speed := 12.0 # Initial vertical launch speed (lateral speed is set by paramite spawner)
@export var follow_duration := 10.0 # Time mite spends following before falling
@export var fall_height := 6.0 # Height above the ground mite descends to before falling

var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

@export var follow_speed := 3.0
@export var follow_turn_speed := .1
@export var spit_chance := .01 # Chance that spitweb is shot in the current physics frame

@export var retreat_dest := 30*Vector3.FORWARD
@export var retreat_speed := 6.0
var ground_normal := Vector3.UP # Normal of the ground, determined by the avg normal of the planes formed by points where feet hit the ground

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	#hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	hurtbox.add_to_group("lockonables")
	
	switch_to_launch()

func switch_to_launch():
	# Stop IK since you're leaving the ground
	body_meshes.stop_ik()
	
	behav_state = LAUNCH
	set_mesh_and_colliders_y_pos(0)
	velocity.y = launch_vert_speed

func set_mesh_and_colliders_y_pos(new_y_pos: float):
	body_meshes.position.y = new_y_pos
	physical_collider.position.y = new_y_pos
	hurtbox.position.y = new_y_pos
	hitbox.position.y = new_y_pos

func get_height_from_ground():
	var space_state := get_world_3d().direct_space_state
	var sight_dir := Vector3.DOWN
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + nav_agent.neighbor_distance * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if result:
		# result.position.y is the global position of the point the ray hit
		return global_position.y - result.position.y
	else:
		# 10 is global y pos of the arena node. If we don't get a result from our ray, we just assume that the mite's height from the ground is the difference btwn its global y pos and the ground node's y pos, which could be wrong due to various slope geometry
		return global_position.y - 10

func _physics_process(delta):
	match(behav_state):
		LAUNCH: 
			launch_frame(delta)
		FOLLOW:
			follow(delta)
		FALL:
			fall_frame(delta)
		RETREAT:
			retreat(delta)
	
	move_and_slide()

# Equivalent of lerp_look_at_move_dir or lerp_look_at_target in other enemies. This func is necessary for mites bc the mesh itself needs to rotate independently of the parent
# Rotate body meshes y rotation so that it meshes look in the direction of the vector, which is a 3D vec whose y value is ignored
func rotate_y_to_vec(to_vec : Vector3, turn_speed : float):
	var rotation_amt = atan2(to_vec.x, to_vec.z) - body_meshes.rotation.y
	body_meshes.rotate_object_local(Vector3.UP, rotation_amt * turn_speed)

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW or behav_state == RETREAT:
		velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func launch_frame(delta):
	if velocity.y <= 0:
		switch_to_follow()
	
	if not is_on_floor():
		velocity.y -= gravity * delta

func switch_to_follow():
	# Set mesh and colliders' y pos to global pos's y dist from ground obtained from raycast
	# Set parent object global position to the ground by moving it down the height obtained from raycast
	anim_tree.set("parameters/StateMachine/conditions/following", true)
	
	var height_from_ground = get_height_from_ground()
	global_position.y -= height_from_ground
	set_mesh_and_colliders_y_pos(height_from_ground)
	behav_state = FOLLOW
	
	var glide_descend_tween = get_tree().create_tween()
	glide_descend_tween.set_parallel()
	glide_descend_tween.tween_property(body_meshes, "position", Vector3(0,fall_height,-.5), follow_duration)
	glide_descend_tween.tween_property(physical_collider, "position", Vector3(0,fall_height,0), follow_duration)
	glide_descend_tween.tween_property(hurtbox, "position", Vector3(0,fall_height,0), follow_duration)
	glide_descend_tween.tween_property(hitbox, "position", Vector3(0,fall_height-.6,-1), follow_duration)
	await glide_descend_tween.finished
	switch_to_fall()

func follow(_delta):
	target_position = target.global_position
	
	rotate_y_to_vec(target_position - global_position, follow_turn_speed)
	if global_position.distance_to(target_position) <= nav_agent.target_desired_distance:
		nav_agent.set_target_position(global_position)
	else:
		nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# Spit web rarely
	if rng.randf() < spit_chance:
		shoot_spitweb()

func shoot_spitweb():
	var sw_inst = spitweb.instantiate()
	level.add_child.call_deferred(sw_inst)
	await sw_inst.tree_entered
	sw_inst.global_position = hitbox.global_position
	# Projectile must travel lateral dist to target in t time
	# t is time it takes for projectile to fall to the ground from its current height
	# d0 + s0t + 1/2at^2 = d
	# 1/2gt^2 = d
	# t^2 = 2 * body_meshes.height / gravity
	var t = sqrt(2 * body_meshes.position.y / gravity)
	var sw_speed = global_position.distance_to(target_position) / t
	sw_inst.velocity = sw_speed * global_position.direction_to(target_position)

func switch_to_fall():
	anim_tree.set("parameters/StateMachine/conditions/following", false)
	
	global_position.y += body_meshes.position.y
	set_mesh_and_colliders_y_pos(0)
	behav_state = FALL
	
	await get_tree().create_timer(.75).timeout
	switch_to_retreat()

func fall_frame(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

func switch_to_retreat():
	# Start IK
	body_meshes.start_ik()
	behav_state = RETREAT

func retreat(_delta):
	target_position = retreat_dest
	
	rotate_y_to_vec(velocity, follow_turn_speed)
	if global_position.distance_to(target_position) <= nav_agent.target_desired_distance:
		switch_to_launch()
	else:
		nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * retreat_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func death_effect():
	var sw_inst = spitweb.instantiate()
	level.add_child.call_deferred(sw_inst)
	await sw_inst.tree_entered
	sw_inst.global_position = hitbox.global_position
	sw_inst.velocity = 5 * Vector3.UP
