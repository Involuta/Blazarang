class_name IceSpriteSpawner
extends Node3D

@export var max_brightness := 12.0
@export var min_brightness := 6.0
@export var appear_dim_time := 12.0
@export var max_height := 18.0
@export var rise_time := 120.0
@export var min_scale := 1.0
@export var max_scale := 6.0

# Hexagon vars
@export var hex_count := 6
@export var cycle_time := 3.6
@export var hex_rotate_speed := 1.8

@onready var root := get_tree().root
@onready var visuals := $Visuals
@onready var visuals_scalable := $Visuals/Scalable
@onready var ico := $Visuals/Scalable/Icosahedron
@onready var light := $OmniLight

@onready var hexagon_mesh := preload("res://enemies/flat_hexagon.tscn")
@onready var ice_sprite := preload("res://enemies/ice_sprite.tscn")
@export var arena_floor_y := 10.0
@export var ice_sprite_spawn_interval := 4.0
var spawn_timer := 0.0

var level : Node3D
var cam : Node3D

var hexes: Array[Node3D] = []
var hex_timers: Array[float] = []

func _ready():
	level = root.find_child("Level", true, false)
	cam = root.find_child("Camera3D", true, false)

	var t = get_tree().create_tween().set_parallel()
	t.tween_property(visuals, "position", max_height * Vector3.UP, rise_time).as_relative().from(6 * Vector3.DOWN)
	t.tween_property(visuals_scalable, "scale", max_scale * Vector3.ONE, rise_time).from(min_scale)

	# Instantiate hexes and distribute their starting phase evenly
	for i in range(hex_count):
		var hex = hexagon_mesh.instantiate() as Node3D
		visuals_scalable.add_child.call_deferred(hex)
		await hex.tree_entered
		hexes.append(hex)
		# Set a random initial rotation across all axes
		hex.rotation = Vector3(
			randf_range(0.0, TAU),
			randf_range(0.0, TAU),
			randf_range(0.0, TAU)
		)

		# Evenly distribute start phase so all hexes begin at different points in their cycle
		var start_progress = float(i) / float(hex_count)
		hex_timers.append(start_progress * cycle_time)

func _physics_process(delta):
	# Hexagon anim
	for i in range(hexes.size()):
		hex_timers[i] += delta

		# Reset cycle if it exceeds cycle_time
		if hex_timers[i] >= cycle_time:
			hex_timers[i] = fmod(hex_timers[i], cycle_time)

		# Scale using sine wave
		var progress = hex_timers[i] / cycle_time
		var scale_factor = sin(progress * PI)

		#if scale_factor < .9:
			#scale_factor = 0
		hexes[i].scale = Vector3.ONE * scale_factor

		# Rotate around its local X axis
		hexes[i].rotate_object_local(Vector3.RIGHT, hex_rotate_speed * delta)
	
	# Rotate ico
	ico.rotate_x(hex_rotate_speed * delta)
	ico.rotate_y(hex_rotate_speed * delta)
	
	# Spawning Logic
	spawn_timer += delta
	if spawn_timer >= ice_sprite_spawn_interval:
		spawn_timer = 0.0
		spawn_ice_sprite()

func spawn_ice_sprite():
	# Check against the spawn rate (0.167 chance)
	var sprite_instance = ice_sprite.instantiate()
	level.add_child.call_deferred(sprite_instance)
	await sprite_instance.tree_entered
	sprite_instance.global_position = visuals.global_position
