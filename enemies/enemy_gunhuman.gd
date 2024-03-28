extends CharacterBody3D

enum {
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

const TARGET_DISTANCE := 20.0
const FOLLOW_SPEED := 5.0

const ATTACK_DURATION_SECS := 1.5
const BULLET_SPEED := 30.0

var aiming_at_target := true

var rng := RandomNumberGenerator.new()
var bullet := preload("res://enemies/enemy_bullet.tscn")
@onready var nav_agent := $NavigationAgent3D
@onready var animation_player := $AnimationPlayer
@onready var arena := $/root/Arena
@onready var cotu := $/root/Arena/cotuCB
@onready var target := $/root/Arena/Target

func _ready():
	add_to_group("lockonables")

func _physics_process(_delta):
	match(behav_state):
		FOLLOW:
			follow()
		ATTACK:
			attack()

func _on_navigation_agent_3d_target_reached():
	if behav_state != ATTACK:
		start_attack()

func _on_navigation_agent_3d_velocity_computed(safe_velocity):
	# This line accelerates the agent rather than setting its velocity to its desired velocity directly, preventing it from getting caught on corners
	if behav_state == FOLLOW:
		velocity = velocity.move_toward(safe_velocity, .25)
	move_and_slide()

func follow():
	look_at(target.global_position)
	nav_agent.set_target_position(target.global_position)
	var next_position = nav_agent.get_next_path_position()
	var new_velocity = (next_position - global_position).normalized() * FOLLOW_SPEED
	
	# Sets new wanted velocity, not actual velocity. Wanted velocity is used to compute new safe velocity
	nav_agent.velocity = new_velocity
	
	# If player isn't in sight, reduce target distance to a very small number
	if can_see_target():
		nav_agent.target_desired_distance = TARGET_DISTANCE
	else:
		nav_agent.target_desired_distance = .1

func start_attack():
	behav_state = ATTACK
	aiming_at_target = true
	animation_player.play("shoot")
	await get_tree().create_timer(ATTACK_DURATION_SECS).timeout
	behav_state = FOLLOW

func attack():
	nav_agent.velocity = Vector3.ZERO
	velocity = Vector3.ZERO
	if aiming_at_target:
		look_at(target.global_position)
	
func stop_aiming_at_target():
	aiming_at_target = false

func shoot_bullet():
	var bullet_inst = bullet.instantiate()
	arena.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position
	bullet_inst.velocity = BULLET_SPEED * global_position.direction_to(target.global_position)
	bullet_inst.look_at(target.global_position)

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
