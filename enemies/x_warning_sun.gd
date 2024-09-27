extends Node3D

var rng = RandomNumberGenerator.new()
@export var max_shake_dist := 1.0
var shake_dist := 1.0
@onready var sun_mesh := $SunMesh

func _ready():
	shake_dist = max_shake_dist
	for i in range(60):
		shake_dist = lerpf(max_shake_dist, 0, i / 60.0)
		sun_mesh.position = Vector3(rng.randf_range(-shake_dist, shake_dist), rng.randf_range(-shake_dist, shake_dist), rng.randf_range(-shake_dist, shake_dist))
		await get_tree().create_timer(get_physics_process_delta_time()).timeout
	# queue_free is called by the head piece script
