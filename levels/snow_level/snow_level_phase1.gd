extends Node3D

const JellyfishScene := preload("res://enemies/ice_jellyfish.tscn")
const JellyfishPodScene := preload("res://enemies/ice_jellyfish_pod.tscn")

@export_group("Swarm")
@export var jellyfish_count := 18
@export var dome_center := Vector3(0.0, 10.0, 0.0)
@export var dome_radius := 18.0
@export var dome_height := 13.0
@export var min_jelly_radius := 2.5
@export var min_orbit_speed := 0.25
@export var max_orbit_speed := 0.65
@export var min_vertical_speed := -0.35
@export var max_vertical_speed := 0.35

@export_group("Pod Attack")
@export var pod_spawn_interval := 2.5
@export_range(1, 3) var min_pod_count := 1
@export_range(1, 3) var max_pod_count := 3
@export var pod_formation_radius := 10.0
@export var pod_orbit_speed := 0.2
@export var slot_move_duration := 0.8
@export var slot_move_stagger := 0.12
@export var charge_wait_duration := 1.6
@export var return_move_duration := 1.0

var rng := RandomNumberGenerator.new()
var cotu: Node3D
var jellyfish: Array[Node3D] = []

func _ready():
	var parent_node := get_parent()
	if parent_node != get_tree().root and parent_node.get_script() == get_script():
		return
	rng.randomize()
	cotu = get_tree().root.find_child("cotuCB", true, false)
	if cotu == null:
		return

	spawn_jellyfish()
	start_pod_sequence()

func spawn_jellyfish():
	for index in range(jellyfish_count):
		var jelly := JellyfishScene.instantiate()
		var height_offset := rng.randf_range(1.0, dome_height)
		var height_ratio := height_offset / dome_height
		var radius_limit := dome_radius * sqrt(maxf(0.0, 1.0 - height_ratio * height_ratio))
		var radius := rng.randf_range(min_jelly_radius, maxf(min_jelly_radius, radius_limit))
		var angle := TAU * (float(index) / maxf(1.0, float(jellyfish_count))) + rng.randf_range(-0.2, 0.2)
		var orbit_speed := rng.randf_range(min_orbit_speed, max_orbit_speed)
		var orbit_direction := -1.0 if rng.randf() < 0.5 else 1.0
		var vertical_speed := rng.randf_range(min_vertical_speed, max_vertical_speed)

		add_child(jelly)
		jelly.min_vertical_speed = min_vertical_speed
		jelly.max_vertical_speed = max_vertical_speed
		jelly.configure_orbit(dome_center, radius, height_offset, angle, orbit_speed, orbit_direction, vertical_speed, dome_height)
		jelly.global_position = _dome_position(radius, height_offset, angle)
		jellyfish.append(jelly)

func start_pod_sequence():
	while is_inside_tree():
		await get_tree().create_timer(pod_spawn_interval).timeout
		if not is_inside_tree():
			return
		var requested_count := rng.randi_range(min_pod_count, max_pod_count)
		var pod_plans := find_pod_plans(requested_count)
		for plan in pod_plans:
			run_pod_attack(plan)

func find_pod_plans(requested_count: int) -> Array[Dictionary]:
	var survivors: Array[Node3D] = []
	for jelly in jellyfish:
		if is_instance_valid(jelly) and jelly.is_alive and not jelly.is_in_pod:
			survivors.append(jelly)
	if survivors.size() < 6:
		return []

	for pod_count in range(requested_count, 0, -1):
		var reserved: Array[Node3D] = []
		var plans: Array[Dictionary] = []
		var possible := true
		for _pod_index in range(pod_count):
			var formed := false
			for _attempt in range(80):
				var anchor: Node3D = survivors.pick_random()
				if reserved.has(anchor):
					continue
				var center := anchor.global_position + Vector3(
					rng.randf_range(-pod_formation_radius * 0.2, pod_formation_radius * 0.2),
					rng.randf_range(-1.0, 1.0),
					rng.randf_range(-pod_formation_radius * 0.2, pod_formation_radius * 0.2)
				)
				var nearby: Array[Node3D] = []
				for jelly in survivors:
					if not reserved.has(jelly) and jelly.global_position.distance_to(center) <= pod_formation_radius:
						nearby.append(jelly)
				if nearby.size() < 6:
					continue
				nearby.shuffle()
				var selected: Array[Node3D] = []
				for index in range(6):
					selected.append(nearby[index])
				reserved.append_array(selected)
				plans.append({"center": center, "jellies": selected})
				formed = true
				break
			if not formed:
				possible = false
				break
		if possible:
			return plans
	return []

func run_pod_attack(plan: Dictionary):
	var pod = JellyfishPodScene.instantiate()
	add_child(pod)
	pod.configure(cotu, dome_center, plan.center, pod_orbit_speed)
	var slots: Array[Node3D] = pod.get_slots()
	for index in range(6):
		var jelly: Node3D = plan.jellies[index]
		if is_instance_valid(jelly) and jelly.is_alive:
			jelly.move_into_slot(slots[index], slot_move_duration)
			await get_tree().create_timer(slot_move_stagger).timeout

	await get_tree().create_timer(slot_move_duration).timeout
	for jelly in plan.jellies:
		if is_instance_valid(jelly) and jelly.is_alive:
			jelly.charge_duration = charge_wait_duration
			jelly.charge_and_shoot()
	await get_tree().create_timer(charge_wait_duration + 0.2).timeout

	for jelly in plan.jellies:
		if is_instance_valid(jelly) and jelly.is_alive:
			jelly.return_to_dome(return_move_duration)
	await get_tree().create_timer(return_move_duration + 0.1).timeout
	pod.queue_free()

func _dome_position(radius: float, height_offset: float, angle: float) -> Vector3:
	return dome_center + Vector3(cos(angle) * radius, height_offset, sin(angle) * radius)
