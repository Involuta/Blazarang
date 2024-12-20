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

var lateral_aiming_at_target := true
enum {
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
	"ROLLER": .25,
	"BOUNCER": .25,
	"GIANT_ROLLER": .0,
	"GIANT_BOUNCER": .0,
	"SWARM": .0,
	"SKULL": .25,
	"HEAVY": .25
}

@export var move_speed := 20.0
@export var move_dir_angle_arc := 20.0
@export var bounce_height := 20.0
var high_target_trajectory_lateral_vel := 0.0
var high_target_trajectory_y_vel := 0.0

@export var swarm_size := 15.0

@export var skull_follow_speed := 5.0
@export var skull_explode_dist := 5.0

@export var heavy_launch_height := 40.0
@export var arena_floor_y := 10.0

@export var roller_chargeup_secs := 1.0
@export var bouncer_chargeup_secs := 2.0
@export var giant_roller_chargeup_secs := 5.0
@export var giant_bouncer_chargeup_secs := 5.0
@export var swarm_chargeup_secs := 5.0
@export var skull_chargeup_secs := 4.5
@export var heavy_chargeup_secs := 4.0

@onready var mesh = $Mesh
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
			AT_TARGET:
				vert_look_at_target(attack_turn_speed * delta)
			HIGH_BOUNCE_TRAJECTORY:
				vert_look_high_bounce_trajectory(attack_turn_speed * delta)
			HIGH_TARGET_TRAJECTORY:
				vert_look_high_target_trajectory(attack_turn_speed * delta)

func update_high_target_trajectory_vels():
	high_target_trajectory_y_vel = sqrt(2 * gravity * heavy_launch_height + global_position.y)
	var total_flight_time : float = 2 * high_target_trajectory_y_vel / gravity
	var vec_to_target := target.global_position - global_position
	var lateral_dist_to_target := 1.42 * Vector2(vec_to_target.x, vec_to_target.z).length()
	high_target_trajectory_lateral_vel = lateral_dist_to_target / total_flight_time

func lateral_look_at_target(turn_speed):
	var old_rotation := rotation
	look_at(target.global_position)
	var target_rotation := rotation
	rotation = old_rotation
	rotation.y = move_toward(rotation.y, target_rotation.y, turn_speed)
	#rotation.y = lerp_angle(rotation.y, target_rotation.y, turn_speed)

func vert_look_at_target(turn_speed):
	var old_rotation = mesh.rotation
	mesh.look_at(target.global_position)
	var target_rotation = mesh.rotation
	mesh.rotation = old_rotation
	mesh.rotation.x = move_toward(mesh.rotation.x, target_rotation.x, turn_speed)
	#mesh.rotation.x = lerp_angle(mesh.rotation.x, target_rotation.x, turn_speed)

func vert_look_high_bounce_trajectory(turn_speed):
	# Rotation "upward" = tan^-1(y_vel/x_vel)
	var target_rotation_x = atan2(bounce_height, .25 * move_speed)
	mesh.rotation.x = move_toward(mesh.rotation.x, target_rotation_x, turn_speed)
	#mesh.rotation.x = lerp_angle(mesh.rotation.x, target_rotation_x, turn_speed)

func vert_look_high_target_trajectory(turn_speed):
	# Rotation "upward" = tan^-1(y_vel/x_vel)
	var target_rotation_x = atan2(high_target_trajectory_y_vel, high_target_trajectory_lateral_vel)
	mesh.rotation.x = move_toward(mesh.rotation.x, target_rotation_x, turn_speed)
	#mesh.rotation.x = lerp_angle(mesh.rotation.x, target_rotation_x, turn_speed)

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
		"default":
			print("Error: attempted to spawn unknown enemy")
			await spawn_roller()

func spawn_roller():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(roller_chargeup_secs).timeout
	var b = roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = move_speed * -b.get_global_transform().basis.z

func spawn_bouncer():
	vert_aim_type = HIGH_BOUNCE_TRAJECTORY
	await get_tree().create_timer(bouncer_chargeup_secs).timeout
	var b = bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = .25 * move_speed * -b.get_global_transform().basis.z
	b.linear_velocity.y = bounce_height

func spawn_giant_roller():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(giant_roller_chargeup_secs).timeout
	var b = giant_roller.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = move_speed * -b.get_global_transform().basis.z

func spawn_giant_bouncer():
	vert_aim_type = HIGH_BOUNCE_TRAJECTORY
	await get_tree().create_timer(giant_bouncer_chargeup_secs).timeout
	var b = giant_bouncer.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = .25 * move_speed * -b.get_global_transform().basis.z
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
		b.global_rotation = rotation + rng.randf_range(-move_dir_half_arc, move_dir_half_arc) * Vector3.UP
		b.linear_velocity = move_speed * -b.get_global_transform().basis.z
		b.linear_velocity.y = rng.randfn()

func spawn_skull():
	vert_aim_type = AT_TARGET
	await get_tree().create_timer(skull_chargeup_secs).timeout
	var b = skull.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = move_speed * -b.get_global_transform().basis.z
	b.follow_speed = skull_follow_speed
	b.explode_dist = skull_explode_dist

func spawn_heavy():
	vert_aim_type = HIGH_TARGET_TRAJECTORY
	await get_tree().create_timer(heavy_chargeup_secs).timeout
	var b = heavy.instantiate()
	level.add_child.call_deferred(b)
	await b.tree_entered
	b.global_position = global_position
	b.global_rotation = rotation
	b.linear_velocity = high_target_trajectory_lateral_vel * -b.get_global_transform().basis.z
	b.linear_velocity.y = high_target_trajectory_y_vel
	b.arena_floor_y = arena_floor_y
