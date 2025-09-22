extends Node3D

@onready var arena_infest_hitbox := $MiteCloudPivot/EnemyHitbox
var time_btwn_infest_switch_secs := 5.0 # Should be less than half the time it takes for debuff to disappear
var time_to_next_infest_switch_secs := 5.0

@onready var landmite := preload("res://enemies/landmite.tscn")
@onready var paramite := preload("res://enemies/paramite.tscn")
@onready var flatmite := preload("res://enemies/flatmite.tscn")
@onready var harvestman := preload("res://enemies/harvestman.tscn")

@onready var root := $/root/ViewControl
var level : Node3D

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

func spawn_mites_from_egg_at(pos: Vector3, mite_num: int):
	var mite_jump_dir := pos.direction_to(Vector3.ZERO)
	mite_jump_dir = mite_jump_dir.rotated(Vector3.UP, -PI/4)
	
	# Spawn mites so they leap out in an arc
	for i in range(mite_num):
		var lm_inst = landmite.instantiate()
		level.add_child.call_deferred(lm_inst)
		await lm_inst.tree_entered
		lm_inst.global_position = pos
		lm_inst.init_leap_dir = mite_jump_dir
		mite_jump_dir = mite_jump_dir.rotated(Vector3.UP, PI/2/mite_num)
