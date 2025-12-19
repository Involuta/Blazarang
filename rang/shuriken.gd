extends Node3D

enum State {
	ORBIT,
	SPINUP,
	APPROACH,
	SLASH,
	RECALL
}

var state: State = State.ORBIT

@onready var root := $/root/ViewControl
@onready var hitbox := $PlayerHitbox
@onready var mesh := $MeshInstance3D
var level : Node3D
var cotu: Node3D
var icon: Node3D
var target: Node3D

@export var orbit_radius := 1.2
@export var orbit_speed := 4.0
var orbit_angle := 0.0

@export var spinup_duration := 0.4
var spinup_time := 0.0
@export var approach_speed := 40.0

var approach_target_pos := Vector3.ZERO

@export var slash_speed := 18.0
@export var slash_offset_distance := 3.5
var slash_dir := Vector3.ZERO
var slash_t := 0.0

@export var recall_speed := 40.0

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	icon = level.find_child("Icon")
	
	hitbox.damage = Globals.player_hitbox_data.ShurikenBaseDamage

# -------------------------------------------------
# Core loop
# -------------------------------------------------
func _physics_process(delta):
	match state:
		State.ORBIT:
			orbit_frame(delta)
		State.SPINUP:
			spinup_frame(delta)
		State.APPROACH:
			approach_frame(delta)
		State.SLASH:
			slash_frame(delta)
		State.RECALL:
			recall_frame(delta)
	mesh.rotate_y(4 * delta)

# -------------------------------------------------
# ORBIT
# -------------------------------------------------
func orbit_frame(delta):
	orbit_angle += orbit_speed * delta
	global_position = icon.global_position + Vector3(
		cos(orbit_angle),
		0,
		sin(orbit_angle)
	) * orbit_radius

func switch_to_orbit():
	state = State.ORBIT
	target = null

# -------------------------------------------------
# SPINUP
# -------------------------------------------------
func spinup_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	spinup_time += delta
	look_at(target.global_position)

	if spinup_time >= spinup_duration:
		switch_to_approach()

func switch_to_spinup(new_target: Node3D):
	target = new_target
	spinup_time = 0.0
	state = State.SPINUP

# -------------------------------------------------
# APPROACH
# -------------------------------------------------
func approach_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	global_position = global_position.move_toward(
		approach_target_pos,
		approach_speed * delta
	)

	look_at(target.global_position)

	if global_position.distance_to(approach_target_pos) < slash_offset_distance:
		switch_to_slash()

func switch_to_approach():
	# Simple staging point near the target
	approach_target_pos = target.global_position

	state = State.APPROACH

# -------------------------------------------------
# SLASH
# -------------------------------------------------
func slash_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return

	slash_t += delta * slash_speed

	var enemy_pos = target.global_position
	global_position = enemy_pos + slash_dir * sin(slash_t) * slash_offset_distance
	look_at(enemy_pos)

func switch_to_slash():
	if not is_instance_valid(target):
		switch_to_recall()
		return

	slash_dir = (target.global_position - global_position).normalized()

	slash_t = 0.0

	state = State.SLASH

# -------------------------------------------------
# RECALL
# -------------------------------------------------
func recall_frame(delta):
	global_position = global_position.move_toward(
		icon.global_position,
		recall_speed * delta
	)

	if global_position.distance_to(icon.global_position) < 0.3:
		switch_to_orbit()

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# External API
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	switch_to_spinup(new_target)
