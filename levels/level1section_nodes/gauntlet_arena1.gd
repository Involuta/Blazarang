extends Level

var spin_speed := .25

@onready var spawner_spinner := $SpawnerSpinner
@onready var ss1 := $SpawnerSpinner/EnemySpawner1
@onready var ss2 := $SpawnerSpinner/EnemySpawner2
@onready var ss3 := $SpawnerSpinner/EnemySpawner3
@onready var ss4 := $SpawnerSpinner/EnemySpawner4

@onready var ps1 := $PillarSpawners/EnemySpawner1
@onready var ps2 := $PillarSpawners/EnemySpawner2
@onready var ps3 := $PillarSpawners/EnemySpawner3
@onready var ps4 := $PillarSpawners/EnemySpawner4

var sequence_begun := false
var wave_1_duration := 25
var wave_2_duration := 25
var wave_3_duration := 8
var wave_4_duration := 25

func _ready():
	pass

func _physics_process(delta):
	if Input.is_action_just_pressed("Special") and not sequence_begun:
		begin_sequence()
	if sequence_begun:
		spawner_spinner.rotate_y(spin_speed * delta)

func begin_sequence():
	sequence_begun = true
	if (wave_1_duration > 0):
		rnb()
		await get_tree().create_timer(wave_1_duration).timeout
	if (wave_2_duration > 0):
		gang()
		await get_tree().create_timer(wave_2_duration).timeout
	if (wave_3_duration > 0):
		surprise_swarm()
		await get_tree().create_timer(wave_3_duration).timeout
	if (wave_4_duration > 0):
		gang()
		await get_tree().create_timer(wave_4_duration).timeout

func rnb():
	ss1.spawning = true
	ss2.spawning = true
	ss3.spawning = true
	ss4.spawning = true
	ss1.enemy_chances = {
		"MELEE_TIER1": 1,
	}
	ss1.spawn_cooldown_secs = 7
	ss2.enemy_chances = {
		"MELEE_TIER1": .5,
		"MOBILE_GUNNER" : .5
	}
	ss2.spawn_cooldown_secs = 7
	ss3.enemy_chances = {
		"MELEE_TIER1": .8,
		"MOBILE_GUNNER" : .2
	}
	ss3.spawn_cooldown_secs = 7
	ss4.enemy_chances = {
		"MELEE_TIER1": .8,
		"MOBILE_GUNNER" : .2
	}
	ss4.spawn_cooldown_secs = 7

func gang():
	ss1.spawning = true
	ss2.spawning = true
	ss3.spawning = true
	ss4.spawning = false
	ss1.enemy_chances = {
		"MELEE_TIER1": 1,
	}
	ss1.spawn_cooldown_secs = 6
	ss2.enemy_chances = {
		"MELEE_TIER2": 1,
	}
	ss2.spawn_cooldown_secs = 12
	ss3.enemy_chances = {
		"STATIONARY_GUNNER": 1,
	}
	ss3.spawn_cooldown_secs = 7
	
	ps1.spawning = true
	ps2.spawning = true
	ps3.spawning = true
	ps4.spawning = false
	ps1.enemy_chances = {
		"MELEE_TIER1": 1
	}
	ps1.spawn_cooldown_secs = 17
	ps2.enemy_chances = {
		"MELEE_TIER2" : 2,
	}
	ps2.spawn_cooldown_secs = 12
	ps3.enemy_chances = {
		"MELEE_TIER3" : 1
	}
	ps3.spawn_cooldown_secs = 12

func surprise_swarm():
	ss1.spawning = true
	ss2.spawning = true
	ss3.spawning = true
	ss4.spawning = true
	ss1.enemy_chances = {
		"MELEE_TIER1" : 1,
	}
	ss1.spawn_cooldown_secs = 1
	ss2.enemy_chances = {
		"MELEE_TIER1" : 1,
	}
	ss2.spawn_cooldown_secs = 1
	ss3.enemy_chances = {
		"MELEE_TIER1" : 1,
	}
	ss3.spawn_cooldown_secs = 1
	ss4.enemy_chances = {
		"MELEE_TIER1" : .5,
		"MOBILE_GUNNER" : .5
	}
	ss4.spawn_cooldown_secs = 1
	ps1.spawning = false
	ps2.spawning = false
	ps3.spawning = false
	ps4.spawning = false
