extends CharacterBody3D

@export var entity_name := "EnemyMobileGunner"

enum {
	WAIT,
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

@export var aggro_distance := -1

@export var follow_speed := 5.0
@export var target_distance := 20.0

var aiming_at_target := true
@export var bullet_speed := 30.0

@export var follow_turn_speed := .15
@export var attack_turn_speed := .15

var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bullet := preload("res://enemies/enemy_bullet.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var anim_player := $AnimationPlayer
@onready var anim_tree := $AnimationTree
@onready var gun_mesh := $MobileGunner/ControlRig/Skeleton3D/BoneAttachment3D/BasicGun
@onready var level := $/root/Level
@onready var target := $/root/Level/Icon

func _ready():
	add_to_group("lockonables")
	if aggro_distance > 0:
		nav_agent.process_mode = Node.PROCESS_MODE_DISABLED
		behav_state = WAIT

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	match(behav_state):
		WAIT:
			wait()
		FOLLOW:
			follow()
		ATTACK:
			attack()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func lerp_look_at_walk_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(velocity.x, velocity.z), turn_speed)

func wait():
	move_and_slide()
	if global_position.distance_to(target.global_position) < aggro_distance:
		nav_agent.process_mode = Node.PROCESS_MODE_INHERIT
		behav_state = FOLLOW

func _on_navigation_agent_3d_target_reached():
	if behav_state != ATTACK:
		start_attack()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW:
		if is_on_floor():
			# This line accelerates the agent rather than setting its velocity to its desired velocity directly, preventing it from getting caught on corners
			velocity = velocity.move_toward(safe_velocity, .25)
		else:
			# If the enemy is in the air, don't use navigation agent at all
			var move_dir = global_position.direction_to(target.global_position)
			velocity.x = follow_speed / 2 * move_dir.x
			velocity.z = follow_speed / 2 * move_dir.z
	
	move_and_slide()

func follow():
	lerp_look_at_walk_dir(follow_turn_speed)
	nav_agent.set_target_position(target.global_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# If player isn't in sight, reduce target distance to a very small number
	if can_see_target():
		nav_agent.target_desired_distance = target_distance
	else:
		nav_agent.target_desired_distance = .1
	
	anim_tree.set("parameters/StateMachine/WalkBlendSpace/blend_position", velocity.length())

func start_attack():
	behav_state = ATTACK
	aiming_at_target = true
	anim_tree.set("parameters/StateMachine/conditions/shoot", true)

func try_end_attack():
	if global_position.distance_to(target.global_position) > target_distance:
		anim_tree.set("parameters/StateMachine/conditions/shoot", false)
		behav_state = FOLLOW
	else:
		aiming_at_target = true

func attack():
	nav_agent.velocity.x = 0
	nav_agent.velocity.z = 0
	velocity.x = 0
	velocity.z = 0
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)
	
func stop_aiming_at_target():
	aiming_at_target = false

func shoot_bullet():
	var bullet_inst = bullet.instantiate()
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = gun_mesh.global_position
	bullet_inst.global_rotation = gun_mesh.global_rotation
	bullet_inst.velocity = bullet_speed * -bullet_inst.get_global_transform().basis.z

func can_see_target():
	var space_state := get_world_3d().direct_space_state
	var sight_dir := global_position.direction_to(target.global_position)
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + nav_agent.neighbor_distance * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER, Globals.TARGET_COL_LAYER])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if not result:
		return false
	if result.collider.collision_layer == Globals.ARENA_COL_LAYER:
		return false
	else:
		return true
