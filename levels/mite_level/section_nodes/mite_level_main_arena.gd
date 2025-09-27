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
var time_until_next_egg := 20.0
@export var max_living_enemies := 50
var living_enemies := 0

@export var mite_num_tier1 := 20 # Number of mites spawned from a Tier 1 egg
@export var paramite_chance_tier1 := .2 # Probability that a mite spawned from a Tier 1 egg is a paramite instead of a landmite

func _ready():
	time_until_next_infest_switch_secs = max_time_until_next_infest_switch
	level = root.find_child("Level")
	
	Globals.enemy_killed.connect(decrement_living_enemies)

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
		spawn_egg()

func spawn_egg():
	var egg_inst = egg_tier1.instantiate()
	level.add_child.call_deferred(egg_inst)
	await egg_inst.tree_entered
	egg_inst.global_position = 100 * Vector3.UP

func decrement_living_enemies(_enemy_name):
	# enemy_name is a parameter of the enemy_killed signal, but isn't used in this func
	living_enemies -= 1

func spawn_mites_from_egg_at(pos: Vector3, egg_tier: int):
	var paramite_chance : float
	var mite_num : int
	match(egg_tier):
		1:
			mite_num = mite_num_tier1
			paramite_chance = paramite_chance_tier1
		_:
			mite_num = mite_num_tier1
			paramite_chance = paramite_chance_tier1
	
	living_enemies += mite_num
	
	var mite_jump_dir := pos.direction_to(Vector3.ZERO)
	mite_jump_dir = mite_jump_dir.rotated(Vector3.UP, -PI/4)
	var init_mite_jump_dir = mite_jump_dir
	
	# Spawn mites so they leap out in an arc
	for i in range(mite_num):
		mite_jump_dir = init_mite_jump_dir.rotated(Vector3.UP, PI/2/mite_num*i)
		
		var mite_inst
		var is_paramite := false
		if rng.randf() > paramite_chance:
			mite_inst = landmite.instantiate()
		else:
			is_paramite = true
			mite_inst = paramite.instantiate()
		level.add_child.call_deferred(mite_inst)
		await mite_inst.tree_entered
		mite_inst.global_position = pos + mite_jump_dir
		mite_inst.init_leap_dir = mite_jump_dir
		
		if is_paramite:
			mite_inst.global_position += Vector3.UP
