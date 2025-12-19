extends Node3D

signal mark_applied(enemy)
signal mark_removed()

enum State {
	TRAVEL_TO_TARGET,
	LOCKED,
	RECALL
}

var state: State

var cotu: Node3D
var target: Node3D

@export var max_mark_distance := 20.0
@export var aim_cone_dot := 0.96 # ~15 degrees
@export var travel_speed := 25.0
@export var recall_speed := 30.0
@export var los_check_interval := 0.15

var los_timer := 0.0

# -------------------------------------------------
# Core loop
# -------------------------------------------------
func _physics_process(delta):
	match state:
		State.TRAVEL_TO_TARGET:
			travel_frame(delta)
		State.LOCKED:
			locked_frame(delta)
		State.RECALL:
			recall_frame(delta)

# -------------------------------------------------
# Placement
# -------------------------------------------------
func try_place_from_camera(cam: Node3D) -> bool:
	var enemy := find_best_enemy_in_cone(cam)
	if enemy == null:
		return false

	target = enemy
	state = State.TRAVEL_TO_TARGET
	global_position = cam.global_position

	emit_signal("mark_applied", target)
	return true

func find_best_enemy_in_cone(cam: Node3D) -> Node3D:
	var enemies = get_tree().get_nodes_in_group("lockonables")
	var cam_fwd = -cam.global_transform.basis.z
	var cam_pos = cam.global_position

	var best_enemy = null
	var best_dist = INF

	for e in enemies:
		var to_enemy = e.global_position - cam_pos
		var dist = to_enemy.length()
		if dist > max_mark_distance:
			continue

		var dir = to_enemy.normalized()
		if cam_fwd.dot(dir) < aim_cone_dot:
			continue

		if not has_los(cam_pos, e.global_position):
			continue

		if dist < best_dist:
			best_dist = dist
			best_enemy = e

	return best_enemy

# -------------------------------------------------
# TRAVEL
# -------------------------------------------------
func travel_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	global_position = global_position.move_toward(
		target.global_position,
		travel_speed * delta
	)

	if global_position.distance_to(target.global_position) < 0.2:
		switch_to_locked()

# -------------------------------------------------
# LOCKED
# -------------------------------------------------
func locked_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	global_position = target.global_position

	los_timer += delta
	if los_timer >= los_check_interval:
		los_timer = 0.0

		if owner.global_position.distance_to(target.global_position) > max_mark_distance:
			switch_to_recall()
			return

		if not has_los(owner.global_position, target.global_position):
			switch_to_recall()

# -------------------------------------------------
# RECALL
# -------------------------------------------------
func recall_frame(delta):
	global_position = global_position.move_toward(
		owner.global_position,
		recall_speed * delta
	)

	if global_position.distance_to(owner.global_position) < 0.3:
		emit_signal("mark_removed")
		queue_free()

func switch_to_locked():
	state = State.LOCKED

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# LOS helper
# -------------------------------------------------
func has_los(from: Vector3, to: Vector3) -> bool:
	var space = get_world_3d().direct_space_state
	var q = PhysicsRayQueryParameters3D.create(from, to)
	var hit = space.intersect_ray(q)
	return hit and hit.collider == target
