extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90

var BPM := 113.0
var max_targets := 5

var invincible := true

@onready var cotu = $/root/Level/cotuCB
@onready var icon = $/root/Level/Icon
@onready var hitbox = $PlayerHitbox

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
	$PlayerHitbox.damage *= 1.5
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
	var homing_time := 0.0
	while (homing_time < .5) and target != null:
		global_position = global_position.lerp(target.global_position, .5)
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
		homing_time += get_physics_process_delta_time()

func get_mvmt_state():
	return "HOMING"
