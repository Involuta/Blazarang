extends Node3D

signal charge_window_finished

var target: Node3D
var orbit_origin := Vector3.ZERO
var orbit_radius := 0.0
var orbit_speed := 0.2
var orbit_phase := 0.0
var orbit_direction := 1.0
var orbit_height := 0.0
var member_count := 0
var staggered_member_count := 0
var charge_window_ended_early := false
var charge_timer: Timer

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

func register_members(members: Array):
	member_count = members.size()
	for jelly in members:
		jelly.staggered_during_charge.connect(_on_member_staggered)

func wait_for_charge_window(duration: float):
	charge_window_ended_early = false
	if member_count > 0 and staggered_member_count >= member_count:
		return true
	charge_timer = Timer.new()
	charge_timer.one_shot = true
	add_child(charge_timer)
	charge_timer.timeout.connect(_on_charge_timer_timeout)
	charge_timer.start(duration)
	await charge_window_finished
	var ended_early := charge_window_ended_early
	charge_timer.queue_free()
	charge_timer = null
	return ended_early

func _on_member_staggered():
	staggered_member_count += 1
	if staggered_member_count < member_count:
		return
	if is_instance_valid(charge_timer) and not charge_timer.is_stopped():
		charge_window_ended_early = true
		charge_timer.stop()
		charge_window_finished.emit()

func _on_charge_timer_timeout():
	charge_window_ended_early = false
	charge_window_finished.emit()

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
