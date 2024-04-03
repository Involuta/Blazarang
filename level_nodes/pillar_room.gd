extends Level

var secs_before_difficulty_increase := 25.0

@onready var spawner1 = $EnemySpawner
@onready var spawner2 = $EnemySpawner2
@onready var spawner3 = $EnemySpawner3
@onready var spawner4 = $EnemySpawner4

func _ready():
	increase_difficulty_after_delay()

func increase_difficulty_after_delay():
	await get_tree().create_timer(secs_before_difficulty_increase).timeout
	spawner1.enemy_chances = {
		"MELEE_TIER1": .8,
		"GUNNER" : .2
	}
	spawner2.spawn_cooldown_secs = 7
	spawner3.spawn_cooldown_secs = 7
	spawner4.spawn_cooldown_secs = 7
	
