extends CharacterBody3D

@export var entity_name := "IceSprite" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

enum {
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

var follow_speed := 5.0 # Ice sprite follow speed is set to be very similar to if not identical to Cotu's walk speed
@export var target_distance := 4.5
@export var follow_turn_speed := .15
@export var attack_turn_speed := .5
@export var jump_vertical_speed := 3.6

var explosion_triggered := false # Set to true when close to player
var explosion_started := false # Set to true when explosion starts. Exported so it's changeable via anim player
@export var explode_secs := 6.0

var aiming_at_target := true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
@onready var anim_player := $AnimationPlayer
@onready var hurtbox := $EnemyHurtbox
@onready var root := get_tree().root

var target : Node3D
var cotu : Node3D # Used to get player's vel. Enemy moves when the player moves

func _ready():
	target = root.find_child("Icon", true, false)
	cotu = root.find_child("cotuCB", true, false)
	follow_speed = cotu.walk_speed * .76
	add_to_group("lockonables")

func _physics_process(delta):
	if not explosion_triggered and global_position.distance_to(target.global_position) < target_distance:
		start_attack()
	if is_on_floor():
		if not explosion_triggered:
			jump()
	else:
		velocity.y -= .67 * gravity * delta
	move_and_slide()
	if global_position.y < -100:
		queue_free()

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func lerp_look_at_walk_dir(turn_speed):
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(velocity.x, velocity.z), turn_speed)

func follow():
	if is_on_floor():
		jump()
	lerp_look_at_walk_dir(follow_turn_speed)

func jump():
	velocity = follow_speed*global_position.direction_to(target.global_position)
	velocity.y = jump_vertical_speed
	global_rotation.x = 0
	global_rotation.z = 0

func start_attack():
	explosion_triggered = true
	follow_speed *= 1.25
	jump_vertical_speed *= .75
	anim_player.play("chargeup")

# Called by hurtbox OR chargeup anim
func death_effect():
	explosion_triggered = true
	# explosion_started is set by anim keyframe, not here. This is bc the explode anim also contains the flashing telegraph; after that, the explosion starts and explosion_started is set to true
	anim_player.play("explode")
	hurtbox.process_mode = Node.PROCESS_MODE_DISABLED
	await anim_player.animation_finished
	await get_tree().create_timer(explode_secs).timeout
	queue_free()

func set_explosion_started():
	explosion_started = true

# This func is here so that when EnemyHurtbox calls its die func, set_active is called instead of queue freeing this Ice Sprite node
func set_active(_state: bool):
	return
