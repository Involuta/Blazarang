extends Node3D

@onready var landmite_egg := preload("res://enemies/landmite_egg.tscn")
@onready var paramite_egg := preload("res://enemies/paramite_egg.tscn")
@onready var flatmite_egg := preload("res://enemies/flatmite_egg.tscn")
@onready var harvestman_egg := preload("res://enemies/harvestman_egg.tscn")
@onready var jumping_spider := preload("res://enemies/jumping_spider.tscn")
@onready var web_egg := preload("res://enemies/web_egg.tscn")
@onready var landmite := preload("res://enemies/landmite.tscn")
@onready var paramite := preload("res://enemies/paramite.tscn")
@onready var flatmite := preload("res://enemies/flatmite.tscn")
@onready var harvestman := preload("res://enemies/harvestman.tscn")
@onready var bigweb := preload("res://enemies/bigweb.tscn")
@onready var egg_fog := preload("res://enemies/mite_egg_fog.tscn")

@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var level : Node3D
var target : Node3D

@onready var mite_fog := $MiteFog

@onready var arena_infest_hitbox := $MiteCloudPivot/EnemyHitbox
@export var max_time_until_next_infest_switch := 5.0 # Should be less than half the time it takes for debuff to disappear
var time_until_next_infest_switch_secs := 5.0

@export var max_time_until_next_egg := 20.0
var time_btwn_eggs_this_wave := 4.0
var time_until_next_egg := 10.0

@export var egg_drop_height := 160.0

@export var egg_fog_chance_pre_jumping_spider := .08 # Chance of fog appearing from an egg before spider spawns
@export var egg_fog_chance_post_jumping_spider := .5
var egg_fog_chance := .08 # Current egg fog chance. Changes to post-spider chance when spider spawns

@export var max_living_enemies := 50
var living_enemies := 0
@export var can_drop := true # If this is false, no eggs spawn. Set to false after progressing past final wave listed in egg_waves OR set to false in testing

@export var near_target_drop_max_radius := 12.0 # Radius of egg drop near target

@export var starting_wave := 7 # FOR TESTING ONLY: manually set the first wave when the level starts
var current_wave := 0
var eggs_remaining_this_wave := 4 # Wave increases after this num becomes 0, then this num is set to new wave's egg num
# Waves start counting from 0. Num of eggs spawned per wave = random_int(num-var, num+var). Egg spawned = random choice among "type" keys
@export var egg_waves := [
	{
		"Duration":20.0,
		"Num":16,
		"Var":1,
		"Chances":[1,0,0,0],
	},
	{
		"Duration":20.0,
		"Num":24,
		"Var":2,
		"Chances":[.83,.17,0,0],
	},
	{
		"Duration":8.0,
		"Num":1,
		"Var":0,
		"Chances":[0,0,1,0],
	},
	{
		"Duration":16.0,
		"Num":24,
		"Var":2,
		"Chances":[.83,.17,0,0],
	},
	{
		"Duration":4.0,
		"Num":1,
		"Var":0,
		"Chances":[0,0,0,1],
	},
	{
		"Duration":8.0,
		"Num":16,
		"Var":1,
		"Chances":[.83,.17,0,0],
	},
	{
		"Duration":4.0,
		"Num":1,
		"Var":0,
		"Chances":[0,0,0,1],
	},
	{
		"Duration":24.0,
		"Num":40,
		"Var":1,
		"Chances":[.67,.13,.1,.1],
	},
]

@export var real_num_landmites := 40 # How many landmite scenes are loaded into the level
@export var real_num_paramites := 8
@export var real_num_flatmites := 2
@export var real_num_harvestmen := 4
var egg_list := []
var landmites_dict = {} # For all enemy dicts, key is instance name, value is bool of whether its alive or dead
var paramites_dict = {}
var flatmites_dict = {}
var harvestmen_dict = {}
var enemy_dicts := [landmites_dict, paramites_dict, flatmites_dict, harvestmen_dict] # Dictionaries are passed by reference, not copy. If you need to apply the same code to all dicts, you can iterate through this list

@export var time_btwn_final_enemy_and_eviction := 8.0 # Seconds between the final enemy egg being spawned and the mass eviction
@export var time_btwn_eviction_and_js_spawn := 3.0 # Seconds between start of mass eviction and jumping spider spawning

func _ready():
	time_until_next_infest_switch_secs = max_time_until_next_infest_switch
	level = root.find_child("Level")
	# Egg dropper targets Cotu's body, not icon
	target = root.find_child("cotuCB")
	
	# Set starting wave if applicable
	if starting_wave > 0:
		current_wave = starting_wave
	
	# Set eggs remaining this wave
	var wave_egg_num = egg_waves[current_wave]["Num"]
	var wave_egg_var = egg_waves[current_wave]["Var"]
	eggs_remaining_this_wave = rng.randi_range(wave_egg_num-wave_egg_var, wave_egg_num+wave_egg_var)
	time_btwn_eggs_this_wave = egg_waves[current_wave]["Duration"] / eggs_remaining_this_wave
	time_until_next_egg = time_btwn_eggs_this_wave
	
	Globals.enemy_killed.connect(set_enemy_to_dead)
	# Instantiate enemies
	for i in range(real_num_landmites):
		var inst = await load_scene_at_pos(landmite, Vector3(i * 5, 20, 0))
		landmites_dict[inst.name] = false
	for i in range(real_num_paramites):
		var inst = await load_scene_at_pos(paramite, Vector3(i * 5, 30, 0))
		paramites_dict[inst.name] = false
	for i in range(real_num_flatmites):
		var inst = await load_scene_at_pos(flatmite, Vector3(i * 5, 40, 0))
		flatmites_dict[inst.name] = false
	for i in range(real_num_harvestmen):
		var inst = await load_scene_at_pos(harvestman, Vector3(i * 5, 60, 0))
		harvestmen_dict[inst.name] = false
	
	egg_list = [landmite_egg, paramite_egg, flatmite_egg, harvestman_egg]
	
	egg_fog_chance = egg_fog_chance_pre_jumping_spider
	
	# Make mite fog thicken over time
	var total_duration := 0
	for wave in egg_waves:
		total_duration += wave["Duration"]
	var mite_fog_material = mite_fog.material
	var start_density = mite_fog_material.get_shader_parameter("density")
	var fog_tween := get_tree().create_tween()
	fog_tween.tween_method(
		func(v): mite_fog_material.set_shader_parameter("density", v),
		start_density,
		0.016,
		total_duration
	)

func choose_egg(egg_chances: Array):
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for i in range(egg_chances.size()):
		cumulative_weight += egg_chances[i]
		if choice <= cumulative_weight:
			return egg_list[i]
	return egg_list[0]

func load_scene_at_pos(scene, pos: Vector3, active: bool = false):
	var inst = scene.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = pos
	inst.set_active(active)
	return inst

func set_enemy_to_dead(enemy_name: String):
	living_enemies -= 1
	for dict in enemy_dicts:
		if enemy_name in dict.keys():
			dict[enemy_name] = false

func _physics_process(delta):
	time_until_next_infest_switch_secs -= delta
	if time_until_next_infest_switch_secs <= 0:
		time_until_next_infest_switch_secs = max_time_until_next_infest_switch
		if arena_infest_hitbox.process_mode == Node.PROCESS_MODE_DISABLED:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	
	# If you can no longer drop eggs, don't tick down the egg timer or reset it
	if not can_drop:
		return
	if living_enemies < max_living_enemies:
		time_until_next_egg -= delta
	if time_until_next_egg <= 0:
		time_until_next_egg = time_btwn_eggs_this_wave
		drop_egg()

func drop_egg_of_type(egg_type: int):
	# Get random pt around target
	var drop_pos = near_target_drop_max_radius * Vector3.FORWARD.rotated(Vector3.UP, rng.randf_range(0, 2*PI)) + egg_drop_height * Vector3.UP + target.global_position # This adds target's y pos to the drop pos, but since it's so high up, who cares
	match egg_type:
		1:
			load_scene_at_pos(landmite_egg, drop_pos, true)
		2:
			load_scene_at_pos(paramite_egg, drop_pos, true)
		3:
			load_scene_at_pos(flatmite_egg, drop_pos, true)
		4:
			load_scene_at_pos(harvestman_egg, drop_pos, true)
		5:
			load_scene_at_pos(web_egg, drop_pos, true)
		_:
			# Web egg is default bc this func is used by jumping spider to spawn specifically web eggs. Any type can be inputted in this func just in case it's used in the future
			load_scene_at_pos(web_egg, drop_pos, true)

# Drop an egg and progress to the next wave if the last egg of the current wave was dropped
func drop_egg():
	# Get random pt around target
	var drop_dist := rng.randf_range(0, near_target_drop_max_radius)
	var drop_pos = drop_dist * Vector3.FORWARD.rotated(Vector3.UP, rng.randf_range(0, 2*PI)) + egg_drop_height * Vector3.UP + target.global_position # This adds target's y pos to the drop pos, but since it's so high up, who cares
	var egg_chances = egg_waves[current_wave]["Chances"]
	load_scene_at_pos(choose_egg(egg_chances), drop_pos, true)
	eggs_remaining_this_wave -= 1
	print("Eggs remaining: ", eggs_remaining_this_wave)
	if eggs_remaining_this_wave <= 0:
		# Progress to next wave and set eggs remaining this wave and time btwn eggs this wave
		current_wave += 1
		# If there are no more waves left, start jumping spider wave
		if current_wave >= len(egg_waves):
			start_jumping_spider_wave()
			return
		print("Current wave: ", current_wave)
		var wave_egg_num = egg_waves[current_wave]["Num"]
		var wave_egg_var = egg_waves[current_wave]["Var"]
		eggs_remaining_this_wave = rng.randi_range(wave_egg_num-wave_egg_var, wave_egg_num+wave_egg_var)
		time_btwn_eggs_this_wave = egg_waves[current_wave]["Duration"] / eggs_remaining_this_wave
		print("Set eggs remaining to: ", eggs_remaining_this_wave)

func spawn_enemy_from_egg_at(pos: Vector3, egg_type: int):
	living_enemies += 1
	match egg_type:
		1:
			spawn_enemy_from_dict(pos, landmites_dict)
		2:
			spawn_enemy_from_dict(pos, paramites_dict)
		3:
			spawn_enemy_from_dict(pos, flatmites_dict)
		4:
			spawn_enemy_from_dict(pos, harvestmen_dict)
		5:
			# There is no bigweb dict
			load_scene_at_pos(bigweb, pos, true)
		_:
			spawn_enemy_from_dict(pos, landmites_dict)
	# Low chance to also spawn fog from an egg
	if rng.randf() < egg_fog_chance:
		load_scene_at_pos(egg_fog, pos, true)

func spawn_enemy_from_dict(pos: Vector3, dict: Dictionary):
	# Pick the first dead enemy you find
	for inst_name in dict.keys():
		if not dict[inst_name]: # Check if enemy is dead, i.e. value is false
			dict[inst_name] = true
			var inst = level.find_child(inst_name, false, false)
			inst.global_position = pos
			inst.set_active(true)
			break
	# If all enemies are alive, do nothing

func start_jumping_spider_wave():
	# Stop dropping eggs
	can_drop = false
	# Wait for final egg of the last wave to hit the ground AND let that final enemy and the remaining enemies attack for a bit
	await get_tree().create_timer(time_btwn_final_enemy_and_eviction).timeout
	# Evict enemies
	evict_enemies()
	# Wait for most enemies to leave
	await get_tree().create_timer(time_btwn_eviction_and_js_spawn).timeout
	# Spawn jumping spider
	load_scene_at_pos(jumping_spider, Vector3(0, 10, 40), true)
	# Change egg fog chance
	egg_fog_chance = egg_fog_chance_post_jumping_spider
	
# Call funcs in enemies so they leave
func evict_enemies():
	for dict in enemy_dicts:
		for inst_name in dict.keys():
			if dict[inst_name]: # Check if enemy is alive, i.e. value is true
				var inst = level.find_child(inst_name, false, false)
				inst.evict()
