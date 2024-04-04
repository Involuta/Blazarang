extends Level

const MAZE_FLOOR_Z_POS = 20.0

var spawning_enemies := false

@onready var spawner1 = $EnemySpawner
@onready var spawner2 = $EnemySpawner2

func _ready():
	return

func _physics_process(delta):
	if not spawning_enemies and cotu.global_position.y < MAZE_FLOOR_Z_POS:
		start_spawning_enemies()

func start_spawning_enemies():
	spawning_enemies = true
	spawner1.spawning = true
	spawner2.spawning = true
