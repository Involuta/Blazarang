extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90

var BPM := 113.0
var rotate_speed := 3.6
var max_targets := 1
var max_target_proximity := 30.0 # Farthest dist lockonable can be from rang (when it's spawned in) for it to be targeted; should be same or similar to rose's max radius
var homing_speed_multiplier := .125 # must be between 0 (exclusive) and 1 (inclusive)

var invincible := true

@onready var mesh = $RoserangMesh
@onready var hitbox = $PlayerHitbox
@onready var root := $/root/ViewControl
var cotu : Node3D
var icon : Node3D

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	cotu = root.find_child("cotuCB")
	icon = root.find_child("Icon")
	
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
	set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, false)
	var all_lockonables = get_tree().get_nodes_in_group("lockonables")
	all_lockonables = all_lockonables.filter(within_proximity)
	if not all_lockonables.is_empty():
		all_lockonables.sort_custom(dist_to_lockonable)
		var i := 0
		while i < max_targets and i < all_lockonables.size():
			await homing_attack(all_lockonables[i])
			i += 1
	invincible = false # Allow rang to be deleted when it touches Cotu
	await homing_return()
	queue_free()

func within_proximity(lockonable):
	return icon.global_position.distance_to(lockonable.global_position) < max_target_proximity

func dist_to_lockonable(a, b):
	return icon.global_position.distance_to(a.global_position) < icon.global_position.distance_to(b.global_position)

func homing_attack(target):
	if target == null:
		return
	var original_dist_to_target := global_position.distance_to(target.global_position)
	var homing_speed := homing_speed_multiplier * original_dist_to_target / get_physics_process_delta_time()
	while target != null and global_position.distance_to(target.global_position) > 1:
		velocity = homing_speed * global_position.direction_to(target.global_position)
		move_and_slide()
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

func homing_return():
	# No matter what the distance is, the rang should return to the icon in .4 seconds
	while global_position.distance_to(icon.global_position) > 1:
		# .04175 * 
		velocity = (icon.global_position - global_position) / get_physics_process_delta_time()
		move_and_slide()
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

func _physics_process(_delta):
	mesh.rotate_y(rotate_speed)

func buff_damage():
	hitbox.damage = 30

func buff_homing_targets(targets_added: int):
	# Why aren't we doing current_max_targets = base_max_targets + targets_added to prevent accumulation? There is no risk of accumulation between buffing cycles because the script is reloaded after every instant rethrow
	max_targets += targets_added

func get_mvmt_state():
	return "HOMING"
