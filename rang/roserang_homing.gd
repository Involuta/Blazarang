extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90

var BPM := 113.0
var rotate_speed := 3.6
var base_max_targets := 1
var current_max_targets := 1
var max_target_proximity := 30.0 # Farthest dist lockonable can be from rang (when it's spawned in) for it to be targeted; should be same or similar to rose's max radius
var target_homing_time := .12 # Time it takes for rang to move from 1 target to another
var icon_homing_time := .4 # Time it takes for rang to return to icon after hitting all targets

var aim_cone_dot := 0.75 # The required dot product for a lockonable to be within the camera's aiming cone (~15 degrees). The smaller this num, the bigger the cone

# PMD = pre-multiplier damage
var damage_multiplier := 1.0 # Each hitbox's damage is pre multiplier damage * damage_multiplier
var hitbox_pmd := 0.0

var invincible := true

@onready var mesh = $RoserangMesh
@onready var hitbox = $PlayerHitbox
@onready var trail = $Trail
@onready var base_particle_gradient = $RoserangParticlesBase/GPUParticles3D.process_material.color_ramp.gradient
@onready var rang_glow_shader = $RoserangMesh/Boomerang3DModelV1.get_surface_override_material(0)
@onready var root := get_tree().root
var cotu : Node3D
var icon : Node3D
var cam : Camera3D

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	cotu = root.find_child("cotuCB", true, false)
	icon = root.find_child("Icon", true, false)
	cam = get_viewport().get_camera_3d()
	
	current_max_targets = base_max_targets
	
	hitbox_pmd = Globals.player_hitbox_data.RoserangBaseDamage
	update_hitbox_damage()
	
	trail.color_ramp.gradient.colors[1] = Color.DEEP_SKY_BLUE
	base_particle_gradient.set_color(1, Color.DEEP_SKY_BLUE)
	rang_glow_shader.set_shader_parameter("ColorParameter", Color.DEEP_SKY_BLUE)
	
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
	set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, false)
	var all_lockonables = get_tree().get_nodes_in_group("lockonables")
	all_lockonables = all_lockonables.filter(targetable_and_within_proximity)
	if not all_lockonables.is_empty():
		all_lockonables.sort_custom(lockonable_dist_to_aim_cone_center)
		var i := 0
		while i < current_max_targets and i < all_lockonables.size():
			await homing_attack(all_lockonables[i], false)
			i += 1
		invincible = false # Allow rang to be deleted when it touches Cotu
		await homing_attack(icon, true)
	# THIS IS A PLACEHOLDER: ROSE MAY NOT ALWAYS DELETE ITSELF IMMEDIATELY UPON TOUCHING ICON AT END OF HOMING IN THE FUTURE
	queue_free()

func targetable_and_within_proximity(lockonable):
	var not_targetable = not is_instance_valid(lockonable) or lockonable.process_mode == Node.PROCESS_MODE_DISABLED
	if lockonable.get_parent() != null:
		not_targetable = not_targetable or lockonable.get_parent().process_mode == Node.PROCESS_MODE_DISABLED
	var within_proximity := icon.global_position.distance_to(lockonable.global_position) < max_target_proximity
	return not not_targetable and within_proximity and within_aim_cone(lockonable)

# Checks if 'lockonable' falls within the camera's aiming cone, same logic as mark.gd's cone check
func within_aim_cone(lockonable) -> bool:
	if cam == null:
		return true # No camera to reference (e.g. headless/test run); don't filter anything out

	var cam_fwd = -cam.global_transform.basis.z
	var to_lockonable = cam.global_position.direction_to(lockonable.global_position)

	return cam_fwd.dot(to_lockonable) >= aim_cone_dot

func lockonable_dist_to_aim_cone_center(a, b):
	# a comes before b --> a is closer to aim cone center than b --> a has larger dot product than b
	var cam_fwd = -cam.global_transform.basis.z
	var to_a = cam.global_position.direction_to(a.global_position)
	var to_b = cam.global_position.direction_to(b.global_position)

	return cam_fwd.dot(to_a) > cam_fwd.dot(to_b)

func homing_attack(target, to_icon: bool):
	var homing_time := target_homing_time
	if to_icon:
		homing_time = icon_homing_time
	
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

func _physics_process(_delta):
	mesh.rotate_y(rotate_speed)

func buff_damage():
	hitbox_pmd = Globals.player_hitbox_data.RoserangDamageBuff1
	update_hitbox_damage()

func update_hitbox_damage():
	# If damage is boosted by 25%, damage_multiplier is 1.25
	hitbox.damage = hitbox_pmd * damage_multiplier

func apply_damage_multiplier(mult: float):
	# Multipliers accumulate multiplicatively
	damage_multiplier *= 1 + mult
	update_hitbox_damage()

func set_homing_targets(targets_added: int):
	# Why aren't we doing max_targets += targets_added? When the script is reloaded after every instant rethrow, variable values retain changes from previous scripts
	current_max_targets = base_max_targets + targets_added

func get_mvmt_state():
	return "HOMING"
