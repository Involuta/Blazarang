extends Node3D

@onready var arena_infest_hitbox := $MiteCloudPivot/EnemyHitbox
var time_btwn_infest_switch_secs := 5.0 # Should be less than half the time it takes for debuff to disappear
var time_to_next_infest_switch_secs := 5.0

@onready var landmite := preload("res://enemies/landmite.tscn")
@onready var paramite := preload("res://enemies/paramite.tscn")
@onready var flatmite := preload("res://enemies/flatmite.tscn")
@onready var harvestman := preload("res://enemies/harvestman.tscn")

@onready var root := $/root/ViewControl
var rng := RandomNumberGenerator.new()
var level : Node3D

@export var mite_num_tier1 := 20 # Number of mites spawned from a Tier 1 egg
@export var paramite_chance_tier1 := .2 # Probability that a mite spawned from a Tier 1 egg is a paramite instead of a landmite

func _ready():
	time_to_next_infest_switch_secs = time_btwn_infest_switch_secs
	level = root.find_child("Level")

func _physics_process(delta):
	time_to_next_infest_switch_secs -= delta
	if time_to_next_infest_switch_secs <= 0:
		time_to_next_infest_switch_secs = time_btwn_infest_switch_secs
		if arena_infest_hitbox.process_mode == Node.PROCESS_MODE_DISABLED:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_DISABLED

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
