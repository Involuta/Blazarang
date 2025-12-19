extends Node3D

enum State {
	ORBIT,
	SPINUP,
	APPROACH,
	SLASH,
	RECALL
}

# New sub-state for better control over the slashing motion
enum SlashState {
	LUNGE,
	PAUSE,
}

var state: State = State.ORBIT
var slash_state: SlashState = SlashState.LUNGE # New sub-state

@onready var root := $/root/ViewControl
@onready var hitbox := $PlayerHitbox
@onready var mesh := $MeshInstance3D
var level : Node3D
var cotu: Node3D
var icon: Node3D
var target: Node3D

# --- ORBIT ---
@export var orbit_radius := 1.2
@export var orbit_speed := 4.0
var orbit_angle := 0.0

# --- SPINUP & APPROACH ---
@export var spinup_duration := 0.4
var spinup_time := 0.0
@export var approach_speed := 80.0
var approach_target_pos := Vector3.ZERO

# --- SLASH (Refactored) ---
@export var slash_lunge_duration := 0.15 # Time for the slash/lunge movement
@export var slash_pause_duration := 0.1  # Time to pause after the slash
@export var slash_offset_distance := 3.5
@export var max_slashes := 3             # Number of times to slash before recalling
var slash_timer := 0.0                   # General timer for LUNGE and PAUSE
var slash_count := 0                     # Counter for completed slashes

# Variables for controlling the LUNGE movement (Offsets from the target)
var slash_offset_A := Vector3.ZERO
var slash_offset_B := Vector3.ZERO
var slash_is_inbound := true             # True if moving from A to B (towards target), false if B to A

# --- RECALL ---
@export var recall_speed := 80.0

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
			slash_frame(delta) # Handles both LUNGE and PAUSE sub-states
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

	if global_position.distance_to(approach_target_pos) < 0.1:
		switch_to_slash()

func switch_to_approach():
	if is_instance_valid(target):
		# Calculate the position for the shuriken to stage, 
		# offset from the target by the full slash_offset_distance.
		var target_to_shuriken_dir = (global_position - target.global_position).normalized()
		approach_target_pos = target.global_position + target_to_shuriken_dir * slash_offset_distance
	else:
		switch_to_recall()
		return

	state = State.APPROACH

# -------------------------------------------------
# SLASH
# -------------------------------------------------

func switch_to_slash():
	if not is_instance_valid(target):
		switch_to_recall()
		return

	slash_count = 0 
	slash_timer = 0.0
	slash_state = SlashState.LUNGE
	
	# Direction from shuriken (where it approached from) to target center
	var dir_to_target = (target.global_position - global_position).normalized()
	
	# A: The offset vector for the shuriken to start the lunge (furthest away)
	# This is the vector *from* the target *to* the shuriken's starting point.
	slash_offset_A = -dir_to_target * slash_offset_distance
	
	# B: The offset vector for the shuriken to finish the lunge (on the other side)
	slash_offset_B = dir_to_target * slash_offset_distance

	# Start by moving from A towards B
	slash_is_inbound = true 
	
	# Place shuriken at the starting offset relative to the target.
	global_position = target.global_position + slash_offset_A 
	
	state = State.SLASH

func switch_to_slash_lunge():
	slash_timer = 0.0
	slash_state = SlashState.LUNGE
	slash_is_inbound = !slash_is_inbound # Reverse direction for the next lunge

func switch_to_slash_pause():
	slash_timer = 0.0
	slash_state = SlashState.PAUSE
	slash_count += 1 # Count a completed slash

func slash_frame(delta):
	if not is_instance_valid(target):
		switch_to_recall()
		return
	
	look_at(target.global_position)
	
	match slash_state:
		SlashState.LUNGE:
			slash_timer += delta
			var t = min(slash_timer / slash_lunge_duration, 1.0) # t goes from 0.0 to 1.0

			var start_offset: Vector3
			var end_offset: Vector3
			
			if slash_is_inbound:
				start_offset = slash_offset_A
				end_offset = slash_offset_B
			else:
				start_offset = slash_offset_B
				end_offset = slash_offset_A
			
			# Lunge movement: Calculate offset by lerping between A and B,
			# then add that offset to the target's current position (TRACKING)
			var relative_offset = start_offset.lerp(end_offset, t)
			global_position = target.global_position + relative_offset
			
			if t >= 1.0:
				switch_to_slash_pause()

		SlashState.PAUSE:
			slash_timer += delta
			
			# Pause position: Maintain position at the current end offset, 
			# relative to the target's current position (TRACKING)
			var current_pause_offset: Vector3
			if slash_is_inbound:
				current_pause_offset = slash_offset_B
			else:
				current_pause_offset = slash_offset_A
			
			global_position = target.global_position + current_pause_offset

			if slash_timer >= slash_pause_duration:
				# Check if we should continue slashing or recall
				if slash_count < max_slashes:
					switch_to_slash_lunge()
				else:
					switch_to_recall()

# -------------------------------------------------
# RECALL
# -------------------------------------------------
func recall_frame(delta):
	global_position = global_position.move_toward(
		icon.global_position,
		recall_speed * delta
	)

	if global_position.distance_to(icon.global_position) < 0.3:
		queue_free()

func switch_to_recall():
	state = State.RECALL

# -------------------------------------------------
# External API
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	switch_to_spinup(new_target)
