class_name IceSpriteSpawner
extends Node3D

signal spawner_max_height_reached
var max_height_reached := false

@export var max_brightness := 12.0
@export var min_brightness := 6.0
@export var appear_dim_time := 12.0
@export var max_height := 100.0
@export var min_scale := 3.0
@export var max_scale := 6.0
@export var rise_speed_base := .3
var rise_speed := rise_speed_base
@export var rise_speed_boosted := 3.0

# Hexagon vars
@export var hex_count := 6
@export var cycle_time := 3.6
@export var hex_rotate_speed_base := 1.8
var hex_rotate_speed := hex_rotate_speed_base
@export var hex_rotate_speed_boosted := 4.8

# Other visuals vars
@export var light_energy_base := 1.0
@export var light_energy_boosted := 3.0
@export var glow_sprite_scale_base := 1.5
@export var glow_sprite_scale_boosted := 3.0

# Albedo visual vars
@export var ico_albedo_base: Color = Color(0.5, 0.75, 1.0) # Normal color state
@export var ico_albedo_boosted: Color = Color(1.0, 1.3, 3.6) # Bright/HDR boosted color state
@export var hex_albedo_base: Color = Color(0.5, 0.75, 1.0)
@export var hex_albedo_boosted: Color = Color(1.0, 1.3, 3.6)

@export var boost_decay_time := 1.5
var rise_speed_boost_decay_rate = (rise_speed_boosted - rise_speed_base) / boost_decay_time

@onready var root := get_tree().root
@onready var visuals := $Visuals
@onready var visuals_scalable := $Visuals/Scalable
@onready var ico := $Visuals/Scalable/Icosahedron
@onready var ico_mesh: MeshInstance3D = $Visuals/Scalable/Icosahedron/Cube
@onready var light := $Visuals/OmniLight
@onready var glow_sprite := $Visuals/Scalable/GlowSprite
@onready var anim_player := $AnimationPlayer

@onready var hexagon_mesh := preload("res://glb_inherited_scenes/ice_sprite_spawner_flat_hexagon.tscn")
@onready var ice_sprite := preload("res://enemies/ice_sprite.tscn")
@onready var ice_fairy := preload("res://enemies/ice_fairy.tscn")
@export var arena_floor_y := 10.0
@export var ice_sprite_spawn_interval := 6.0
var spawn_timer := 0.0

var level : Node3D
var cam : Node3D

var hexes: Array[Node3D] = []
var hex_timers: Array[float] = []

var ico_material: StandardMaterial3D
var hex_material: StandardMaterial3D

func _ready():
	level = root.find_child("Level", true, false)
	cam = root.find_child("Camera3D", true, false)
	
	ico_material = ico_mesh.get_surface_override_material(0)

	# Instantiate hexes and distribute their starting phase evenly
	for i in range(hex_count):
		var hex = hexagon_mesh.instantiate() as Node3D
		visuals_scalable.add_child.call_deferred(hex)
		await hex.tree_entered
		hexes.append(hex)

		# Store the shared material reference from the first instantiated hexagon
		if not hex_material:
			var mesh_instance := hex.find_child("*", true, false) as MeshInstance3D
			if mesh_instance:
				hex_material = mesh_instance.get_surface_override_material(0) as StandardMaterial3D

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
	# Rise mvmt
	if visuals.position.y < max_height:
		visuals.position.y += rise_speed * delta
		if visuals.position.y >= max_height:
			spawner_max_height_reached.emit()
			max_height_reached = true
		
		# While rising, set scale of visuals scalable based on local height ascent (0 to max_height)
		var clamped_y: float = clampf(visuals.position.y, 0.0, max_height)
		var current_scale: float = remap(clamped_y, 0.0, max_height, min_scale, max_scale)
		visuals_scalable.scale = Vector3.ONE * current_scale
	
	# Hexagon anim
	for i in range(hexes.size()):
		hex_timers[i] += delta

		# Reset cycle if it exceeds cycle_time
		if hex_timers[i] >= cycle_time:
			hex_timers[i] = fmod(hex_timers[i], cycle_time)

		# Scale using sine wave
		var progress = hex_timers[i] / cycle_time
		var scale_factor = sin(progress * PI)

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
	
	# Reduce rise speed to base level
	if rise_speed > rise_speed_base:
		rise_speed -= rise_speed_boost_decay_rate * delta
		rise_speed = maxf(rise_speed, rise_speed_base) # Clamp to avoid undershooting base speed
	
	# Remap rise speed to calculate other speeds & visuals
	hex_rotate_speed = remap(rise_speed, rise_speed_base, rise_speed_boosted, hex_rotate_speed_base, hex_rotate_speed_boosted)
	light.light_energy = remap(rise_speed, rise_speed_base, rise_speed_boosted, light_energy_base, light_energy_boosted)
	
	var lerp_val: float = remap(rise_speed, rise_speed_base, rise_speed_boosted, 0.0, 1.0)
	
	if ico_material:
		ico_material.albedo_color = ico_albedo_base.lerp(ico_albedo_boosted, lerp_val)

	if hex_material:
		hex_material.albedo_color = hex_albedo_base.lerp(hex_albedo_boosted, lerp_val)

func spawn_ice_sprite():
	var sprite_instance
	if max_height_reached:
		sprite_instance = ice_fairy.instantiate()
	else:
		sprite_instance = ice_fairy.instantiate()
	level.add_child.call_deferred(sprite_instance)
	await sprite_instance.tree_entered
	sprite_instance.global_position = visuals.global_position

func boost():
	# All other boosted properties are based on rise_speed
	rise_speed = rise_speed_boosted

func explode():
	anim_player.play("explode")
	var t = create_tween().set_parallel()
	t.tween_property(visuals_scalable, "scale", Vector3.ONE * max_scale * 1.6, 1.0).set_ease(Tween.EASE_OUT)
	t.tween_property(self, "rise_speed", rise_speed_base * .4, 1.0).set_ease(Tween.EASE_OUT)
	t.tween_property(light, "light_energy", 0, 1.0).set_ease(Tween.EASE_OUT)
