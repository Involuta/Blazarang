extends CharacterBody3D

@export var entity_name := "Clarity" # Used by globals to assign hit score, kill score, etc. (Health is determined by hurtbox. entity_name doesn't affect health so that hurtboxes have more control over health)

enum {
	FORWARD,
	LEFT,
	ATTACK,
}
var behav_state := LEFT

enum DIST_TYPE {
	SHORT_DIST,
	LONG_DIST
}
@export var phase1_min_long_dist_wait := .5
@export var phase1_max_long_dist_wait := 2.5
@export var phase2_min_long_dist_wait := .2
@export var phase2_max_long_dist_wait := 1
var min_long_dist_wait := .5
var max_long_dist_wait := 2.5
var long_dist_wait_remaining := 2.5
var attack_queued := false
signal no_attack_queued

enum PHASE {
	PHASE1,
	PHASE2,
}
var phase := PHASE.PHASE1

@export var min_y_pos := 11.4 # y pos of arena floor, ie X's minimum y position

@export var follow_speed := 3.0
@export var follow_time_before_parry := .1 # Min time necessary to spend in follow state before parry is possible
var current_follow_time := 0.0 # Reset after attack or parry is queued
@export var parry_angle_tolerance := PI/5 # Max y angle difference btwn vec from Cotu to Clarity and player camera fwd vec that triggers Clarity to parry
@export var parry_proximity := 1.5 # Max dist btwn Clarity and rose/ax to trigger parry
var rose_thrown := false # Set to true when Cotu throws non-special roserang while Clarity is following. Set to false when parry ends (end_parry). Why isn't this set to false every frame where a rose throw doesn't happen? Because the anim tree parry transition expressions need to read rose_thrown as true to know parry anim to play, and that happens at least 1 frame after a parry is triggered via queue_parry
var ax_thrown := false # Set to true when Cotu throws non-special axrang while Clarity is following. Set to false when parry ends (end_parry) for the same reason as rose_thrown
var parried := false # Set to true after a parry, set to false after a non-parry
@export var follow_left_distance := 15.0

@export var follow_turn_speed := .05
@export var base_attack_turn_speed := .15
var attack_turn_speed := 0.15

var aiming_at_target := true

@export var short_dist_attack_chances = {
	"SlipnSlice" : .25,
	"Superman" : .25,
	"RightArmSlice" : .4,
	"Triangle" : .1
}

@export var long_dist_attack_chances = {
	"SlipnSlice" : .4,
	"Superman" : .4,
	"Triangle" : .1,
	"DiagonalDash" : .1
}

@export var diagonal_dash_speed := 22.0
@export var dash_speed := 40.0
@export var dash_back_speed := 36.0
@export var side_teleport_dist_from_target := 7.5
@export var front_teleport_dist_from_target := 9.0
@export var slipnslice_speed := 20.0
@export var slipnslice_stop_dist := 1.0
@export var superman_fwd_speed := 20.0
@export var superman_up_speed := 5.0
@export var superman_down_speed := 7.0
@export var triangle_arm_angle := 36.0
@export var triangle_arm_dist := 90.0
@export var triangle_axkick_dist := 3.5
@export var flyingkick_speed := 200.0
@export var flyingkick_hit_frames := 10 # Put the # of frames that the hitbox is active in the animation here

var param_path_base := "parameters/StateMachine/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var transparent_mat := preload("res://textures/clear_tile.tres")
@onready var anim_tree := $AnimationTree
@onready var anim_player := $X_boss_meshes/AnimationPlayer
@onready var mhp := $MeleeHitboxPivot

@onready var root := $/root/ViewControl
var level : Node3D
var target : Node3D
var cotu : Node3D # Clarity only attacks the target; cotu is only referenced here to help Clarity calculate whether to parry when Cotu throws a roserang
var clarity_icon : Node3D
var clarity_icon_pos : Node3D

func _ready():
	add_to_group("lockonables")
	level = root.find_child("Level")
	target = level.find_child("Icon")
	cotu = level.find_child("cotuCB")
	clarity_icon = level.find_child("ClarityIcon")
	clarity_icon_pos = level.find_child("ClarityIconPos")
	
	Globals.cotu_normal_throw_rose.connect(trigger_rose_parry)
	Globals.cotu_power_throw_rose.connect(trigger_rose_parry)
	Globals.cotu_instant_rethrow_rose.connect(trigger_rose_parry)
	Globals.cotu_throw_ax.connect(trigger_ax_parry)
	
	min_long_dist_wait = phase1_min_long_dist_wait
	max_long_dist_wait = phase1_max_long_dist_wait
	
	attack_turn_speed = base_attack_turn_speed
	
	anim_tree.active = true
	mhp.visible = false

func trigger_rose_parry():
	if behav_state == FORWARD or behav_state == LEFT:
		rose_thrown = true

func trigger_ax_parry():
	if behav_state == FORWARD or behav_state == LEFT:
		ax_thrown = true

func follow_forward():
	current_follow_time += get_physics_process_delta_time()
	
	lerp_look_at_position(target.global_position, follow_turn_speed)
	var move_dir = global_position.direction_to(target.global_position)
	velocity.x = follow_speed / 2 * move_dir.x
	velocity.z = follow_speed / 2 * move_dir.z
	"""
	# If Cotu throws the rose or ax at you, dodge it if you haven't done a dodge already and follow_time_before_dodge secs have passed
	# Dodge direction (left/right) is determined in anim tree state transitions
	if not dodged and (rose_thrown or ax_thrown) and current_follow_time >= follow_time_before_dodge and abs(rang_throw_angle_to_me()) < dodge_angle_tolerance:
		queue_dodge()
		return
	
	if not attack_queued and behav_state != ATTACK and global_position.distance_to(target.global_position) < follow_left_distance:
		queue_attack(DIST_TYPE.SHORT_DIST)
		return
	
	# This code block ensures start_long_dist_attack is only called once
	if long_dist_wait_remaining <= 0:
		return
	else:
		long_dist_wait_remaining -= get_physics_process_delta_time()
		if not attack_queued and long_dist_wait_remaining <= 0:
			queue_attack(DIST_TYPE.SHORT_DIST)
	"""

# Add these variables to your script if they aren't there
var orbit_angle: float = 0.0

func follow_left(delta: float):
	# 1. Update the angle based on speed and distance
	# Circumference = 2 * PI * radius. We adjust the angle accordingly.
	var angular_speed = follow_speed / follow_left_distance
	orbit_angle += angular_speed * delta
	
	# 2. Calculate the new target position on the circle
	var offset = Vector3(
		cos(orbit_angle) * follow_left_distance,
		0,
		sin(orbit_angle) * follow_left_distance
	)
	var circle_dest = target.global_position + offset
	
	# 3. Handle rotation
	lerp_look_at_position(target.global_position, follow_turn_speed)
	
	# 4. Move the character
	# We use velocity to move toward the specific point calculated on the circle
	var move_dir = global_position.direction_to(circle_dest)
	
	# We use the full follow_speed to ensure it keeps up with the orbit calculation
	velocity.x = move_dir.x * follow_speed
	velocity.z = move_dir.z * follow_speed
	
	# Optional: If you want to snap the character to the circle to prevent drifting
	# global_position.x = circle_dest.x
	# global_position.z = circle_dest.z

func _physics_process(delta):
	match(behav_state):
		FORWARD:
			follow_forward()
		LEFT:
			follow_left(delta)
	move_and_slide()

func lerp_look_at_position(target_pos, turn_speed):
	var vec3_to_target := global_position.direction_to(target_pos)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)
	
	"""
	var old_head_rotation = x_mesh_head.rotation
	x_mesh_head.look_at(Vector3(target.global_position.x, min_y_pos, target.global_position.z), Vector3.UP, true)
	var head_target_rotation = x_mesh_head.rotation
	x_mesh_head.rotation = old_head_rotation
	x_mesh_head.rotation.y = lerp_angle(x_mesh_head.rotation.y, head_target_rotation.y, 2 * turn_speed)
	x_mesh_head.rotation.x = lerp_angle(x_mesh_head.rotation.x, head_target_rotation.x, 2 * turn_speed)
	x_mesh_head.rotation.z = lerp_angle(x_mesh_head.rotation.z, head_target_rotation.z, 2 * turn_speed)
	"""
