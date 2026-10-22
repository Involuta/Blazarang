extends Node3D

signal sweep_window_finished

var target: Node3D
var sweep_dir := Vector3.ZERO
var member_count := 0
var staggered_member_count := 0
var sweep_window_ended_early := false
var sweep_timer: Timer

func configure(look_target: Node3D, dome_center: Vector3, start_position: Vector3, height: float):
	target = look_target
	var dome_center_at_sweep_height := dome_center
	dome_center_at_sweep_height.y = height
	global_position = start_position
	global_position.y = height
	sweep_dir = global_position.direction_to(dome_center_at_sweep_height)
	look_at(dome_center_at_sweep_height)

func register_members(members: Array):
	member_count = members.size()
	for jelly in members:
		jelly.staggered_during_charge.connect(_on_member_staggered)

func run_sweep_window(duration: float):
	sweep_window_ended_early = false
	sweep_timer = Timer.new()
	sweep_timer.one_shot = true
	add_child(sweep_timer)
	sweep_timer.timeout.connect(_on_sweep_timer_timeout)
	sweep_timer.start(duration)
	await sweep_window_finished
	var ended_early := sweep_window_ended_early
	sweep_timer.queue_free()
	sweep_timer = null
	return ended_early

func _on_member_staggered():
	staggered_member_count += 1
	if staggered_member_count < member_count:
		return
	if is_instance_valid(sweep_timer) and not sweep_timer.is_stopped():
		sweep_window_ended_early = true
		sweep_timer.stop()
		sweep_window_finished.emit()

func _on_sweep_timer_timeout():
	sweep_window_ended_early = false
	sweep_window_finished.emit()

func get_slots() -> Array[Node3D]:
	return [get_node("Slot1"), get_node("Slot2"), get_node("Slot3")]
