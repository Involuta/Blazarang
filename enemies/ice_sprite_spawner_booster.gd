extends Node3D

@export var move_speed := 1.8
@export var ring_rotate_speed := 1.8

# Ring vars
@onready var root := get_tree().root
@onready var ring1 := $Ring1
@onready var ring2 := $Ring2

var spawner : Node3D

func _ready():
	# Loop through all children of the root node
	for child in root.get_children():
		# Check if the child has the IceSpriteSpawner class script attached
		if child is IceSpriteSpawner:
			spawner = child
			break # Stop looping once we find it

func _physics_process(delta):
	global_position += move_speed * delta * global_position.direction_to(spawner.global_position)
