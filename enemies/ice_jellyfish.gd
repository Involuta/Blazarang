extends Node3D
class_name IceJellyfish

enum {
	ORBIT,
	ORBIT_TO_SLOT,
	SLOT,
	SWEEP,
	SLOT_TO_ORBIT
}
var behav_state := ORBIT

signal staggered_during_charge

const IceShardScene := preload("res://enemies/ice_fairy_shot.tscn")

@export var stun_duration := 1.0
@export var orbit_arm_spin_speed := 1.5
@export var orbit_arm_flap_speed := 0.8
@export var orbit_arm_open_angle := 0.2
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
var is_staggering := false
var pod_exit_duration := 0.8
var is_in_pod := false
var formation_slot: Node3D
var returning_to_orbit := false
var return_elapsed := 0.0
var return_duration := 1.0
var return_start_position := Vector3.ZERO
var return_start_radius := 0.0
var return_start_height := 0.0
var return_start_speed := 0.0
var return_start_vertical_speed := 0.0
var return_start_basis := Basis.IDENTITY

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
var orbit_arm_rest_transforms: Array[Transform3D] = []
var orbit_arm_spin_angle := 0.0
var orbit_arm_flap_phase := 0.0
var rng := RandomNumberGenerator.new()
@onready var hurtbox := $EnemyHurtbox
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cap_mesh: MeshInstance3D = $IceFairyVisuals/PitchPivot/YawPivot/Cap
@onready var ice_chunk_particles: GPUParticles3D = $IceChunkParticles
@onready var orbit_arm_meshes: Array[MeshInstance3D] = [
	$IceFairyVisuals/PitchPivot/YawPivot/Spike0,
	$IceFairyVisuals/PitchPivot/YawPivot/Spike1,
	$IceFairyVisuals/PitchPivot/YawPivot/Spike2,
	$IceFairyVisuals/PitchPivot/YawPivot/Spike3,
	$IceFairyVisuals/PitchPivot/YawPivot/Spike4,
	$IceFairyVisuals/PitchPivot/YawPivot/Spike5,
]

func _ready():
	rng.randomize()
	level = get_tree().root.find_child("Level", true, false)
	hurtbox.hit_received.connect(_on_hurtbox_hit)
	add_to_group("lockonables")
	for arm_mesh in orbit_arm_meshes:
		orbit_arm_rest_transforms.append(arm_mesh.transform)
	var visual_meshes: Array[MeshInstance3D] = [cap_mesh]
	visual_meshes.append_array(orbit_arm_meshes)

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
	if not is_alive or is_stunned:
		return
	match(behav_state):
		ORBIT:
			_process_orbit(delta)
		ORBIT_TO_SLOT:
			# Transition from orbit to slot uses tween, not process func
			pass
		SLOT:
			if is_instance_valid(formation_slot):
				global_position = formation_slot.global_position
				global_rotation = (formation_slot.global_transform.basis * Basis(Vector3.UP, PI)).get_euler()
		SWEEP:
			_process_sweep(delta)
		SLOT_TO_ORBIT:
			_process_return_to_orbit(delta)

func _process_orbit(delta):
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
		global_rotation = Vector3(0.0, PI + atan2(movement_direction.x, movement_direction.z), 0.0)
	_animate_orbit_arms(delta)

func _animate_orbit_arms(delta: float):
	orbit_arm_spin_angle = fposmod(orbit_arm_spin_angle + orbit_arm_spin_speed * delta, TAU)
	orbit_arm_flap_phase = fposmod(orbit_arm_flap_phase + orbit_arm_flap_speed * delta, TAU)
	var open_angle := sin(orbit_arm_flap_phase) * orbit_arm_open_angle
	var collective_rotation := Basis(Vector3.UP, orbit_arm_spin_angle)
	for index in range(orbit_arm_meshes.size()):
		var arm_mesh := orbit_arm_meshes[index]
		var rest_transform := orbit_arm_rest_transforms[index]
		var radial_direction := Vector3(rest_transform.origin.x, 0.0, rest_transform.origin.z).normalized()
		var hinge_axis := Vector3.UP.cross(radial_direction).normalized()
		var hinge_rotation := Basis(hinge_axis, open_angle)
		arm_mesh.position = collective_rotation * rest_transform.origin
		arm_mesh.transform.basis = collective_rotation * hinge_rotation * rest_transform.basis

func move_into_slot(slot: Node3D, duration: float) -> Tween:
	is_in_pod = true
	formation_slot = slot
	behav_state = ORBIT_TO_SLOT
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
		behav_state = SLOT

func charge_and_shoot():
	if not is_alive:
		return
	is_charging = true
	charge_interrupted = false
	animation_player.play("shoot")
	await animation_player.animation_finished
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
	shard.look_at(shard.global_position + global_transform.basis.z, Vector3.UP)
	shard.velocity = 6.0 * -shard.global_transform.basis.z

func return_to_dome(duration: float):
	if not is_alive or returning_to_orbit:
		return
	if transition_tween and transition_tween.is_running():
		transition_tween.kill()
	behav_state = SLOT_TO_ORBIT
	formation_slot = null
	is_charging = false
	returning_to_orbit = true
	return_elapsed = 0.0
	return_duration = maxf(duration, 0.001)
	return_start_position = global_position
	return_start_radius = current_orbit_radius
	return_start_height = current_height
	return_start_speed = current_orbit_speed
	return_start_vertical_speed = vertical_speed
	return_start_basis = global_transform.basis
	orbit_angle = starting_orbit_angle
	orbit_direction = starting_orbit_direction

func _process_return_to_orbit(delta: float):
	return_elapsed = minf(return_elapsed + delta, return_duration)
	var progress := pow(return_elapsed / return_duration, 1.05)
	var blend := progress * progress * progress * (progress * (progress * 6.0 - 15.0) + 10.0)
	current_orbit_radius = lerpf(return_start_radius, starting_orbit_radius, blend)
	current_orbit_speed = lerpf(return_start_speed, starting_orbit_speed, blend)
	vertical_speed = lerpf(return_start_vertical_speed, starting_vertical_speed, blend)
	var return_height := return_start_height + return_start_vertical_speed * return_elapsed
	var orbit_height := starting_height + starting_vertical_speed * return_elapsed
	current_height = lerpf(return_height, orbit_height, blend)
	orbit_angle += current_orbit_speed * orbit_direction * delta
	var orbit_position := orbit_center + Vector3(
		cos(orbit_angle) * current_orbit_radius,
		current_height,
		sin(orbit_angle) * current_orbit_radius
	)
	global_position = return_start_position.lerp(orbit_position, blend)
	var orbit_direction_vector := Vector3(-sin(orbit_angle), 0.0, cos(orbit_angle)) * orbit_direction
	var orbit_yaw := PI + atan2(orbit_direction_vector.x, orbit_direction_vector.z)
	var orbit_basis := Basis(Vector3.UP, orbit_yaw)
	global_transform.basis = return_start_basis.slerp(orbit_basis, blend)

	if return_elapsed >= return_duration:
		current_orbit_radius = starting_orbit_radius
		current_height = orbit_height
		current_orbit_speed = starting_orbit_speed
		vertical_speed = starting_vertical_speed
		global_rotation = Vector3(0.0, orbit_yaw, 0.0)
		is_in_pod = false
		returning_to_orbit = false

func sweep():
	pass

func _process_sweep(delta):
	pass

func _on_hurtbox_hit(_damage: int):
	if not is_charging or is_staggering:
		return
	charge_interrupted = true
	is_charging = false
	is_stunned = true
	is_staggering = true
	staggered_during_charge.emit()
	animation_player.play("stagger")
	await animation_player.animation_finished
	if is_alive:
		is_staggering = false
		is_stunned = false
		return_to_dome(pod_exit_duration)

func death_effect():
	if not is_instance_valid(level):
		return
	var particles: GPUParticles3D = ice_chunk_particles.duplicate()
	level.add_child(particles)
	particles.global_transform = ice_chunk_particles.global_transform
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime).timeout
	if is_instance_valid(particles):
		particles.queue_free()

func set_active(state: bool):
	if state:
		return
	is_alive = false
	remove_from_group("lockonables")
	queue_free.call_deferred()

