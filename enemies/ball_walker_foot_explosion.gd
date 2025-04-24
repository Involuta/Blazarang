extends Node3D

@export var disappear_secs := 1.0
@export var num_spawned_balls := 7.0
@export var ball_spawn_radius := 7.0 # Dist from foot's global position that each ball spawns at
@export var ball_move_speed := 10.0

@onready var root = $/root/ViewControl

var swarm := preload("res://enemies/swarm_ball.tscn")
var level : Node3D

func _ready():
	level = root.find_child("Level")
	spawn_balls()
	await get_tree().create_timer(disappear_secs).timeout
	queue_free()

func spawn_balls():
	var ball_vec := Vector3.FORWARD
	for i in range(num_spawned_balls):
		var b = swarm.instantiate()
		level.add_child.call_deferred(b)
		await b.tree_entered
		b.global_position = global_position + ball_spawn_radius * ball_vec
		b.linear_velocity = ball_move_speed * ball_vec
		ball_vec = ball_vec.rotated(Vector3.UP, 2 * PI / num_spawned_balls)
