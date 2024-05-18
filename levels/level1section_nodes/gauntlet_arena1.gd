extends Level

var secs_before_difficulty_increase := 25.0
var spin_speed := .25

var sequence_begun := false

@onready var spawner_spinner := $SpawnerSpinner
@onready var spawner1 := $SpawnerSpinner/EnemySpawner1
@onready var spawner2 := $SpawnerSpinner/EnemySpawner2
@onready var spawner3 := $SpawnerSpinner/EnemySpawner3
@onready var spawner4 := $SpawnerSpinner/EnemySpawner4

func _ready():
	increase_difficulty_after_delay()

func increase_difficulty_after_delay():
	await get_tree().create_timer(secs_before_difficulty_increase).timeout
	spawner1.enemy_chances = {
		"MELEE_TIER1": .8,
		"GUNNER" : .2
	}
	spawner1.spawn_cooldown_secs = 5
	spawner2.spawn_cooldown_secs = 7
	spawner3.spawn_cooldown_secs = 6
	spawner4.spawn_cooldown_secs = 7

func begin_sequence():
	sequence_begun = true
	spawner1.spawning = true
	spawner2.spawning = true
	spawner3.spawning = true
	spawner4.spawning = true

func _physics_process(delta):
	if Input.is_action_just_pressed("Special") and not sequence_begun:
		begin_sequence()
	if sequence_begun:
		spawner_spinner.rotate_y(spin_speed * delta)
