extends Node3D
class_name BallSpawner

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var roller := preload("res://enemies/roller_ball.tscn")
var bouncer := preload("res://enemies/bouncer_ball.tscn")
var giant_roller := preload("res://enemies/giant_roller_ball.tscn")
var giant_bouncer := preload("res://enemies/giant_bouncer_ball.tscn")
var swarm := preload("res://enemies/swarm_ball.tscn")
var skull := preload("res://enemies/skull_ball.tscn")
var heavy := preload("res://enemies/heavy_ball.tscn")
var deathball := preload("res://enemies/death_ball.tscn")
var popper := preload("res://enemies/popper_ball.tscn")

var lateral_aiming_at_target := true
enum {
	STOP,
	AT_TARGET,
	HIGH_TARGET_TRAJECTORY,
	HIGH_BOUNCE_TRAJECTORY
}
var vert_aim_type := AT_TARGET
var vert_aiming_at_target := true
@export var attack_turn_speed := .1

@export var spawning := true
@export var spawn_cooldown_secs := 3.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"ROLLER": .0,
	"BOUNCER": .0,
	"GIANT_ROLLER": .0,
	"GIANT_BOUNCER": .0,
	"SWARM": .0,
	"SKULL": .0,
	"HEAVY": .0,
	"DEATHBALL": 1.0,
	"POPPER" : 1.0,
}

@export var roller_fwd_speed := 20.0
@export var roller_init_down_speed := 5.0 # downward y vel of rollers when they're first shot
@export var move_dir_angle_arc := 20.0
@export var bounce_height := 10.0
var high_target_trajectory_lateral_vel := 0.0
var init_high_target_trajectory_y_vel := 0.0 # y vel a high target trajectory projectile has upon launch

@export var swarm_size := 15.0

var skull_launched_by_mortar := false # If true, skull has initial upward vel. If not (it's shot by a cannon), it doesn't
@export var skull_follow_speed := 5.0
@export var skull_explode_dist := 5.0

@export var heavy_launch_height_from_launch_point := 20.0 # Y difference between point where heavy spawns and max height heavy reaches during flight, both in global coords
@export var arena_floor_y := 10.0

@export var deathball_move_speed := 15.0

@export var roller_chargeup_secs := 1.0
@export var bouncer_chargeup_secs := 2.0
@export var giant_roller_chargeup_secs := 5.0
@export var giant_bouncer_chargeup_secs := 5.0
@export var swarm_chargeup_secs := 5.0
@export var skull_chargeup_secs := 4.5
@export var heavy_chargeup_secs := 4.0

@onready var mesh = $MeshPivot
@onready var root = $/root/ViewControl
var level : Node3D
var target : Node3D

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")

func _physics_process(delta):
	update_high_target_trajectory_vels()
	if self and not spawn_cooldown_active and spawning and not spawn_limit_met():
		spawn_enemy()
	if lateral_aiming_at_target:
		lateral_look_at_target(attack_turn_speed)
	if spawn_cooldown_active:
		match(vert_aim_type):
			STOP:
				pass
			AT_TARGET:
				vert_look_at_target(attack_turn_speed * delta)
			HIGH_BOUNCE_TRAJECTORY:
				vert_look_high_bounce_trajectory(attack_turn_speed * delta)
			HIGH_TARGET_TRAJECTORY:
				vert_look_high_target_trajectory(attack_turn_speed * delta)

func update_high_target_trajectory_vels():
	# Init vel when ball is launched
	init_high_target_trajectory_y_vel = sqrt(2 * gravity * heavy_launch_height_from_launch_point)
	var self_target_height_diff := global_position.y - target.global_position.y
	# Vel when ball hits the ground from max height (assumes launcher is above target)
	var final_high_target_trajectory_y_vel = sqrt(2 * gravity * heavy_launch_height_from_launch_point + self_target_height_diff)
	# Total time = time to go up + time to fall down
	var total_flight_time : float = init_high_target_trajectory_y_vel / gravity + final_high_target_trajectory_y_vel / gravity
	var vec_to_target := target.global_position - global_position
	# Multiplier is used for fine-tuned accuracy adjustment
	var lateral_dist_to_target := 1.0 * Vector2(vec_to_target.x, vec_to_target.z).length()
	high_target_trajectory_lateral_vel = lateral_dist_to_target / total_flight_time

func lateral_look_at_target(turn_speed):
	var old_global_rotation := rotation
	look_at(target.global_position)
	var target_global_rotation := rotation
	rotation = old_global_rotation
	rotation.y = clampf(move_toward(rotation.y, target_global_rotation.y, turn_speed), -PI/4, PI/4)

func vert_look_at_target(turn_speed):
	var old_global_rotation = mesh.rotation
	mesh.look_at(target.global_position)
	var target_global_rotation = mesh.rotation
	mesh.rotation = old_global_rotation
	mesh.rotation.x = move_toward(mesh.rotation.x, target_global_rotation.x, turn_speed)
	#mesh.global_rotation.x = lerp_angle(mesh.global_rotation.x, target_global_rotation.x, turn_speed)

func vert_look_high_bounce_trajectory(turn_speed):
	# global_rotation "upward" = tan^-1(y_vel/x_vel)
	var target_global_rotation_x = atan2(bounce_height, .25 * roller_fwd_speed)
	mesh.rotation.x = move_toward(mesh.rotation.x, target_global_rotation_x, turn_speed)
	#mesh.global_rotation.x = lerp_angle(mesh.global_rotation.x, target_global_rotation_x, turn_speed)

func vert_look_high_target_trajectory(turn_speed):
	# global_rotation "upward" = tan^-1(y_vel/x_vel)
	var target_global_rotation_x = atan2(init_high_target_trajectory_y_vel, high_target_trajectory_lateral_vel)
	mesh.rotation.x = move_toward(mesh.rotation.x, target_global_rotation_x, turn_speed)
	#mesh.global_rotation.x = lerp_angle(mesh.global_rotation.x, target_global_rotation_x, turn_speed)

func spawn_limit_met():
	if level:
		return get_tree().get_nodes_in_group("lockonables").size() >= level.lockonable_limit
	else:
		return true

func spawn_enemy():
	spawn_cooldown_active = true
	await choose_enemy()
	await get_tree().create_timer(spawn_cooldown_secs).timeout
	spawn_cooldown_active = false

func choose_enemy():
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for enemy in enemy_chances:
		cumulative_weight += enemy_chances[enemy]
		if choice <= cumulative_weight:
			await spawn_from_name(enemy)
			return
	await spawn_from_name("default")
	
func spawn_from_name(enemy_name):
	match(enemy_name):
		"ROLLER":
			await spawn_roller()
		"BOUNCER":
			await spawn_bouncer()
		"GIANT_ROLLER":
			await spawn_giant_roller()
		"GIANT_BOUNCER":
			await spawn_giant_bouncer()
		"SWARM":
			await spawn_swarm()
		"SKULL":
			await spawn_skull()
		"HEAVY":
			await spawn_heavy()
		"DEATHBALL":
			await spawn_deathball()
		"POPPER":
			await spawn_popper()
		"default":
			print("Error: attempted to spawn unknown enemy: ", enemy_name)
			await spawn_roller()

func spawn_roller():
	vert_aim_type = STOP
	lateral_aiming_at_target = false
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = mesh.global_rotation
	b.linear_velocity = roller_fwd_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = -roller_init_down_speed

func spawn_bouncer():
	vert_aim_type = STOP
	await get_tree().create_timer(bouncer_chargeup_secs).timeout
	var b = bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = high_target_trajectory_lateral_vel * global_position.direction_to(target.global_position)
	b.linear_velocity.y = init_high_target_trajectory_y_vel

func spawn_giant_roller():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(giant_roller_chargeup_secs).timeout
	var b = giant_roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = roller_fwd_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = -roller_init_down_speed

func spawn_giant_bouncer():
	vert_aim_type = HIGH_BOUNCE_TRAJECTORY
	await get_tree().create_timer(giant_bouncer_chargeup_secs).timeout
	var b = giant_bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = .25 * roller_fwd_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = bounce_height

func spawn_swarm():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(swarm_chargeup_secs).timeout
	for i in range(swarm_size):
		var b = swarm.instantiate()
		level.add_child.call_deferred(b)
		await b.tree_entered
		b.global_position = global_position
		var move_dir_half_arc := deg_to_rad(move_dir_angle_arc) / 2
		b.global_rotation = global_rotation + rng.randf_range(-move_dir_half_arc, move_dir_half_arc) * Vector3.UP
		b.linear_velocity = roller_fwd_speed * -b.get_global_transform().basis.z
		b.linear_velocity.y = -roller_init_down_speed

func spawn_skull():
	vert_aim_type = STOP
	await get_tree().create_timer(skull_chargeup_secs).timeout
	var b = skull.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	if skull_launched_by_mortar:
		# If skull ball was launched by mortar, give it initial upward speed
		b.linear_velocity.y = 2 * roller_init_down_speed
	b.follow_speed = skull_follow_speed
	b.explode_dist = skull_explode_dist

func spawn_heavy():
	vert_aim_type = STOP
	await get_tree().create_timer(heavy_chargeup_secs).timeout
	var b = heavy.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = high_target_trajectory_lateral_vel * global_position.direction_to(target.global_position)
	b.linear_velocity.y = init_high_target_trajectory_y_vel
	b.arena_floor_y = arena_floor_y

func spawn_deathball():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = deathball.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.velocity = deathball_move_speed * -b.get_global_transform().basis.z

func spawn_popper():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = popper.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = global_rotation
	b.linear_velocity = roller_fwd_speed * -b.get_global_transform().basis.z
