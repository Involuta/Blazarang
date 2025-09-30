extends Node3D

@onready var egg_tier1 := preload("res://enemies/mite_egg_tier1.tscn")
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
var time_until_next_egg := 1.0
@export var max_living_enemies := 50
var living_enemies := 0

@export var mite_num_tier1 := 20 # Number of mites spawned from a Tier 1 egg
@export var paramite_chance_tier1 := .2 # Probability that a mite spawned from a Tier 1 egg is a paramite instead of a landmite

@export var real_num_landmites := 40 # How many landmite scenes are loaded into the level
@export var real_num_paramites := 8
@export var real_num_flatmites := 2
@export var real_num_harvestmen := 4
var non_elites_dict = {} # Key is instance name, value is bool of whether its alive or dead
var elites_dict = {}

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
		var inst = await load_scene_at_pos(landmite, Vector3(i * 5, 30, 0))
		non_elites_dict[inst.name] = false
	for i in range(real_num_flatmites):
		var inst = await load_scene_at_pos(landmite, Vector3(i * 5, 40, 0))
		elites_dict[inst.name] = false
	for i in range(real_num_harvestmen):
		var inst = await load_scene_at_pos(landmite, Vector3(i * 5, 60, 0))
		elites_dict[inst.name] = false

func load_scene_at_pos(scene, pos: Vector3, active : bool = false):
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
	else:
		elites_dict[enemy_name] = false

func _physics_process(delta):
	time_until_next_infest_switch_secs -= delta
	if time_until_next_infest_switch_secs <= 0:
		time_until_next_infest_switch_secs = max_time_until_next_infest_switch
		if arena_infest_hitbox.process_mode == Node.PROCESS_MODE_DISABLED:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	if living_enemies + mite_num_tier1 < max_living_enemies:
		time_until_next_egg -= delta
	if time_until_next_egg <= 0:
		time_until_next_egg = max_time_until_next_egg
		load_scene_at_pos(egg_tier1, 100*Vector3.UP, true)

func spawn_mites_from_egg_at(pos: Vector3, egg_tier: int):
	var mite_num : int
	match(egg_tier):
		1:
			mite_num = mite_num_tier1
		_:
			mite_num = mite_num_tier1
	
	living_enemies += mite_num
	
	var mite_jump_dir := pos.direction_to(Vector3.ZERO)
	mite_jump_dir = mite_jump_dir.rotated(Vector3.UP, -PI/4)
	var init_mite_jump_dir = mite_jump_dir
	
	# Spawn mites so they leap out in a circle, reducing the chance of them pushing against each other
	for i in range(mite_num):
		mite_jump_dir = init_mite_jump_dir.rotated(Vector3.UP, 2*PI/mite_num*i)
		# Pick a random dead non-elite
		var dead_non_elites = []
		for non_elite in non_elites_dict.keys():
			if not non_elites_dict[non_elite]: # Check if non-elite is dead, i.e. value is false
				dead_non_elites.append(non_elite)
		# If all non-elites are alive, return
		if dead_non_elites.is_empty():
			return
		var inst_name = dead_non_elites.pick_random()
		non_elites_dict[inst_name] = true
		var inst = level.find_child(inst_name, false, false)
		inst.global_position = pos + 4*mite_jump_dir + 4*Vector3.UP
		inst.init_leap_dir = mite_jump_dir
		inst.set_active(true)
