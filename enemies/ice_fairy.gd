extends CharacterBody3D

@export var entity_name := "IceFairy" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

enum {
	FOLLOW,
	ATTACK
}
var behav_state = FOLLOW

var ice_shot := preload("res://enemies/ice_fairy_shot.tscn")

@export_group("Ice Sprite Parameters")
var follow_speed := 5.0 # Ice sprite follow speed is set to be very similar to if not identical to Cotu's walk speed
@export var target_distance := 4.5
@export var follow_turn_speed := .15
@export var attack_turn_speed := .5
@export var jump_vertical_speed := 3.6

@export_group("Fairy Mvmt Parameters")
@export var min_orbit_speed := .2
@export var max_orbit_speed := .4

@export var min_orbit_radius := 6.0
@export var max_orbit_radius := 12.0

@export var min_height_offset := 1.0
@export var max_height_offset := 7.0

@export var speed_change_interval_min := 6.0
@export var speed_change_interval_max := 12.0
@export var speed_transition_duration := 1.5
@export var fairy_drift_speed := 4.0
@export var fairy_orbit_tolerance := 1.5 # Distance buffer around the orbit radius to switch to orbiting

@export_group("Fairy Attack Parameters")
@export var ice_shot_speed := 6.0
@export var shoot_interval_min := 3.0
@export var shoot_interval_max := 7.0

# Active orbit state variables modified dynamically
var current_orbit_speed := 2.0
var current_orbit_radius := 3.5
var current_height_offset := 1.5
var current_orbit_direction := 1.0 # 1.0 for counter-clockwise, -1.0 for clockwise

var speed_timer := 0.0
var next_speed_change_time := 0.0
var state_tween : Tween

var shoot_timer := 0.0
var next_shoot_time := 0.0

var fairy_orbit_angle := 0.0

var is_fairy := false # Set to true in ready_fairy func
var explosion_triggered := false # Set to true when close to player
@export var explode_secs := 6.0

var aiming_at_target := true

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
@onready var anim_player := $AnimationPlayer
@onready var hurtbox := $EnemyHurtbox
@onready var fairy_glow := $FairyGlowMesh
@onready var root := get_tree().root

var level : Node3D
var target : Node3D
var cotu : Node3D # Used to get player's vel. Enemy moves when the player moves
var clarity : Node3D

func _ready():
	level = root.find_child("Level", true, false)
	target = root.find_child("Icon", true, false)
	cotu = root.find_child("cotuCB", true, false)
	clarity = root.find_child("Clarity", true, false)
	follow_speed = cotu.walk_speed * .76
	current_orbit_speed = rng.randf_range(min_orbit_speed, max_orbit_speed)
	current_orbit_radius = rng.randf_range(min_orbit_radius, max_orbit_radius)
	current_height_offset = rng.randf_range(min_height_offset, max_height_offset)
	current_orbit_direction = 1.0 if rng.randf() > 0.5 else -1.0
	schedule_next_speed_change()
	schedule_next_shot()
	add_to_group("lockonables")

func _physics_process(delta):
	if is_fairy:
		process_fairy_speed_timer(delta)
		process_fairy_movement(delta)
		process_shooting_timer(delta)
	else:
		if not explosion_triggered and global_position.distance_to(target.global_position) < target_distance:
			trigger_sprite_chargeup()
		if is_on_floor():
			if not explosion_triggered:
				jump()
		else:
			velocity.y -= .67 * gravity * delta
	move_and_slide()
	if global_position.y < -100:
		queue_free()

func process_shooting_timer(delta: float):
	shoot_timer += delta
	if shoot_timer >= next_shoot_time:
		shoot_timer = 0.0
		schedule_next_shot()
		anim_player.play("shoot")

func schedule_next_shot():
	next_shoot_time = rng.randf_range(shoot_interval_min, shoot_interval_max)

func process_fairy_speed_timer(delta: float):
	speed_timer += delta
	if speed_timer >= next_speed_change_time:
		speed_timer = 0.0
		schedule_next_speed_change()
		
		var target_speed = rng.randf_range(min_orbit_speed, max_orbit_speed)
		var target_radius = rng.randf_range(min_orbit_radius, max_orbit_radius)
		var target_height = rng.randf_range(min_height_offset, max_height_offset)
		var target_direction = 1.0 if rng.randf() > 0.5 else -1.0
		
		tween_fairy_orbit_state(target_speed, target_radius, target_height, target_direction)

func schedule_next_speed_change():
	next_speed_change_time = rng.randf_range(speed_change_interval_min, speed_change_interval_max)

func tween_fairy_orbit_state(target_speed: float, target_radius: float, target_height: float, target_direction: float):
	if state_tween and state_tween.is_running():
		state_tween.kill()
	
	state_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	state_tween.tween_property(self, "current_orbit_speed", target_speed, speed_transition_duration)
	state_tween.tween_property(self, "current_orbit_radius", target_radius, speed_transition_duration)
	state_tween.tween_property(self, "current_height_offset", target_height, speed_transition_duration)
	state_tween.tween_property(self, "current_orbit_direction", target_direction, speed_transition_duration)

func process_fairy_movement(delta: float):
	if not is_instance_valid(clarity):
		return

	var target_clarity_pos = clarity.global_position + Vector3(0, current_height_offset, 0)
	var dist_to_clarity = global_position.distance_to(target_clarity_pos)

	# If too far from Clarity's orbit distance, drift directly towards her target position
	if dist_to_clarity > (current_orbit_radius + fairy_orbit_tolerance):
		var move_dir = global_position.direction_to(target_clarity_pos)
		velocity = move_dir * fairy_drift_speed
		
		# Sync orbit angle with current position relative to Clarity to avoid sudden snapping when starting orbit
		var relative_pos = global_position - target_clarity_pos
		fairy_orbit_angle = atan2(relative_pos.z, relative_pos.x)
	else:
		# Close enough: Follow a circular path around Clarity using active lerped parameters
		fairy_orbit_angle += (current_orbit_speed * current_orbit_direction) * delta
		
		var desired_orbit_pos = target_clarity_pos + Vector3(
			cos(fairy_orbit_angle) * current_orbit_radius,
			0.0,
			sin(fairy_orbit_angle) * current_orbit_radius
		)
		
		# Smoothly slide towards the active orbit point
		var to_desired = desired_orbit_pos - global_position
		velocity = to_desired * fairy_drift_speed

	lerp_look_at_walk_dir(follow_turn_speed)

func lerp_look_at_target(turn_speed):
	var vec3_to_target := global_position.direction_to(target.global_position)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)

func lerp_look_at_walk_dir(turn_speed):
	if velocity.length_squared() > 0.01:
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

func trigger_sprite_chargeup():
	explosion_triggered = true
	anim_player.play("sprite_chargeup")

# Called by hurtbox OR chargeup anim
func death_effect():
	if is_fairy:
		anim_player.play("fairy_die")
		await anim_player.animation_finished
		queue_free()
	else:
		# If the explosion was triggered, explode ice sprite,
		# then become fairy
		if explosion_triggered:
			anim_player.play("sprite_explode")
			await anim_player.animation_finished
			anim_player.play("ready_fairy")
		# If the explosion wasn't triggered, don't explode ice sprite
		else:
			# Stop ice sprite from jumping while dying
			explosion_triggered = true
			anim_player.play("sprite_die")
			await anim_player.animation_finished
			await get_tree().create_timer(explode_secs).timeout
			queue_free()

# This func is here so that when EnemyHurtbox calls its die func, set_active is called instead of queue freeing this Ice Sprite node
func set_active(_state: bool):
	return

func ready_fairy_start():
	is_fairy = true
	# Move fairy glow local pos down to be with the rest of the node,
	# Then move the node up to the height the glow was at
	var y = fairy_glow.position.y
	fairy_glow.position = Vector3.ZERO
	global_position.y += y
	# Fairy dies in 1 hit during ready_fairy anim
	hurtbox.health = 1

func ready_fairy_end():
	hurtbox.health = hurtbox.max_health

func shoot():
	var bullet_inst = ice_shot.instantiate()
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position
	bullet_inst.look_at(target.global_position)
	bullet_inst.velocity = ice_shot_speed * -bullet_inst.get_global_transform().basis.z
