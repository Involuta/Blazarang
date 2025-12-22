extends Node3D

signal mark_applied(lockonable)
signal mark_removed()

enum State {
	TRAVEL_TO_TARGET,
	LOCKED,
	RECALL
}

var state: State # The current operational state of the mark

@onready var root := $/root/ViewControl
var cotu: Node3D # Reference to the character of the user (or owner of the mark)
var target: Node3D # The enemy currently locked onto by the mark

@export var max_mark_distance := 60.0
@export var aim_cone_dot := 0.8 # The required dot product for the target to be within the camera's aiming cone (~15 degrees). The smaller this num, the bigger the cone
@export var target_mark_offset := 0.5 * Vector3.UP # Offset from target's global pos to get the actual pos mark locks onto (without this, the mark goes to X's dong, which is distracting)
@export var travel_speed := 60.0 # Speed at which the mark travels to the target
@export var recall_speed := 60.0 # Speed at which the mark returns to the owner
@export var los_check_interval := 0.15 # Time between line-of-sight checks in the LOCKED state

var los_timer := 0.0

func _ready():
	# Finds the specific Node3D representing the owner/user ('cotu')
	cotu = root.find_child("cotuCB")

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
	var lockonable := find_best_lockonable_in_cone(cam)
	
	if lockonable == null:
		return false

	# Set the target and transition state upon successful target acquisition
	target = lockonable
	state = State.TRAVEL_TO_TARGET
	global_position = cam.global_position

	emit_signal("mark_applied", target)
	return true

func find_best_lockonable_in_cone(cam: Node3D) -> Node3D:
	var enemies = get_tree().get_nodes_in_group("lockonables")
	var cam_fwd = -cam.global_transform.basis.z
	var cam_pos = cam.global_position

	var best_lockonable = null
	# Changed selection metric: now we track the highest dot product (closest to center)
	var best_dot_product = aim_cone_dot 
	
	for e in enemies:
		var to_lockonable = e.global_position - cam_pos
		var dist = to_lockonable.length()
		if dist > max_mark_distance:
			continue

		var dir = to_lockonable.normalized()
		var current_dot_product = cam_fwd.dot(dir)
		
		# 1. Check if the enemy is within the defined aiming cone
		if current_dot_product < aim_cone_dot:
			continue

		# 2. Check for line-of-sight from the camera to the potential target 'e'
		if not has_los(cam_pos, e.global_position, e):
			continue

		# 3. Selection: Choose the enemy with the HIGHEST dot product.
		# A higher dot product means a smaller angle, meaning the target is closer
		# to the exact center of the screen/camera's look direction.
		if current_dot_product > best_dot_product:
			best_dot_product = current_dot_product
			best_lockonable = e

	return best_lockonable

# -------------------------------------------------
# TRAVEL
# -------------------------------------------------
func travel_frame(delta):
	# If the target is no longer valid, initiate recall
	if not is_instance_valid(target):
		switch_to_recall()
		return
	
	var target_pos = target.global_position + target_mark_offset

	# Move the mark towards the target's position
	global_position = global_position.move_toward(
		target_pos,
		travel_speed * delta
	)

	# Transition to the LOCKED state when close enough
	if global_position.distance_to(target_pos) < 0.2:
		switch_to_locked()

# -------------------------------------------------
# LOCKED
# -------------------------------------------------
func locked_frame(delta):
	# If the target is no longer valid, initiate recall
	if not is_instance_valid(target):
		switch_to_recall()
		return

	# Keep the mark fixed to the target's position
	global_position = target.global_position + target_mark_offset

	los_timer += delta
	# Periodically check distance and line-of-sight from the owner
	if los_timer >= los_check_interval:
		los_timer = 0.0

		if cotu.global_position.distance_to(target.global_position) > max_mark_distance:
			switch_to_recall()
			return

		# Check for line-of-sight from the owner to the current target
		if not has_los(cotu.global_position, target.global_position, target):
			switch_to_recall()

# -------------------------------------------------
# RECALL
# -------------------------------------------------
func recall_frame(delta):
	# Move the mark towards the owner's position
	global_position = global_position.move_toward(
		cotu.global_position,
		recall_speed * delta
	)

	# Remove the mark when it reaches the owner
	if global_position.distance_to(cotu.global_position) < 0.3:
		emit_signal("mark_removed")
		queue_free()

func switch_to_locked():
	state = State.LOCKED

func switch_to_recall():
	# Clear the target reference when recalling the mark
	if is_instance_valid(target):
		target = null
	state = State.RECALL

# -------------------------------------------------
# LOS helper
# -------------------------------------------------
# Performs a raycast from 'from' to 'to' and checks if the line-of-sight is blocked by ARENA collision.
func has_los(from: Vector3, to: Vector3, lockonable: Node3D) -> bool:
	# Immediately return false if the intended target is invalid
	if not is_instance_valid(lockonable):
		return false
		
	var space = get_world_3d().direct_space_state
	
	var q = PhysicsRayQueryParameters3D.create(from, to)
	
	# Only check against ARENA_COL_LAYER
	# This ensures the ray ignores enemies (ENEMY_COL_LAYER and THICK_ENEMY_COL_LAYER)
	# and only reports a hit if a wall or ground is in the way.
	q.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER]) 
	q.collide_with_areas = false
	
	var hit = space.intersect_ray(q)
	
	# Line-of-sight is maintained if:
	# 1. No hit occurred (the path is clear up to the 'to' point)
	# 2. A hit occurred, but the hit distance is greater than the distance to the target (implying the ray hit something behind the target, which shouldn't happen if 'to' is the target's position, but is a robust check).
	
	if not hit:
		# No arena collision found between 'from' and 'to'. LOS is clear.
		return true

	# If we got a hit, it means an ARENA object blocked the path, so LOS is broken.
	# We don't check 'hit.collider == lockonable' anymore because the mask excludes enemies.
	return false
