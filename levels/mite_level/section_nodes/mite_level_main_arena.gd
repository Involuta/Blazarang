extends Node3D

@onready var egg_tier1 := preload("res://enemies/mite_egg_tier1.tscn")
@onready var egg_tier2 := preload("res://enemies/mite_egg_tier2.tscn")
@onready var egg_tier3 := preload("res://enemies/mite_egg_tier3.tscn")
@onready var egg_tier4 := preload("res://enemies/mite_egg_tier4.tscn")
@onready var landmite := preload("res://enemies/landmite.tscn")
@onready var paramite := preload("res://enemies/paramite.tscn")
@onready var flatmite := preload("res://enemies/flatmite.tscn")
@onready var harvestman := preload("res://enemies/harvestman.tscn")

@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var level : Node3D

@onready var arena_infest_hitbox := $MiteCloudPivot/EnemyHitbox
@export var max_time_until_next_infest_switch := 5.0 # Should be less than half the time it takes for debuff to disappear
var time_until_next_infest_switch_secs := 5.0

@export var max_time_until_next_egg := 20.0
var time_until_next_egg := .5
@export var max_living_enemies := 50
var living_enemies := 0

@export var mite_nums := [4, 8, 1, 1] # Number of mites spawned from a Tier [Index+1] egg

@export var real_num_landmites := 40 # How many landmite scenes are loaded into the level
@export var real_num_paramites := 8
@export var real_num_flatmites := 2
@export var real_num_harvestmen := 4
var egg_list
var non_elites_dict = {} # Key is instance name, value is bool of whether its alive or dead
var flatmites_dict = {}
var harvestmen_dict = {}

func _ready():
	time_until_next_infest_switch_secs = max_time_until_next_infest_switch
	#time_until_next_egg = max_time_until_next_egg
	level = root.find_child("Level")
	
	Globals.enemy_killed.connect(set_enemy_to_dead)
	# Instantiate enemies
	for i in range(real_num_landmites):
		var inst = await load_scene_at_pos(landmite, Vector3(i * 5, 20, 0))
		non_elites_dict[inst.name] = false
	for i in range(real_num_paramites):
		var inst = await load_scene_at_pos(paramite, Vector3(i * 5, 30, 0))
		non_elites_dict[inst.name] = false
	for i in range(real_num_flatmites):
		var inst = await load_scene_at_pos(flatmite, Vector3(i * 5, 40, 0))
		flatmites_dict[inst.name] = false
	for i in range(real_num_harvestmen):
		var inst = await load_scene_at_pos(harvestman, Vector3(i * 5, 60, 0))
		harvestmen_dict[inst.name] = false
	
	egg_list = [egg_tier1, egg_tier2, egg_tier3, egg_tier4]

func load_scene_at_pos(scene, pos: Vector3, active: bool = false):
	var inst = scene.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = pos
	inst.set_active(active)
	return inst

func set_enemy_to_dead(enemy_name: String):
	living_enemies -= 1
	if enemy_name in non_elites_dict.keys():
		non_elites_dict[enemy_name] = false
	elif enemy_name in flatmites_dict.keys():
		flatmites_dict[enemy_name] = false
	else:
		harvestmen_dict[enemy_name] = false

func _physics_process(delta):
	time_until_next_infest_switch_secs -= delta
	if time_until_next_infest_switch_secs <= 0:
		time_until_next_infest_switch_secs = max_time_until_next_infest_switch
		if arena_infest_hitbox.process_mode == Node.PROCESS_MODE_DISABLED:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	if living_enemies + mite_nums[1] < max_living_enemies:
		time_until_next_egg -= delta
	if time_until_next_egg <= 0:
		time_until_next_egg = max_time_until_next_egg
		#load_scene_at_pos(egg_list.pick_random(), 100*Vector3.UP, true)
		load_scene_at_pos(egg_tier4, 10*Vector3.UP, true)

func spawn_enemies_from_egg_at(pos: Vector3, egg_tier: int):
	var mite_num = mite_nums[egg_tier-1]
	living_enemies += mite_num
	match egg_tier:
		1, 2:
			spawn_non_elites(pos, mite_num)
		3:
			spawn_flatmite(pos)
		4:
			spawn_harvestman(pos)
		_:
			spawn_non_elites(pos, mite_num)

func spawn_non_elites(pos: Vector3, mite_num: int):
	var mite_jump_dir = pos.direction_to(Vector3.ZERO)
	mite_jump_dir = mite_jump_dir.rotated(Vector3.UP, -PI/4)
	var init_mite_jump_dir = mite_jump_dir
	
	var shuffled_keys = non_elites_dict.keys()
	shuffled_keys.shuffle()
	# Keep track of the index in shuffled_keys so you don't look at the same mites twice (this would happen if you did "for inst_name in shuffled_keys")
	var shuffled_keys_index := 0
	var shuffled_keys_len = shuffled_keys.size()
	
	# Spawn mites so they leap out in a circle, reducing the chance of them pushing against each other
	for i in range(mite_num):
		mite_jump_dir = init_mite_jump_dir.rotated(Vector3.UP, 2*PI/mite_num*i)
		var spawned_mite := false
		# Pick the first dead non-elite you encounter in the shuffled key order
		while shuffled_keys_index < shuffled_keys_len:
			var inst_name = shuffled_keys[shuffled_keys_index]
			shuffled_keys_index += 1
			# Check if enemy is dead, i.e. value is false
			if not non_elites_dict[inst_name]:
				spawned_mite = true
				non_elites_dict[inst_name] = true
				var inst = level.find_child(inst_name, false, false)
				inst.global_position = pos + 4*mite_jump_dir + 4*Vector3.UP
				inst.init_leap_dir = mite_jump_dir
				inst.set_active(true)
				# After spawning a mite, exit this loop so you don't traverse the entire dict and spawn all mites
				break
		if spawned_mite:
			continue
		# If all non-elites are alive (spawned_mite is false), return
		return

func spawn_flatmite(pos: Vector3):
	# Pick the first dead flatmite you find
	for inst_name in flatmites_dict.keys():
		if not flatmites_dict[inst_name]: # Check if enemy is dead, i.e. value is false
			flatmites_dict[inst_name] = true
			var inst = level.find_child(inst_name, false, false)
			inst.global_position = pos
			inst.set_active(true)
			break
	# If all flatmites are alive, do nothing

func spawn_harvestman(pos: Vector3):
	# Pick the first dead harvestman you find
	for inst_name in harvestmen_dict.keys():
		if not harvestmen_dict[inst_name]: # Check if enemy is dead, i.e. value is false
			harvestmen_dict[inst_name] = true
			var inst = level.find_child(inst_name, false, false)
			inst.set_active(true)
			inst.global_position = pos
			break
	# If all harvestmen are alive, do nothing
