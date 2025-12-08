extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90

var BPM := 113.0
var rotate_speed := 3.6
var base_max_targets := 11
var current_max_targets := 11 # No max proximity exists; any lockonable in the entire level can be targeted
var homing_time := .12 # Time it takes for rang to move from 1 target to another

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
	if not all_lockonables.is_empty():
		all_lockonables.sort_custom(dist_to_lockonable)
		var i := 0
		while i < current_max_targets and i < all_lockonables.size():
			await homing_attack(all_lockonables[i])
			i += 1
	invincible = false # Allow rang to be deleted when it touches Cotu
	await homing_attack(icon)

func dist_to_lockonable(a, b):
	return icon.global_position.distance_to(a.global_position) < icon.global_position.distance_to(b.global_position)

func homing_attack(target):
	if not target.is_in_group("lockonables") or not target or not is_instance_valid(target):
		return
	
	# No matter what the distance is, the rang should return to the icon in .4 seconds
	# Get original vector from icon to rang
	var original_vec = global_position - target.global_position
	# Progress = value btwn 0 and 1 where 0 is beginning of path and 1 is end
	# At every frame, set rang's position to icon's position + icon_to_rang vec - (progress * icon_to_rang_vec)
	# Progress reaches 1 at .4 seconds = .4 / delta = n frames
	var n = int(homing_time/get_physics_process_delta_time())
	# 1 is added to n bc the rang won't reach if the dist btwn icon and the target increases during the rang mvmt
	for i in range(n+1):
		if target == null:
			return
		var progress = float(i)/n
		var progress_vec = ((1 - progress) * original_vec)
		global_position = target.global_position + progress_vec
		await get_tree().create_timer(get_physics_process_delta_time()).timeout

func _physics_process(_delta):
	mesh.rotate_y(rotate_speed)

func buff_damage():
	hitbox.damage = Globals.player_hitbox_data.RoserangDamageBuff1

func buff_homing_targets(targets_added: int):
	# Why aren't we doing max_targets += targets_added? When the script is reloaded after every instant rethrow, variable values retain changes from previous scripts
	current_max_targets = base_max_targets + targets_added

func get_mvmt_state():
	return "HOMING"
