extends Node3D

@export var max_brightness := 12.0
@export var min_brightness := 6.0
@export var appear_dim_time := 12.0
@export var max_height := 60.0
@export var rise_time := 60.0
@export var min_scale := 1.0
@export var max_scale := 6.0

# Hexagon vars
@export var cycle_time := 3.6
@export var hex_interval := 0.6

@onready var root := get_tree().root
@onready var visuals := $Visuals
@onready var hex1 := $Visuals/FlatHexagon1
@onready var hex2 := $Visuals/FlatHexagon2
@onready var hex3 := $Visuals/FlatHexagon3
@onready var hex4 := $Visuals/FlatHexagon4
@onready var hex5 := $Visuals/FlatHexagon5
@onready var hex6 := $Visuals/FlatHexagon6
@onready var light := $OmniLight

@onready var ice_sprite := preload("res://enemies/ice_sprite.tscn")
@export var arena_floor_y := 10.0
@export var ice_sprite_spawn_interval := 4.0
var spawn_timer := 0.0

var level : Node3D
var cam : Node3D

var hexes: Array[Node3D]
var hex_timers: Array[float] = []
var hex_axes: Array[Vector3] = []
var hex_speeds: Array[float] = []

func _ready():
	level = root.find_child("Level", true, false)
	
	cam = root.find_child("Camera3D", true, false)
	var t = get_tree().create_tween().set_parallel()
	t.tween_property(visuals, "position", max_height*Vector3.UP, rise_time).as_relative().from(6*Vector3.DOWN)
	t.tween_property(visuals, "scale", max_scale*Vector3.ONE, rise_time).from(min_scale)
	
	# Group hexes and initialize their timing/rotation arrays
	hexes = [hex1, hex2, hex3, hex4, hex5, hex6]
	for i in range(hexes.size()):
		hexes[i].scale = Vector3.ZERO
		# Stagger their start times using negative offsets
		hex_timers.append(-i * hex_interval)
		hex_axes.append(_get_random_axis())
		hex_speeds.append(randf_range(1.5, 3.5))

func _physics_process(delta):
	# Hexagon anim
	for i in range(hexes.size()):
		var timer = hex_timers[i]
		
		# If the hexagon is waiting for its initial staggered start, just advance time
		if timer < 0.0:
			hex_timers[i] += delta
			if hex_timers[i] >= 0.0:
				# It just started its first cycle; roll a fresh rotation
				_reset_hex_rotation(i)
			continue
			
		timer += delta
		
		# Reset cycle if it exceeds cycle_time
		if timer >= cycle_time:
			timer -= cycle_time
			_reset_hex_rotation(i)
			
		hex_timers[i] = timer
		
		# Apply scale using a sine wave (0 -> 1 -> 0)
		var progress = timer / cycle_time
		hexes[i].scale = Vector3.ONE * sin(progress * PI)
		
		# Apply rotation continuously in its chosen direction
		hexes[i].rotate(hex_axes[i], hex_speeds[i] * delta)
	
	# Spawning Logic
	spawn_timer += delta
	if spawn_timer >= ice_sprite_spawn_interval:
		spawn_timer = 0.0
		spawn_ice_sprite()

# Helper function to assign a new randomized rotation trajectory
func _reset_hex_rotation(index: int) -> void:
	hex_axes[index] = _get_random_axis()
	hex_speeds[index] = randf_range(1.2, 3.6) # You can adjust rotation speeds here

# Helper function to grab a random valid 3D vector
func _get_random_axis() -> Vector3:
	var axis = Vector3.ZERO
	while axis.length_squared() < 0.001:
		axis = Vector3(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0), randf_range(-1.0, 1.0))
	return axis.normalized()

func spawn_ice_sprite():
	# Check against the spawn rate (0.167 chance)
	var sprite_instance = ice_sprite.instantiate()
	level.add_child.call_deferred(sprite_instance)
	await sprite_instance.tree_entered
	sprite_instance.global_position = visuals.global_position
