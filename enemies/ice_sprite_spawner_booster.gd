extends Node3D

@export var move_speed := 6.0
@export var ring_rotate_speed := 1.8
var r1_rotate_dir := Vector3.ONE
var r2_rotate_dir := Vector3.ONE

# Ring vars
@onready var root := get_tree().root
@onready var ring1 := $Ring1
@onready var ring2 := $Ring2

var level : Node3D
var spawner_visuals : Node3D

func _ready():
	level = root.find_child("Level", true, false)
	var spawner = level.find_children("IceSpriteSpawner", "IceSpriteSpawner", true, false)[0]
	spawner_visuals = spawner.find_child("Visuals")
	
	# Set a random ring rotation dir across all axes
	r1_rotate_dir = Vector3(
		randf_range(0.0, TAU),
		randf_range(0.0, TAU),
		randf_range(0.0, TAU)
	).normalized()
	ring1.rotation = r1_rotate_dir
	
	r2_rotate_dir = Vector3(
		randf_range(0.0, TAU),
		randf_range(0.0, TAU),
		randf_range(0.0, TAU)
	).normalized()
	ring2.rotation = r2_rotate_dir

func _physics_process(delta):
	global_position += move_speed * delta * global_position.direction_to(spawner_visuals.global_position)
	# Rotate around its local X axis
	ring1.rotate_object_local(r1_rotate_dir, ring_rotate_speed * delta)
	ring2.rotate_object_local(r2_rotate_dir, ring_rotate_speed * delta)
	if global_position.distance_to(spawner_visuals.global_position) < .1:
		queue_free()
