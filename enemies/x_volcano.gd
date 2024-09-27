extends Node3D

@export var disappear_secs := 1.0
@export var square_particle_num := 8
@export var square_particle_speed := 20.0

var square_particle := preload("res://enemies/square_particle.tscn")

@onready var level := $/root/Level
@onready var rng := RandomNumberGenerator.new()

func _ready():
	print("bing")
	for i in range(square_particle_num):
		var sp := square_particle.instantiate()
		add_child(sp)
		sp.global_position = global_position
		sp.linear_velocity = square_particle_speed * Vector3(rng.randf_range(-1, 1), rng.randf_range(.25, 1), rng.randf_range(-1, 1)).normalized()
	await get_tree().create_timer(disappear_secs).timeout
	queue_free()
