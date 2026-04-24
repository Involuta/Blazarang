extends Level

@onready var ice_sprite := preload("res://enemies/ice_sprite.tscn")

@export var arena_floor_y := 10.0
@export var ice_sprite_spawn_rate := .167
@export var ice_sprite_spawn_min_dist := 60.0
@export var ice_sprite_spawn_max_dist := 120.0

var ui_root : Control
var frostbite_bar : Control
var frostbite_bar_damage_indicator : Control
var cotu_hurtbox : Node3D
var clarity : Node3D
@onready var blizzard_particles := $BlizzardParticles

# Timer to track the 1-second interval
var spawn_timer := 0.0

func _ready():
	super()
	ui_root = root.find_child("UIRoot", true, false)
	frostbite_bar = ui_root.find_child("FrostbiteBar")
	frostbite_bar_damage_indicator = frostbite_bar.find_child("DamageIndicator")
	frostbite_bar_damage_indicator.value = 100
	cotu_hurtbox = cotu.find_child("Hurtbox")
	clarity = root.find_child("Clarity", true, false)
	ui_root.hide_black_screen()

func _physics_process(delta):
	# Update UI
	frostbite_bar.max_value = cotu_hurtbox.current_frostbite_threshold
	frostbite_bar.value = cotu_hurtbox.frostbite_buildup
	blizzard_particles.global_position = cotu.global_position + 15*Vector3.UP + cotu.get_camera_fwd_dir_lateral()
	
	# Spawning Logic
	spawn_timer += delta
	if spawn_timer >= 1.0:
		spawn_timer = 0.0 # Reset timer every second
		_try_spawn_ice_sprite()

func _try_spawn_ice_sprite():
	# Check against the spawn rate (0.167 chance)
	if randf() <= ice_sprite_spawn_rate:
		# Calculate random position within a circle around Clarity
		var random_radius = randf_range(ice_sprite_spawn_min_dist, ice_sprite_spawn_max_dist)
		var random_angle = randf() * TAU # TAU is 2*PI
		
		var spawn_pos = Vector3(
			clarity.global_position.x + random_radius * cos(random_angle),
			arena_floor_y + 1,
			clarity.global_position.z + random_radius * sin(random_angle)
		)
		
		var sprite_instance = ice_sprite.instantiate()
		add_child.call_deferred(sprite_instance)
		await sprite_instance.tree_entered
		sprite_instance.global_position = spawn_pos
