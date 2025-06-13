extends CharacterBody3D

@onready var nav_agent := $NavigationAgent3D
@onready var body_meshes := $ParamiteMeshes
@onready var physical_collider := $CollisionShape3D
@onready var hurtbox := $EnemyHurtbox
@onready var anim_player := $ParamiteMeshes/AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hitbox : Node3D
var target : Node3D
enum {
	LAUNCH,
	FOLLOW,
	FALL,
}
var behav_state := LAUNCH

@export var launch_vert_speed := 12.0 # Initial vertical launch speed (lateral speed is set by paramite spawner)
@export var follow_duration := 10.0 # Time mite spends following before falling
@export var fall_height := 6.0 # Height above the ground mite descends to before falling

var target_position := Vector3.ZERO # Position mite moves to; set to target.global_position when not strafing and set to a point beside and behind the target when strafing ("fwd" = to the target)

@export var follow_speed := 3.0
@export var follow_turn_speed := .1

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("MeleeHitboxPivot")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	anim_tree.active = true
	
	set_mesh_and_colliders_y_pos(0)
	
	velocity.y = launch_vert_speed

func set_mesh_and_colliders_y_pos(new_y_pos: float):
	body_meshes.position.y = new_y_pos
	physical_collider.position.y = new_y_pos
	hurtbox.position.y = new_y_pos

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
	
	move_and_slide()

func lerp_look_at_move_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(velocity.x, velocity.z), turn_speed)

func _on_navigation_agent_3d_target_reached():
	pass

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW:
		"""
		if is_on_floor():
			# This line accelerates the agent rather than setting its velocity to its desired velocity directly, preventing it from getting caught on corners
			velocity = velocity.move_toward(safe_velocity, .25)
		else:
			# If the enemy is in the air, don't use navigation agent at all
			var move_dir = global_position.direction_to(target_position)
			velocity.x = follow_speed * move_dir.x
			velocity.z = follow_speed * move_dir.z
		"""
		velocity = velocity.move_toward(safe_velocity, .25)
		#velocity.y = -.5
	move_and_slide()

func launch_frame(delta):
	if velocity.y <= 0:
		switch_to_follow()
	
	if not is_on_floor():
		velocity.y -= gravity * delta

func switch_to_follow():
	# Placeholder: replace y pos with true y dist from ground obtained from raycast
	# To do: set parent object global position to the ground height obtained from raycast
	var height_from_ground = get_height_from_ground()
	global_position.y -= height_from_ground
	set_mesh_and_colliders_y_pos(height_from_ground)
	behav_state = FOLLOW
	
	var glide_descend_tween = get_tree().create_tween()
	glide_descend_tween.set_parallel()
	glide_descend_tween.tween_property(body_meshes, "position", Vector3(0,fall_height,-.5), follow_duration)
	glide_descend_tween.tween_property(physical_collider, "position", Vector3(0,fall_height,0), follow_duration)
	glide_descend_tween.tween_property(hurtbox, "position", Vector3(0,fall_height,0), follow_duration)
	await glide_descend_tween.finished
	switch_to_fall()

func follow(_delta):
	target_position = target.global_position
	
	lerp_look_at_move_dir(follow_turn_speed)
	global_rotation.x = 0
	global_rotation.z = 0
	nav_agent.set_target_position(target_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func switch_to_fall():
	global_position.y += body_meshes.position.y
	set_mesh_and_colliders_y_pos(0)
	behav_state = FALL

func fall_frame(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
