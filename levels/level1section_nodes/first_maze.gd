extends Level

var spawning_enemies := false

@export var default_gravity_multiplier = 1.5
@export var gfield_gravity_multiplier = -.5
@onready var trapdoor = $NavigationRegion3D/Trapdoor

func _physics_process(_delta):
	if cotu.global_position.y > trapdoor.global_position.y + 3:
		trapdoor.collision_layer = Globals.ARENA_COL_LAYER

func start_spawning_enemies():
	spawning_enemies = true

func _on_spawner_trigger_body_entered(body):
	if body == cotu:
		start_spawning_enemies()

func _on_gravity_field_body_entered(body):
	if body == cotu:
		cotu.gravity = cotu.default_gravity * gfield_gravity_multiplier

func _on_gravity_field_body_exited(body):
	if body == cotu:
		cotu.gravity = cotu.default_gravity * default_gravity_multiplier
