extends Level

var BPM := 112

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

var pillars := []
var pillar_raised_height := 4
var pillar_floor_height := -5
var pillar_transition_duration := 5
var pillars_raised := true

var sequence_begun := false
var wave_1_duration := 15
var wave_2_duration := 25
var wave_3_duration := 10
var wave_4_duration := 30
var wave_5_duration := 40
var wave_6_duration := 25

func _ready():
	for i in range(4):
		pillars.append(get_node("NavigationRegion3D/Pillar"+str(i+1)))

func _physics_process(delta):
	if Input.is_action_just_pressed("Special") and not sequence_begun:
		begin_sequence()
	if sequence_begun:
		spawner_spinner.rotate_y(spin_speed * delta)

func raise_pillars():
	if not pillars_raised:
		pillars_raised = true
		var tweens := []
		for i in range(4):
			tweens.append(create_tween())
			tweens[i].tween_property(
				pillars[i], 
				"position", 
				Vector3(pillars[i].position.x, pillar_raised_height, pillars[i].position.z), 
				pillar_transition_duration)

func lower_pillars():
	if pillars_raised:
		pillars_raised = false
		var tweens := []
		for i in range(4):
			tweens.append(create_tween())
			tweens[i].tween_property(
				pillars[i], 
				"position", 
				Vector3(pillars[i].position.x, pillar_floor_height, pillars[i].position.z), 
				pillar_transition_duration)

func begin_sequence():
	sequence_begun = true
	if (wave_1_duration > 0):
		miniboss()
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
	if (wave_5_duration > 0):
		miniboss()
		await get_tree().create_timer(wave_5_duration).timeout
	if (wave_6_duration > 0):
		gang()
		await get_tree().create_timer(wave_6_duration).timeout

func rnb():
	raise_pillars()
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
	raise_pillars()
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
	ss3.spawn_cooldown_secs = 9
	
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
		"MELEE_TIER1" : .8,
		"MOBILE_GUNNER" : .2
	}
	ss1.spawn_cooldown_secs = 1
	ss2.enemy_chances = {
		"MELEE_TIER1" : .8,
		"MOBILE_GUNNER" : .2
	}
	ss2.spawn_cooldown_secs = 1
	ss3.enemy_chances = {
		"MELEE_TIER1" : .8,
		"MOBILE_GUNNER" : .2
	}
	ss3.spawn_cooldown_secs = 1
	ss4.enemy_chances = {
		"MELEE_TIER1" : .8,
		"MOBILE_GUNNER" : .2
	}
	ss4.spawn_cooldown_secs = 1
	ps1.spawning = false
	ps2.spawning = false
	ps3.spawning = false
	ps4.spawning = false

func miniboss():
	lower_pillars()
	ss1.spawning = false
	ss2.spawning = false
	ss3.spawning = false
	ss4.spawning = false
	
	ps1.spawning = false
	ps2.spawning = false
	ps3.spawning = false
	ps4.spawning = false
	
	var miniboss_asset := load("res://enemies/first_miniboss.tscn")
	var mb_inst = miniboss_asset.instantiate()
	get_parent().add_child.call_deferred(mb_inst)
	await mb_inst.tree_entered
	mb_inst.global_position = 300*Vector3.UP - 30*Vector3.FORWARD
	var mb_mvmt_tween = get_tree().create_tween()
	mb_mvmt_tween.tween_property(mb_inst, "global_position", 36*Vector3.UP - 30*Vector3.FORWARD, 1)
