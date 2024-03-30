extends Level

var platform_speed := 1.0
var spin_speed := .25
var sequence_begun := false
var secs_before_sweeper1_spawns_min := 5.0
var secs_before_sweeper1_spawns_max := 15.0
var secs_before_sweeper2_spawns_min := 5.0
var secs_before_sweeper2_spawns_max := 10.0
const SECS_BEFORE_TIER2_SPAWNS := 15.0
const SECS_BEFORE_TIER3_SPAWNS := 30.0
const TIER1_SPAWNS := {
	"MELEE_TIER1": 1
}
const TIER2_SPAWNS := {
	"MELEE_TIER1": .75,
	"MELEE_TIER2": .25
}
const TIER3_SPAWNS := {
	"MELEE_TIER1": .5,
	"MELEE_TIER2": .33,
	"MELEE_TIER3": .167
}
const SWEEPER_SPEED = 20.0
var platform_radius
var rng := RandomNumberGenerator.new()
@onready var sweeper = preload("res://enemies/sweeper.tscn")
@onready var platform = $Platform
@onready var spawner_spinner = $Platform/SpawnerSpinner
@onready var target = $/root/Arena/Target
@onready var spawners = spawner_spinner.get_children()

func _ready():
	platform_radius = $Platform/CollisionShape3D.shape.radius
	for spawner in spawners:
		spawner.enemy_chances = TIER1_SPAWNS
	start_spawning_sweeper_after_delay()
	start_spawning_tier2_after_delay()
	start_spawning_tier3_after_delay()

func _physics_process(delta):
	if Input.is_action_just_pressed("Special") and not sequence_begun:
		sequence_begun = true
	if sequence_begun:
		platform.linear_velocity = platform_speed * Vector3.UP
		spawner_spinner.rotate_y(spin_speed * delta)

func start_spawning_sweeper_after_delay():
	var secs_before_sweeper1_spawns := rng.randf_range(secs_before_sweeper1_spawns_min, secs_before_sweeper1_spawns_max)
	await get_tree().create_timer(secs_before_sweeper1_spawns).timeout
	spawn_sweeper()
	
	var secs_before_sweeper2_spawns := rng.randf_range(secs_before_sweeper2_spawns_min, secs_before_sweeper2_spawns_max)
	await get_tree().create_timer(secs_before_sweeper2_spawns).timeout
	spawn_sweeper()

func spawn_sweeper():
	var sweep_inst = sweeper.instantiate()
	add_child.call_deferred(sweep_inst)
	await sweep_inst.tree_entered
	var sweep_angle = -cotu.look_angle - PI/2
	var sweep_vec2 := Vector2.from_angle(sweep_angle)
	var sweep_vec3 := Vector3(sweep_vec2.x, 0, sweep_vec2.y)
	sweep_inst.global_position = cotu.global_position + 2*platform_speed*Vector3.UP + 2*platform_radius*sweep_vec3
	sweep_inst.velocity = -SWEEPER_SPEED * sweep_vec3 + platform_speed*Vector3.UP
	#sweep_inst.rotation.y = sweep_angle
	sweep_inst.look_at(sweep_inst.global_position + sweep_vec3)
	sweep_inst.global_rotation.x = 0
	sweep_inst.global_rotation.z = 0

func start_spawning_tier2_after_delay():
	await get_tree().create_timer(SECS_BEFORE_TIER2_SPAWNS).timeout
	for spawner in spawners:
		spawner.enemy_chances = TIER2_SPAWNS

func start_spawning_tier3_after_delay():
	await get_tree().create_timer(SECS_BEFORE_TIER3_SPAWNS).timeout
	for spawner in spawners:
		spawner.enemy_chances = TIER3_SPAWNS
