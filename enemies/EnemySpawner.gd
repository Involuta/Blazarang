extends Node3D

@export var section_name := ""
var section

var rng := RandomNumberGenerator.new()
var melee_base := preload("res://enemies/enemy_melee_base.tscn")
var melee_tier1 := preload("res://enemies/enemy_melee_tier1.tscn")
var melee_tier2 := preload("res://enemies/enemy_melee_tier2.tscn")
var melee_tier3 := preload("res://enemies/enemy_melee_tier3.tscn")
var gunner := preload("res://enemies/enemy_gunner_base.tscn")
@export var spawning := true
@export var spawn_cooldown_secs := 7.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"MELEE_TIER1": .66,
	"GUNNER" : .33
}

func _ready():
	# Since sections are instantiated via script, the owned parameter must be false
	section = $/root.find_child(section_name, true, false)

func _physics_process(delta):
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
		"MELEE_BASE":
			return melee_base.instantiate()
		"MELEE_TIER1":
			return melee_tier1.instantiate()
		"MELEE_TIER2":
			return melee_tier2.instantiate()
		"MELEE_TIER3":
			return melee_tier3.instantiate()
		"GUNNER":
			return gunner.instantiate()
		"default":
			print("Error: attempted to spawn unknown enemy")
			return melee_base.instantiate()

func spawn_limit_met():
	return get_tree().get_nodes_in_group("lockonables").size() >= section.lockonable_limit
