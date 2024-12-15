extends Node3D

@export var section_name := ""
var section

var rng := RandomNumberGenerator.new()
var melee_base := preload("res://enemies/enemy_melee_base.tscn")
var melee_tier1 := preload("res://enemies/enemy_melee_tier1.tscn")
var melee_tier2 := preload("res://enemies/enemy_melee_tier2.tscn")
var melee_tier3 := preload("res://enemies/enemy_melee_tier3.tscn")
var mobile_gunner := preload("res://enemies/enemy_mobile_gunner.tscn")
var stationary_gunner := preload("res://enemies/enemy_stationary_gunner.tscn")

@export var spawning := true
@export var spawn_cooldown_secs := 7.0
var spawn_cooldown_active := false
@export var enemy_chances = {
	"MELEE_TIER1": .66,
	"MOBILE_GUNNER" : .33
}

@onready var top_spinner := $TopSpinner
@onready var middle_spinner := $MiddleSpinner
@onready var bottom_spinner := $BottomSpinner

func _ready():
	# Since sections are instantiated via script, the owned parameter must be false
	section = $/root.find_child(section_name, true, false)

func _physics_process(_delta):
	if self and not spawn_cooldown_active and spawning and not spawn_limit_met():
		spawn_enemy()
	rotate_y(.25 * get_physics_process_delta_time())

func spawn_enemy():
	var spinner_tween = get_tree().create_tween()
	spinner_tween.set_parallel()
	spinner_tween.tween_property(middle_spinner, "rotation", Vector3.UP * PI, .5).from(Vector3.ZERO)
	spinner_tween.tween_property(bottom_spinner, "rotation", Vector3.UP * -PI, .5).from(Vector3.ZERO)
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
		"MOBILE_GUNNER":
			return mobile_gunner.instantiate()
		"STATIONARY_GUNNER":
			return stationary_gunner.instantiate()
		"default":
			print("Error: attempted to spawn unknown enemy")
			return melee_tier1.instantiate()

func spawn_limit_met():
	if section:
		return get_tree().get_nodes_in_group("lockonables").size() >= section.lockonable_limit
	else:
		return true
