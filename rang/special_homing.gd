extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90

var BPM := 113.0
var rotate_speed := 3.6
var max_targets := 12
var homing_speed_multiplier := .15 # must be between 0 (exclusive) and 1 (inclusive)

var invincible := true

@onready var mesh = $boomerang
@onready var hitbox = $PlayerHitbox
@onready var cotu = $/root/Level/cotuCB
@onready var icon = $/root/Level/Icon

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	# $Trail.visible = false
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
	set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, false)
	var all_lockonables = get_tree().get_nodes_in_group("lockonables")
	if not all_lockonables.is_empty():
		all_lockonables.sort_custom(dist_to_lockonable)
		var i := 0
		while i < max_targets and i < all_lockonables.size():
			await homing_attack(all_lockonables[i])
			i += 1
	await homing_attack(icon)
	queue_free()

func dist_to_lockonable(a, b):
	return icon.global_position.distance_to(a.global_position) < icon.global_position.distance_to(b.global_position)

func homing_attack(target):
	if target == null:
		return
	var original_dist_to_target := global_position.distance_to(target.global_position)
	# The line below instantly teleports the rang to enemies but risks quantum superposition bug, making the rang unusable
	var homing_speed := homing_speed_multiplier * original_dist_to_target / get_physics_process_delta_time()
	while target != null and global_position.distance_to(target.global_position) > 1:
		if global_position.distance_to(target.global_position) <= homing_speed * get_physics_process_delta_time():
			velocity = global_position.distance_to(target.global_position) * global_position.direction_to(target.global_position) / get_physics_process_delta_time()
		else:
			velocity = homing_speed * global_position.direction_to(target.global_position)
		move_and_slide()
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

func _physics_process(_delta):
	mesh.rotate_y(rotate_speed)

func get_mvmt_state():
	return "HOMING"
