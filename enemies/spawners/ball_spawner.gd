extends Node3D

@export var section_name = "BallsLevelMainArena"
var section : Node3D
var rng := RandomNumberGenerator.new()
var roller := preload("res://enemies/roller_ball.tscn")

@export var spawning := true
@export var spawn_cooldown_secs := 3.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"ROLLER": 1
}

func _ready():
	# Since sections are instantiated via script, the owned parameter must be false
	section = $/root.find_child(section_name, true, false)

func _physics_process(_delta):
	if self and not spawn_cooldown_active and spawning and not spawn_limit_met():
		spawn_enemy()

func spawn_enemy():
	spawn_cooldown_active = true
	var enemy_inst = choose_enemy()
	section.add_child.call_deferred(enemy_inst)
	await enemy_inst.tree_entered
	enemy_inst.global_position = global_position
	await get_tree().create_timer(spawn_cooldown_secs).timeout
	spawn_cooldown_active = false

func choose_enemy():
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for enemy in enemy_chances:
		cumulative_weight += enemy_chances[enemy]
		if choice <= cumulative_weight:
			return spawn_from_name(enemy)
	return spawn_from_name("default")
	
func spawn_from_name(enemy_name):
	match(enemy_name):
		"ROLLER":
			return roller.instantiate()
		"default":
			print("Error: attempted to spawn unknown enemy")
			return roller.instantiate()

func spawn_limit_met():
	if section:
		return get_tree().get_nodes_in_group("lockonables").size() >= section.lockonable_limit
	else:
		return true
