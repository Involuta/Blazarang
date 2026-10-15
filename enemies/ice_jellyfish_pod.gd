extends Node3D

var target: Node3D
var orbit_origin := Vector3.ZERO
var orbit_radius := 0.0
var orbit_speed := 0.2
var orbit_phase := 0.0
var orbit_direction := 1.0
var orbit_height := 0.0

func configure(look_target: Node3D, dome_center: Vector3, start_position: Vector3, drift_speed: float):
	target = look_target
	orbit_origin = dome_center
	var offset := start_position - dome_center
	orbit_radius = Vector2(offset.x, offset.z).length()
	orbit_speed = drift_speed
	orbit_phase = atan2(offset.z, offset.x)
	orbit_direction = -1.0 if randf() < 0.5 else 1.0
	orbit_height = start_position.y
	global_position = start_position

func _process(delta: float):
	orbit_phase += orbit_speed * orbit_direction * delta
	global_position = Vector3(
		orbit_origin.x + cos(orbit_phase) * orbit_radius,
		orbit_height,
		orbit_origin.z + sin(orbit_phase) * orbit_radius
	)
	if is_instance_valid(target) and global_position.distance_squared_to(target.global_position) > 0.001:
		look_at(target.global_position, Vector3.UP)

func get_slots() -> Array[Node3D]:
	return [get_node("Slot1"), get_node("Slot2"), get_node("Slot3"), get_node("Slot4"), get_node("Slot5"), get_node("Slot6")]
