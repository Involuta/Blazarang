extends Level

var spawning_enemies := false

@onready var spawner1 = $EnemySpawner
@onready var spawner2 = $EnemySpawner2

func start_spawning_enemies():
	spawning_enemies = true
	spawner1.spawning = true
	spawner2.spawning = true

func _on_spawner_trigger_body_entered(_body):
	start_spawning_enemies()
