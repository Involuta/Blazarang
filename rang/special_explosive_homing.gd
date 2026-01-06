extends CharacterBody3D

var explosion := preload("res://rang/roserang_explosion.tscn")

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90

var BPM := 113.0
var rotate_speed := 3.6
var base_max_targets := 11
var current_max_targets := 11 # No max proximity exists; any lockonable in the entire level can be targeted
var target_homing_time := .12 # Time it takes for rang to move from 1 target to another
var icon_homing_time := .4 # Time it takes for rang to return to icon after hitting all targets

var invincible := true

@onready var mesh = $RoserangMesh
@onready var hitbox = $PlayerHitbox
@onready var trail = $Trail
@onready var base_particle_gradient = $RoserangParticlesBase/GPUParticles3D.process_material.color_ramp.gradient
@onready var rang_glow_shader = $RoserangMesh/Boomerang3DModelV1.get_surface_override_material(0)
@onready var root := $/root/ViewControl
var cotu : Node3D
var icon : Node3D
var level : Node3D

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	cotu = root.find_child("cotuCB")
	icon = root.find_child("Icon")
	level = root.find_child("Level")
	
	trail.color_ramp.gradient.colors[1] = Color.DEEP_SKY_BLUE
	base_particle_gradient.set_color(1, Color.DEEP_SKY_BLUE)
	rang_glow_shader.set_shader_parameter("ColorParameter", Color.DEEP_SKY_BLUE)
	
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
	set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, false)
	var all_lockonables = get_tree().get_nodes_in_group("lockonables")
	if not all_lockonables.is_empty():
		all_lockonables.sort_custom(dist_to_lockonable)
		var i := 0
		while i < current_max_targets and i < all_lockonables.size():
			await homing_attack(all_lockonables[i], false)
			spawn_explosion()
			i += 1
	invincible = false # Allow rang to be deleted when it touches Cotu
	await homing_attack(icon, true)
	# PLACEHOLDER: ROSE MAY NOT ALWAYS DELETE ITSELF IMMEDIATELY UPON TOUCHING ICON AT END OF HOMING IN THE FUTURE
	queue_free()

func dist_to_lockonable(a, b):
	return icon.global_position.distance_to(a.global_position) < icon.global_position.distance_to(b.global_position)

func homing_attack(target, to_icon: bool):
	var homing_time := target_homing_time
	if to_icon:
		homing_time = icon_homing_time
	elif not target.is_in_group("lockonables") or not target or not is_instance_valid(target) or target.process_mode == Node.PROCESS_MODE_DISABLED:
		return
	
	# Get original vector from target to current pos
	var original_vec = global_position - target.global_position
	# Imagine a vec pointing from the target to rang's current pos; this vec decreases in size every frame, eventually leading the rang to the target
	# Progress = value btwn 0 and 1 where 0 is beginning of path and 1 is end
	# At every frame, set rang's position to target_pos + ((1-progress) * target_to_current_pos vec)
	# Progress reaches 1 at homing_time seconds = homing_time/delta frames = n frames
	var n = int(homing_time/get_physics_process_delta_time())
	# 1 is added to n bc the rang won't reach if the dist btwn icon and the target increases during the rang mvmt
	for i in range(n+1):
		if target == null:
			return
		var progress = float(i)/n
		var progress_vec = ((1 - progress) * original_vec)
		global_position = target.global_position + progress_vec
		await get_tree().physics_frame

func spawn_explosion():
	var inst = explosion.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = global_position

func _physics_process(_delta):
	mesh.rotate_y(rotate_speed)

func buff_damage():
	hitbox.damage = Globals.player_hitbox_data.RoserangDamageBuff1

func buff_homing_targets(targets_added: int):
	# Why aren't we doing max_targets += targets_added? When the script is reloaded after every instant rethrow, variable values retain changes from previous scripts
	current_max_targets = base_max_targets + targets_added

func get_mvmt_state():
	return "HOMING"
