extends CharacterBody3D

enum {
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

const FOLLOW_SPEED = 5.0

const ATTACK_DURATION_SECS = 1.5

var aiming_at_target = true

var rng := RandomNumberGenerator.new()
@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer
@onready var cotu = $/root/Arena/cotuCB
@onready var target = $/root/Arena/Target

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
	print("pew!")
