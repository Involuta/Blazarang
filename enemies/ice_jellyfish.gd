extends Node3D
class_name IceJellyfish

const IceShardScene := preload("res://enemies/ice_fairy_shot.tscn")

@export var charge_duration := 1.6
@export var stun_duration := 1.0
@export var vertical_change_interval_min := 2.0
@export var vertical_change_interval_max := 4.0
var min_vertical_speed := -0.35
var max_vertical_speed := 0.35

var orbit_center := Vector3.ZERO
var level: Node3D
var is_alive := true
var is_charging := false
var charge_interrupted := false
var is_stunned := false
var in_transition := false
var is_in_pod := false
var slot_locked := false
var formation_slot: Node3D

var current_orbit_radius := 8.0
var current_height := 5.0
var current_orbit_speed := 0.4
var orbit_direction := 1.0
var orbit_angle := 0.0
var vertical_speed := 0.0
var vertical_speed_timer := 0.0
var max_dome_height := 13.0

var starting_orbit_radius := 8.0
var starting_height := 5.0
var starting_orbit_speed := 0.4
var starting_orbit_direction := 1.0
var starting_orbit_angle := 0.0
var starting_vertical_speed := 0.0

var transition_tween: Tween
var slot_move_start_position := Vector3.ZERO
var slot_move_start_basis := Basis.IDENTITY
var rng := RandomNumberGenerator.new()
@onready var hurtbox := $EnemyHurtbox

func _ready():
	rng.randomize()
	level = get_tree().root.find_child("Level", true, false)
	hurtbox.hit_received.connect(_on_hurtbox_hit)
	add_to_group("lockonables")

func configure_orbit(center: Vector3, radius: float, height: float, angle: float, speed: float, direction: float, initial_vertical_speed: float, dome_height: float):
	orbit_center = center
	current_orbit_radius = radius
	current_height = height
	orbit_angle = angle
	current_orbit_speed = speed
	orbit_direction = direction
	vertical_speed = initial_vertical_speed
	max_dome_height = dome_height
	starting_orbit_radius = radius
	starting_height = height
	starting_orbit_speed = speed
	starting_orbit_direction = direction
	starting_orbit_angle = angle
	starting_vertical_speed = initial_vertical_speed
	vertical_speed_timer = rng.randf_range(vertical_change_interval_min, vertical_change_interval_max)

func _physics_process(delta: float):
	if not is_alive or is_stunned or in_transition:
		return
	if slot_locked and is_instance_valid(formation_slot):
		global_position = formation_slot.global_position
		global_rotation = (formation_slot.global_transform.basis * Basis(Vector3.UP, PI)).get_euler()
		return
	if formation_slot != null:
		return
	orbit_angle += current_orbit_speed * orbit_direction * delta
	current_height += vertical_speed * delta
	if current_height <= 1.0 or current_height >= max_dome_height:
		current_height = clampf(current_height, 1.0, max_dome_height)
		vertical_speed = -vertical_speed
	vertical_speed_timer -= delta
	if vertical_speed_timer <= 0.0:
		vertical_speed = rng.randf_range(min_vertical_speed, max_vertical_speed)
		vertical_speed_timer = rng.randf_range(vertical_change_interval_min, vertical_change_interval_max)

	var next_position := orbit_center + Vector3(
		cos(orbit_angle) * current_orbit_radius,
		current_height,
		sin(orbit_angle) * current_orbit_radius
	)
	var movement_direction := global_position.direction_to(next_position)
	global_position = next_position
	if movement_direction.length_squared() > 0.001:
		global_rotation.y = PI + atan2(movement_direction.x, movement_direction.z)

func move_into_slot(slot: Node3D, duration: float) -> Tween:
	is_in_pod = true
	formation_slot = slot
	slot_locked = false
	in_transition = true
	slot_move_start_position = global_position
	slot_move_start_basis = global_transform.basis
	if transition_tween and transition_tween.is_running():
		transition_tween.kill()
	transition_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	transition_tween.tween_method(_update_slot_transition.bind(slot), 0.0, 1.0, duration)
	transition_tween.finished.connect(_on_slot_move_finished.bind(slot))
	return transition_tween

func _update_slot_transition(progress: float, slot: Node3D):
	if not is_instance_valid(slot):
		return
	global_position = slot_move_start_position.lerp(slot.global_position, progress)
	var target_basis: Basis = slot.global_transform.basis * Basis(Vector3.UP, PI)
	global_rotation = slot_move_start_basis.slerp(target_basis, progress).get_euler()

func _on_slot_move_finished(slot: Node3D):
	if formation_slot == slot and is_alive:
		in_transition = false
		slot_locked = true

func charge_and_shoot():
	if not is_alive:
		return
	is_charging = true
	charge_interrupted = false
	await get_tree().create_timer(charge_duration).timeout
	if not is_alive or charge_interrupted:
		is_charging = false
		return
	is_charging = false
	await shoot()

func shoot():
	if not is_alive or not is_instance_valid(level):
		return
	var shard := IceShardScene.instantiate()
	level.add_child.call_deferred(shard)
	await shard.tree_entered
	shard.global_position = global_position
	shard.global_transform.basis = global_transform.basis
	shard.velocity = 6.0 * -shard.global_transform.basis.z

func return_to_dome(duration: float):
	if not is_alive:
		return
	formation_slot = null
	slot_locked = false
	in_transition = true
	is_charging = false
	var home_position := orbit_center + Vector3(
		cos(starting_orbit_angle) * starting_orbit_radius,
		starting_height,
		sin(starting_orbit_angle) * starting_orbit_radius
	)
	if transition_tween and transition_tween.is_running():
		transition_tween.kill()
	transition_tween = create_tween().set_parallel(true).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	transition_tween.tween_property(self, "global_position", home_position, duration)
	transition_tween.tween_property(self, "current_orbit_radius", starting_orbit_radius, duration)
	transition_tween.tween_property(self, "current_height", starting_height, duration)
	transition_tween.tween_property(self, "current_orbit_speed", starting_orbit_speed, duration)
	await transition_tween.finished
	if is_alive:
		orbit_direction = starting_orbit_direction
		vertical_speed = starting_vertical_speed
		orbit_angle = starting_orbit_angle
		is_in_pod = false
		in_transition = false

func _on_hurtbox_hit(_damage: int):
	if not is_charging:
		return
	charge_interrupted = true
	is_charging = false
	is_stunned = true
	await get_tree().create_timer(stun_duration).timeout
	if is_alive:
		is_stunned = false

func set_active(state: bool):
	if state:
		return
	is_alive = false
	remove_from_group("lockonables")
	queue_free.call_deferred()
