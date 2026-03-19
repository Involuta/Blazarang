extends CharacterBody3D

@export var entity_name := "IceSprite" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

enum {
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

var follow_speed := 5.0 # Ice sprite follow speed is set to be very similar to if not identical to Cotu's walk speed
@export var target_distance := 3.0
@export var follow_turn_speed := .15
@export var attack_turn_speed := .5
@export var jump_vertical_speed := 5.0
@export var jump_lateral_speed := 9.0

var aiming_at_target := true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
@onready var nav_agent = $NavigationAgent3D
@onready var visual_mesh = $VisualMesh
@onready var root := $/root/ViewControl

var target : Node3D
var cotu : Node3D # Used to get player's vel. Enemy moves when the player moves

func _ready():
	target = root.find_child("Icon")
	cotu = root.find_child("cotuCB")
	follow_speed = cotu.walk_speed * .67
	add_to_group("lockonables")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	match(behav_state):
		FOLLOW:
			follow()
		ATTACK:
			attack()
			
	if global_position.y < -100:
		queue_free()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func lerp_look_at_walk_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(velocity.x, velocity.z), turn_speed)

func _on_navigation_agent_3d_target_reached():
	if behav_state != ATTACK:
		start_attack()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	if behav_state == FOLLOW:
		if is_on_floor():
			if cotu.walk_input.length() > 0:
				velocity = safe_velocity
				lerp_look_at_walk_dir(follow_turn_speed)
				global_rotation.x = 0
				global_rotation.z = 0
			else:
				velocity = Vector3.ZERO
		else:
			# If the enemy is in the air, don't use navigation agent at all
			var move_dir = global_position.direction_to(target.global_position)
			velocity.x = follow_speed * move_dir.x
			velocity.z = follow_speed * move_dir.z
	move_and_slide()

func follow():
	nav_agent.set_target_position(target.global_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * follow_speed
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity

func start_attack():
	behav_state = ATTACK
	aiming_at_target = true
	await get_tree().create_timer(.5).timeout
	behav_state = FOLLOW

func stop_lateral_mvmt():
	velocity.x = 0
	velocity.z = 0

func attack():
	nav_agent.velocity.x = 0
	nav_agent.velocity.z = 0

# Keep this here until it's confirmed that Clarity's arena won't have obstacles
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
