extends CharacterBody3D

enum {
	WAIT,
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

@export var aggro_distance := -1

@export var follow_speed := 10.0
@export var target_distance := 4.0

@export var attack_duration_secs := 2.5

var aiming_at_target := true

@export var sweep_chance := .5
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer
@onready var cotu = $/root/Arena/cotuCB
@onready var target = $/root/Arena/Target

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
			
	if global_position.y < -100:
		queue_free()

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
	look_at(target.global_position)
	rotation.x = 0
	rotation.z = 0
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

func start_attack():
	behav_state = ATTACK
	aiming_at_target = true
	animation_player.play(choose_attack())
	await get_tree().create_timer(attack_duration_secs).timeout
	behav_state = FOLLOW

func choose_attack() -> String:
	var choice := rng.randf()
	if choice <= sweep_chance:
		return "big_sweep"
	else:
		return "big_overhead"

func attack():
	nav_agent.velocity.x = 0
	nav_agent.velocity.z = 0
	velocity.x = 0
	velocity.z = 0
	if aiming_at_target:
		look_at(target.global_position)
		rotation.x = 0
		rotation.z = 0
	
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
