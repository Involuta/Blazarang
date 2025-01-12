extends CharacterBody3D

@export var entity_name := "XBoss"

enum {
	WAIT,
	FOLLOW,
	STRAFE_FOLLOW,
	ATTACK,
}
var behav_state := FOLLOW
var strafing_left := false
var stop_checking := false
var stop_dist := 1.0

enum {
	MY_POS,
	TARGETSIDE_POS,
	TARGETFRONT_POS,
	FLYINGFACERAIN_POS,
	STATIONARY
}
var x_icon_pos_state := MY_POS
var x_icon_lerp_val := 1.0
var x_icon_tp_to_left := true

enum DIST_TYPE {
	SHORT_DIST,
	LONG_DIST_RIGHT_ARM_NOT_DEPLOYED,
	LONG_DIST_RIGHT_ARM_DEPLOYED
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

@export var min_y_pos := 11.4

@export var aggro_distance := -1

@export var follow_speed := 15.0
@export var shortrange_attack_distance := 7.5

@export var attack_duration_secs := 2.5

@export var follow_turn_speed := .05
var attack_turn_speed := 0.15
@export var base_attack_turn_speed := .15
@export var fast_attack_turn_speed := .3

var aiming_at_target := true
var dash_back_canceled := false
var semicircle_center := Vector3.ZERO

@export var short_dist_attack_chances = {
	"SlipnSlice" : .25,
	"Superman" : .25,
	"RightArmSlice" : .4,
	"Triangle" : .1
}

@export var long_dist_right_arm_deployed_attack_chances = {
	"SlipnSlice" : .4,
	"Superman" : .4,
	"Triangle" : .1,
	"DiagonalDash" : .1
}

@export var long_dist_right_arm_not_deployed_attack_chances = {
	"SlipnSlice" : .2,
	"Superman" : .2,
	"Triangle" : .1,
	"RightArmLaser" : .5
}

@export var phase2_short_dist_attack_chances = {
	"ArmBombs" : .05,
	"ChainSlice" : .15,
	"Sweep" : .15,
	"Superman" : .1,
	"RightArmSlice" : .15,
	"Triangle" : .1,
	"StrafeSlice" : .3
}

@export var phase2_long_dist_right_arm_deployed_attack_chances = {
	"ArmBombs" : .1,
	"Sweep" : .25,
	"ChainSlice" : .25,
	"Superman" : .05,
	"Triangle" : .1,
	"DiagonalDash" : .15,
	"SemicircleDash" : .1
}

@export var phase2_long_dist_right_arm_not_deployed_attack_chances = {
	"ArmBombs" : .05,
	"Sweep" : .2,
	"ChainSlice" : .1,
	"Superman" : .1,
	"Triangle" : .1,
	"RightArmLaser" : .1,
	"StrafeLaser" : .1,
	"SemicircleDash" : .25
}

@export var diagonal_dash_speed := 22.0
@export var dash_speed := 40.0
@export var dash_back_speed := 36.0
@export var side_teleport_dist_from_target := 7.5
@export var front_teleport_dist_from_target := 1.5
@export var slipnslice_speed := 20.0
@export var slipnslice_stop_dist := 1.0
@export var superman_fwd_speed := 20.0
@export var superman_up_speed := 5.0
@export var superman_down_speed := 7.0
@export var triangle_arm_angle := 36.0
@export var triangle_arm_dist := 90.0
@export var triangle_axkick_dist := 2.25
@export var flyingkick_speed := 200.0
@export var flyingkick_hit_frames := 10 # Put the # of frames that the hitbox is active in the animation here
@export var flying_facerain_piece_speed := 7.5
@export var flying_facerain_height := 20.0
@export var triangle_volcano_ascend_speed := 100.0
@export var armbombs_dashback_lateral_dist := 15.0
@export var armbombs_dashback_height := 12.0
@export var lunge_facerain_float_dist := 5.0
@export var lunge_facerain_bomb_speed := 9
@export var lunge_laser_diagonal_dash_dist := 25.0
@export var far_strafe_laser_dist := 12.5
@export var very_far_strafe_laser_dist := 16.0
@export var semicircle_dash_radius := 20.0
@export var strafeslice_up_speed := .5
@export var strafeslice_down_speed := 6.0
@export var strafeslice_rush_speed := 40.0
@export var dual_blade_dash_back_dist := 21.0
@export var dual_blade_dash_in_speed := 40.0
@export var dual_blade_dash_stop_dist := 2.0
@export var dual_blade_dash_leap_height := 2.0
@export var diamond_rain_radius := 3.0

var phase2 := false
var param_path_base := "parameters/StateMachine/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var transparent_mat := preload("res://textures/clear_tile.tres")
var body_mat := preload("res://textures/x_boss_body.tres")
var left_head_piece := preload("res://enemies/x_left_head_piece_rb.tscn")
var right_head_piece := preload("res://enemies/x_right_head_piece_rb.tscn")
var top_head_piece := preload("res://enemies/x_top_head_piece_rb.tscn")
var bottom_head_piece := preload("res://enemies/x_bottom_head_piece_rb.tscn")
var diamond := preload("res://levels/x_boss_level/background_nodes/x_diamond.tscn")
@onready var anim_tree := $AnimationTree
@onready var anim_player := $X_boss_meshes/AnimationPlayer
@onready var x_meshes := $X_boss_meshes/Armature/Skeleton3D/Body_001
@onready var x_mesh_head := $X_boss_meshes/Armature/Skeleton3D/Head/XHead
@onready var x_mesh_left_arm := $X_boss_meshes/Armature/Skeleton3D/LeftArm
@onready var x_mesh_right_arm := $X_boss_meshes/Armature/Skeleton3D/RightArm
@onready var mhp1 := $MeleeHitboxPivot/XBlade/XLeftArm
@onready var mhp2 := $MeleeHitboxPivot2/XBlade/XLeftArm

@onready var root := $/root/ViewControl
var level : Node3D
var target : Node3D
var left_arm : Node3D
var right_arm : Node3D
var x_icon : Node3D
var x_icon_pos : Node3D

func _ready():
	add_to_group("lockonables")
	if aggro_distance > 0:
		behav_state = WAIT
	
	level = root.find_child("Level")
	target = level.find_child("Icon")
	left_arm = level.find_child("FloatingXLeftArm")
	right_arm = level.find_child("FloatingXRightArm")
	x_icon = level.find_child("XIcon")
	x_icon_pos = level.find_child("XIconPos")
	
	Globals.health_segment_lost.connect(on_health_segment_lost)
	
	min_long_dist_wait = phase1_min_long_dist_wait
	max_long_dist_wait = phase1_max_long_dist_wait
	
	attack_turn_speed = base_attack_turn_speed
	
	anim_tree.active = true
	x_mesh_head.visible = true
	mhp1.visible = false
	mhp2.visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		print($X_boss_meshes/Armature/Skeleton3D/Head.position)
		match(behav_state):
			WAIT:
				print("WAIT")
			FOLLOW:
				print("FOLLOW")
			ATTACK:
				print("ATTACK")
	if not is_on_floor():
		velocity.y -= gravity * delta
		if global_position.y < min_y_pos:
			velocity.y = 0
			global_position.y = min_y_pos
	move_and_slide()
	match(behav_state):
		WAIT:
			wait()
		FOLLOW:
			follow()
		STRAFE_FOLLOW:
			strafe_follow()
		ATTACK:
			attack_frame()
	match(x_icon_pos_state):
		MY_POS:
			x_icon_follow_my_pos()
		TARGETSIDE_POS:
			x_icon_follow_targetside_pos()
		TARGETFRONT_POS:
			x_icon_follow_targetfront_pos()
		STATIONARY:
			pass
	x_icon.global_position = lerp(x_icon.global_position, x_icon_pos.global_position, x_icon_lerp_val)
	if global_position.y < -100:
		queue_free()
	
	anim_tree.set("parameters/StateMachine/WalkSpace/blend_position", velocity.length())

func lerp_look_at_position(target_pos, turn_speed):
	var vec3_to_target := global_position.direction_to(target_pos)
	global_rotation.y = lerp_angle(global_rotation.y, PI + atan2(vec3_to_target.x, vec3_to_target.z), turn_speed)
	
	var old_head_rotation = x_mesh_head.rotation
	x_mesh_head.look_at(Vector3(target.global_position.x, min_y_pos, target.global_position.z), Vector3.UP, true)
	var head_target_rotation = x_mesh_head.rotation
	x_mesh_head.rotation = old_head_rotation
	x_mesh_head.rotation.y = lerp_angle(x_mesh_head.rotation.y, head_target_rotation.y, 2 * turn_speed)
	x_mesh_head.rotation.x = lerp_angle(x_mesh_head.rotation.x, head_target_rotation.x, 2 * turn_speed)
	x_mesh_head.rotation.z = lerp_angle(x_mesh_head.rotation.z, head_target_rotation.z, 2 * turn_speed)

func remove_gravity():
	gravity = 0

func restore_gravity():
	gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func wait():
	move_and_slide()
	if global_position.distance_to(target.global_position) < aggro_distance:
		behav_state = FOLLOW

func follow():
	lerp_look_at_position(target.global_position, follow_turn_speed)
	var move_dir = global_position.direction_to(target.global_position)
	velocity.x = follow_speed / 2 * move_dir.x
	velocity.z = follow_speed / 2 * move_dir.z
	
	if not attack_queued and behav_state != ATTACK and global_position.distance_to(target.global_position) < shortrange_attack_distance:
		queue_attack(DIST_TYPE.SHORT_DIST)
	
	# This code block ensures start_long_dist_attack is only called once
	if long_dist_wait_remaining <= 0:
		return
	else:
		long_dist_wait_remaining -= get_physics_process_delta_time()
		if not attack_queued and long_dist_wait_remaining <= 0:
			if right_arm_deployed():
				queue_attack(DIST_TYPE.LONG_DIST_RIGHT_ARM_DEPLOYED)
			else:
				queue_attack(DIST_TYPE.LONG_DIST_RIGHT_ARM_NOT_DEPLOYED)

func strafe_follow():
	var dir_to_target := global_position.direction_to(target.global_position)
	var dir_to_target2D := Vector2(dir_to_target.x, dir_to_target.z)
	var icon_vec := dir_to_target2D.orthogonal()
	if strafing_left:
		icon_vec *= -1
	var strafe_dest = target.global_position + shortrange_attack_distance*Vector3(icon_vec.x, 0, icon_vec.y)
	
	lerp_look_at_position(strafe_dest, follow_turn_speed)
	var move_dir = global_position.direction_to(strafe_dest)
	velocity.x = follow_speed / 2 * move_dir.x
	velocity.z = follow_speed / 2 * move_dir.z

func left_arm_deployed():
	return x_meshes.get_surface_override_material(2) != body_mat

func right_arm_deployed():
	return x_meshes.get_surface_override_material(5) != body_mat

func head_deployed():
	return not x_mesh_head.visible

func queue_attack(dist_type):
	attack_queued = true
	if phase2:
		match(dist_type):
			DIST_TYPE.SHORT_DIST:
				anim_tree.set(choose_attack(phase2_short_dist_attack_chances), true)
			DIST_TYPE.LONG_DIST_RIGHT_ARM_DEPLOYED:
				anim_tree.set(choose_attack(phase2_long_dist_right_arm_deployed_attack_chances), true)
			DIST_TYPE.LONG_DIST_RIGHT_ARM_NOT_DEPLOYED:
				anim_tree.set(choose_attack(phase2_long_dist_right_arm_not_deployed_attack_chances), true)
	else:
		match(dist_type):
			DIST_TYPE.SHORT_DIST:
				anim_tree.set(choose_attack(short_dist_attack_chances), true)
			DIST_TYPE.LONG_DIST_RIGHT_ARM_DEPLOYED:
				anim_tree.set(choose_attack(long_dist_right_arm_deployed_attack_chances), true)
			DIST_TYPE.LONG_DIST_RIGHT_ARM_NOT_DEPLOYED:
				anim_tree.set(choose_attack(long_dist_right_arm_not_deployed_attack_chances), true)

func on_health_segment_lost(seg_num):
	if seg_num == 3:
		if attack_queued:
			await no_attack_queued
		attack_queued = true
		anim_tree.set(param_path_base + "FlyingFaceRain", true)
	if seg_num == 2:
		start_phase2()

func start_phase2():
	phase2 = true
	min_long_dist_wait = phase2_min_long_dist_wait
	max_long_dist_wait = phase2_max_long_dist_wait
	var light_tween = get_tree().create_tween()
	light_tween.set_parallel()
	var phase1light = root.find_child("Phase1Light")
	var phase2light = root.find_child("Phase2Light")
	light_tween.tween_property(phase1light, "light_energy", 0, 2)
	light_tween.tween_property(phase2light, "light_energy", 1.5, 2)

func aim_at_target():
	aiming_at_target = true

func set_fast_turn_speed():
	attack_turn_speed = fast_attack_turn_speed

func set_base_turn_speed():
	attack_turn_speed = base_attack_turn_speed

func start_strafe():
	behav_state = STRAFE_FOLLOW
	strafing_left = rng.randf() < .5

func start_attack():
	# Without this await, the animation player would call end_attack at the end of the previous animation on the exact same frame as when the AnimationPlayer.play func is called below. Since an animation was currently in progress, the func call would do nothing, leaving the enemy in ATTACK mode but with no animation playing to free it from ATTACK mode, causing it to stand still indefinitely
	await get_tree().create_timer(get_process_delta_time()).timeout
	behav_state = ATTACK
	aiming_at_target = true

func end_attack():
	stop_checking = false
	attack_queued = false
	no_attack_queued.emit()
	for attack in phase2_short_dist_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in phase2_long_dist_right_arm_deployed_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in phase2_long_dist_right_arm_not_deployed_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in short_dist_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in long_dist_right_arm_deployed_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in long_dist_right_arm_not_deployed_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	long_dist_wait_remaining = rng.randf_range(min_long_dist_wait, max_long_dist_wait)
	behav_state = FOLLOW

func end_attack_instant_followup():
	attack_queued = false
	no_attack_queued.emit()
	if phase2:
		for attack in phase2_short_dist_attack_chances.keys():
			anim_tree.set(param_path_base + attack, false)
		for attack in phase2_long_dist_right_arm_deployed_attack_chances.keys():
			anim_tree.set(param_path_base + attack, false)
		for attack in phase2_long_dist_right_arm_not_deployed_attack_chances.keys():
			anim_tree.set(param_path_base + attack, false)
	else:
		for attack in short_dist_attack_chances.keys():
			anim_tree.set(param_path_base + attack, false)
		for attack in long_dist_right_arm_deployed_attack_chances.keys():
			anim_tree.set(param_path_base + attack, false)
		for attack in long_dist_right_arm_not_deployed_attack_chances.keys():
			anim_tree.set(param_path_base + attack, false)
	long_dist_wait_remaining = .02
	behav_state = FOLLOW

func end_flying_facerain():
	end_attack()
	anim_tree.set(param_path_base + "FlyingFaceRain", false)

func choose_attack(attack_chances) -> String:
	var choice := rng.randf()
	var cumulative_weight := 0.0
	for attack in attack_chances:
		cumulative_weight += attack_chances[attack]
		if choice <= cumulative_weight:
			return param_path_base + attack
	return param_path_base + attack_chances.keys()[0]

func attack_frame():
	if aiming_at_target:
		lerp_look_at_position(target.global_position, attack_turn_speed)
	if stop_checking and global_position.distance_to(target.global_position) < stop_dist:
		velocity.x = 0
		velocity.z = 0

func do_stop_checking():
	stop_checking = true

func stop_aiming_at_target():
	aiming_at_target = false

func face_target():
	look_at(target.global_position)
	rotation.x = 0
	rotation.z = 0

func diagonal_dash():
	var dir_to_target := global_position.direction_to(target.global_position)
	var dir_to_target2D := Vector2(dir_to_target.x, dir_to_target.z)
	var icon_vec := dir_to_target2D.orthogonal()
	if not x_icon_tp_to_left:
		icon_vec *= -1
	var dash_dir2D := (1.7 * dir_to_target2D + icon_vec).normalized()
	velocity = diagonal_dash_speed * Vector3(dash_dir2D.x, 0, dash_dir2D.y).normalized()

func slowdown(duration_secs : float):
	var mvmt_tween = get_tree().create_tween()
	mvmt_tween.tween_property(self, "velocity", Vector3.ZERO, duration_secs)

func dash():
	velocity = dash_speed * -transform.basis.z

func teleport():
	dash_back_canceled = true
	global_position.x = x_icon_pos.global_position.x
	global_position.y = max(min_y_pos, x_icon_pos.global_position.y)
	global_position.z = x_icon_pos.global_position.z
	var tp_inst = load("res://enemies/x_teleport_in.tscn").instantiate()
	level.add_child.call_deferred(tp_inst)
	await tp_inst.tree_entered
	tp_inst.global_position = global_position
	tp_inst.global_position.y = x_icon_pos.global_position.y

func slipnslice_rush():
	stop_dist = slipnslice_stop_dist
	velocity = slipnslice_speed * -transform.basis.z

func stop_mvmt():
	velocity.x = 0
	velocity.z = 0

func start_superman():
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel from changing
	global_position.y = min_y_pos + .01
	velocity = .6 * superman_fwd_speed * -transform.basis.z
	velocity.y = superman_up_speed

func superman_rush():
	velocity = superman_fwd_speed * -transform.basis.z
	velocity.y = -superman_down_speed

func triangle_recall_arms():
	if left_arm_deployed():
		left_arm.stop_firing_laser()
		var left_mvmt_tween = get_tree().create_tween()
		var left_rot_tween = get_tree().create_tween()
		left_rot_tween.tween_property(left_arm, "rotation_degrees", Vector3(63, -25, -164), .2)
		left_mvmt_tween.tween_property(left_arm, "global_position", global_position + Vector3(-.351, .436, -.252), .2)
		left_mvmt_tween.tween_callback(hide_floating_left_arm)
		left_mvmt_tween.tween_callback(restore_rig_left_arm)
	
	if right_arm_deployed():
		right_arm.stop_firing_laser()
		var right_mvmt_tween = get_tree().create_tween()
		var right_rot_tween = get_tree().create_tween()
		right_rot_tween.tween_property(right_arm, "rotation_degrees", Vector3(63, 25, -164), .2)
		right_mvmt_tween.tween_property(right_arm, "global_position", global_position + Vector3(.351, .436, -.252), .2)
		right_mvmt_tween.tween_callback(hide_floating_right_arm)
		right_mvmt_tween.tween_callback(restore_rig_right_arm)

func triangle_shoot_arms():
	right_arm.rotation_degrees = (rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP
	right_arm.visible = true
	var right_arm_tween = get_tree().create_tween()
	right_arm_tween.tween_callback(right_arm.stop_firing_laser)
	right_arm_tween.tween_property(right_arm, "global_position", triangle_arm_dist*right_arm.basis.z, .3).as_relative().from(global_position + Vector3(.2, .2, 0))
	right_arm_tween.tween_property(right_arm, "rotation_degrees", Vector3.UP * -2 * triangle_arm_angle, .1).as_relative()
	right_arm_tween.tween_callback(right_arm.fire_laser)
	
	left_arm.rotation_degrees = (rotation_degrees.y - 180 - triangle_arm_angle) * Vector3.UP
	left_arm.visible = true
	var left_arm_tween = get_tree().create_tween()
	left_arm_tween.tween_callback(left_arm.stop_firing_laser)
	left_arm_tween.tween_property(left_arm, "global_position", triangle_arm_dist*left_arm.basis.z, .3).as_relative().from(global_position + Vector3(-.2, .2, 0))
	left_arm_tween.tween_property(left_arm, "rotation_degrees", Vector3.UP * 2 * triangle_arm_angle, .1).as_relative()
	left_arm_tween.tween_callback(left_arm.fire_laser)

func flyingkick_rush():
	global_position.y = min_y_pos + .1
	velocity = flyingkick_speed * -transform.basis.z
	await get_tree().create_timer((flyingkick_hit_frames-1)/60.0).timeout
	velocity = Vector3.ZERO

func dash_back():
	dash_back_canceled = false
	velocity = dash_back_speed * transform.basis.z
	var dash_back_tween = get_tree().create_tween()
	dash_back_tween.tween_method(dash_back_frame, 0.0, 1.0, .9).set_ease(Tween.EASE_IN)

func dash_back_frame(lerp_val):
	if dash_back_canceled:
		return
	var original_vel = dash_back_speed * velocity.normalized()
	velocity = original_vel.lerp(Vector3.ZERO, lerp_val)

func right_arm_laser():
	right_arm.global_position = x_mesh_right_arm.global_position
	right_arm.rotation = (PI + rotation.y) * Vector3.UP
	right_arm.visible = true
	right_arm.fire_laser()

func chain_slice_left_laser():
	left_arm.rotation_degrees = (rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP
	left_arm.visible = true
	var left_arm_tween = get_tree().create_tween()
	left_arm_tween.tween_callback(left_arm.stop_firing_laser)
	left_arm_tween.tween_property(left_arm, "global_position", triangle_arm_dist*left_arm.basis.z, .3).as_relative().from(global_position + Vector3(-.2, .2, 0))
	left_arm_tween.tween_property(left_arm, "rotation_degrees", Vector3.UP * -2 * triangle_arm_angle, .1).as_relative()
	left_arm_tween.tween_callback(left_arm.fire_laser)

func start_flying_facerain():
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel from changing
	global_position = Vector3(0, min_y_pos + .01, -24)
	rotation.y = -PI
	var fr_tween = get_tree().create_tween()
	fr_tween.tween_property(self, "global_position", flying_facerain_height * Vector3.UP, 1.0).from(Vector3(0, min_y_pos + .01, -24))

func flying_facerain_shoot_bombs():
	velocity = 8 * (Vector3.UP)
	var lhp = left_head_piece.instantiate()
	level.add_child.call_deferred(lhp)
	await lhp.tree_entered
	var rhp = right_head_piece.instantiate()
	level.add_child.call_deferred(rhp)
	await rhp.tree_entered
	var thp = top_head_piece.instantiate()
	level.add_child.call_deferred(thp)
	await thp.tree_entered
	var bhp = bottom_head_piece.instantiate()
	level.add_child.call_deferred(bhp)
	await bhp.tree_entered
	lhp.linear_velocity = (Vector3.UP + Vector3.LEFT) * flying_facerain_piece_speed
	lhp.global_position = Vector3(0, flying_facerain_height - .68, -.2)
	lhp.rotation = Vector3(PI / 2, 0, 0)
	rhp.linear_velocity = (Vector3.UP + Vector3.RIGHT) * flying_facerain_piece_speed
	rhp.global_position = Vector3(0, flying_facerain_height - .68, -.2)
	rhp.rotation = Vector3(PI / 2, 0, 0)
	thp.linear_velocity = (Vector3.UP + Vector3.FORWARD) * flying_facerain_piece_speed
	thp.global_position = Vector3(0, flying_facerain_height - .68, -.2)
	thp.rotation = Vector3(PI / 2, 0, 0)
	bhp.linear_velocity = (Vector3.UP + Vector3.BACK) * flying_facerain_piece_speed
	bhp.global_position = Vector3(0, flying_facerain_height - .68, -.2)
	bhp.rotation = Vector3(PI / 2, 0, 0)

func flying_facerain_descend():
	var fr_tween = get_tree().create_tween()
	fr_tween.tween_property(self, "global_position", min_y_pos * Vector3.UP, .166)
	fr_tween.tween_callback(spawn_volcano)

func spawn_volcano():
	var volcano_inst = load("res://enemies/x_volcano.tscn").instantiate()
	level.add_child(volcano_inst)
	volcano_inst.global_position = global_position

func triangle_volcano_ascend():
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel and pos from changing
	global_position.y = min_y_pos + .01
	velocity = triangle_volcano_ascend_speed * Vector3.UP
	x_icon_lerp_val = .2
	x_icon_pos.global_position.x = target.global_position.x
	x_icon_pos.global_position.z = target.global_position.z
	set_x_icon_stationary()

func triangle_volcano_descend():
	velocity = Vector3.ZERO
	global_position.x = x_icon_pos.global_position.x
	global_position.z = x_icon_pos.global_position.z
	var original_descend_pos := global_position
	var des_tween = get_tree().create_tween()
	des_tween.tween_property(self, "global_position", (original_descend_pos.y - min_y_pos) * Vector3.DOWN, .3).from(original_descend_pos).as_relative()

func armbombs_dashback():
	var dir_to_target := global_position.direction_to(target.global_position)
	var dash_tween = get_tree().create_tween()
	dash_tween.tween_property(self, "global_position", Vector3(-armbombs_dashback_lateral_dist * dir_to_target.x, armbombs_dashback_height, -armbombs_dashback_lateral_dist * dir_to_target.z), .5).as_relative().set_ease(Tween.EASE_OUT)

func armbombs_arm_recall():
	if left_arm_deployed():
		left_arm.stop_firing_laser()
		var left_mvmt_tween = get_tree().create_tween()
		left_mvmt_tween.tween_method(recall_left_arm_frame, 0.0, 1.0, .2).set_ease(Tween.EASE_OUT)
		left_mvmt_tween.tween_callback(hide_floating_left_arm)
	if right_arm_deployed():
		right_arm.stop_firing_laser()
		var right_mvmt_tween = get_tree().create_tween()
		right_mvmt_tween.tween_method(rightarmslice_recall_right_arm_frame, 0.0, 1.0, .2).set_ease(Tween.EASE_OUT)
		right_mvmt_tween.tween_callback(hide_floating_right_arm)

func left_arm_recall_homing():
	if left_arm_deployed():
		left_arm.stop_firing_laser()
		var left_mvmt_tween = get_tree().create_tween()
		left_mvmt_tween.tween_method(recall_left_arm_frame, 0.0, 1.0, .2).set_ease(Tween.EASE_OUT)
		left_mvmt_tween.tween_callback(hide_floating_left_arm)
		left_mvmt_tween.tween_callback(restore_rig_left_arm)

func right_arm_recall_homing():
	if right_arm_deployed():
		right_arm.stop_firing_laser()
		var right_mvmt_tween = get_tree().create_tween()
		right_mvmt_tween.tween_method(rightarmslice_recall_right_arm_frame, 0.0, 1.0, .2).set_ease(Tween.EASE_OUT)
		right_mvmt_tween.tween_callback(hide_floating_right_arm)
		right_mvmt_tween.tween_callback(restore_rig_right_arm)

func armbombs_shoot_arms():
	armbombs_arm_switch()
	mhp1.visible = false
	mhp2.visible = false
	
	var dir_to_target := global_position.direction_to(target.global_position)
	
	var left_arm_landing_site = Vector3(0,min_y_pos-1.3,0)
	var leftside_vec := Vector2(dir_to_target.x, dir_to_target.z).orthogonal() - Vector2(dir_to_target.x, dir_to_target.z)
	left_arm_landing_site.x = target.global_position.x + side_teleport_dist_from_target * leftside_vec.x
	left_arm_landing_site.z = target.global_position.z + side_teleport_dist_from_target * leftside_vec.y
	
	left_arm.look_at_from_position(mhp1.global_position, left_arm_landing_site, Vector3.UP, true)
	var all_tween = get_tree().create_tween()
	
	var rightside_vec := -Vector2(dir_to_target.x, dir_to_target.z).orthogonal()
	var right_arm_landing_site = Vector3(0,min_y_pos-1.3,0)
	right_arm_landing_site.x = target.global_position.x + side_teleport_dist_from_target * rightside_vec.x
	right_arm_landing_site.z = target.global_position.z + side_teleport_dist_from_target * rightside_vec.y
	
	right_arm.look_at_from_position(mhp2.global_position, right_arm_landing_site, Vector3.UP, true)
	
	armbombs_trigger()
	
	all_tween.tween_property(left_arm, "global_position", left_arm_landing_site, .125).set_trans(Tween.TRANS_LINEAR) # .125 = length of 8th note at 120 BPM
	all_tween.tween_property(right_arm, "global_position", right_arm_landing_site, .125).set_trans(Tween.TRANS_LINEAR)

func armbombs_arm_switch():
	# Switch melee hitbox pivot (mhp) arms with floating arms
	left_arm.prep_arrow()
	right_arm.prep_arrow()
	left_arm.visible = true
	right_arm.visible = true

func armbombs_trigger():
	left_arm.armbomb_trigger()
	await get_tree().create_timer(.125).timeout
	right_arm.armbomb_trigger()

func lunge_facerain_start_dash():
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel and pos from changing
	global_position.y = min_y_pos + .01
	var dir_to_target := global_position.direction_to(target.global_position)
	var dist_to_target := global_position.distance_to(target.global_position)
	var lateral_dist := dist_to_target+armbombs_dashback_lateral_dist
	var fr_tween = get_tree().create_tween()
	fr_tween.tween_property(self, "global_position", Vector3(lateral_dist * dir_to_target.x, .75*armbombs_dashback_height, lateral_dist * dir_to_target.z), 1).as_relative().set_ease(Tween.EASE_OUT)
	fr_tween.tween_property(self, "global_position", Vector3(.1*lateral_dist * dir_to_target.x, .1*.75*armbombs_dashback_height, .1*lateral_dist * dir_to_target.z), .5).as_relative().set_ease(Tween.EASE_OUT)

func lunge_facerain_shoot_bombs():
	if not x_mesh_head.visible:
		return
	x_mesh_head.visible = false
	var lhp = left_head_piece.instantiate()
	level.add_child.call_deferred(lhp)
	await lhp.tree_entered
	var rhp = right_head_piece.instantiate()
	level.add_child.call_deferred(rhp)
	await rhp.tree_entered
	var thp = top_head_piece.instantiate()
	level.add_child.call_deferred(thp)
	await thp.tree_entered
	var bhp = bottom_head_piece.instantiate()
	level.add_child.call_deferred(bhp)
	await bhp.tree_entered
	var dir_to_target = x_mesh_head.global_position.direction_to(target.global_position)
	dir_to_target.y = .5
	var dir_to_target_orth_2D = Vector2(dir_to_target.x, dir_to_target.z).orthogonal()
	var dir_to_target_orth_3D = Vector3(dir_to_target_orth_2D.x, 0, dir_to_target_orth_2D.y)
	lhp.linear_velocity = lunge_facerain_bomb_speed * (dir_to_target + dir_to_target_orth_3D).normalized()
	lhp.global_position = x_mesh_head.global_position
	lhp.rotation = Vector3(PI / 2, rotation.y, 0)
	rhp.linear_velocity = lunge_facerain_bomb_speed * (dir_to_target - dir_to_target_orth_3D).normalized()
	rhp.global_position = x_mesh_head.global_position
	rhp.rotation = Vector3(PI / 2, rotation.y, 0)
	thp.linear_velocity = 2 * lunge_facerain_bomb_speed * dir_to_target
	thp.global_position = x_mesh_head.global_position
	thp.rotation = Vector3(PI / 2, rotation.y, 0)
	bhp.linear_velocity = lunge_facerain_bomb_speed * dir_to_target
	bhp.global_position = x_mesh_head.global_position
	bhp.rotation = Vector3(PI / 2, rotation.y, 0)

func lunge_facerain_end_dash():
	look_at(target.global_position)
	var fr_tween = get_tree().create_tween()
	await fr_tween.tween_property(self, "global_position", target.global_position, .25).set_ease(Tween.EASE_IN).finished
	rotation.x = 0
	rotation.y = 0

func start_lunge_superkick():
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel from changing
	global_position.y = min_y_pos + .01
	velocity = superman_fwd_speed * -transform.basis.z
	velocity.y = superman_up_speed

func lunge_superkick_rush():
	velocity = Vector3.ZERO
	var lateral_dest := global_position + (global_position.distance_to(target.global_position)-1) * -transform.basis.z
	var rush_tween = get_tree().create_tween()
	rush_tween.tween_property(self, "global_position", Vector3(lateral_dest.x, min_y_pos, lateral_dest.z), .167).set_trans(Tween.TRANS_CUBIC)

func start_lunge_laser():
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel from changing
	global_position.y = min_y_pos + .01
	velocity = superman_fwd_speed * -transform.basis.z
	velocity.y = superman_up_speed

func lunge_laser_shoot_arm():
	right_arm.rotation_degrees = (rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP
	right_arm.visible = true
	var right_arm_tween = get_tree().create_tween()
	right_arm_tween.tween_callback(right_arm.stop_firing_laser)
	var right_arm_offset_vec = 1.5*triangle_arm_dist*right_arm.basis.z
	right_arm_tween.tween_property(right_arm, "global_position", Vector3(global_position.x+right_arm_offset_vec.x, min_y_pos, global_position.z+right_arm_offset_vec.z), .3).from(global_position + Vector3(.2, .2, 0))
	right_arm_tween.tween_property(right_arm, "rotation_degrees", -90*Vector3.UP, .1).as_relative()
	right_arm_tween.tween_callback(right_arm.fire_laser)

func lunge_laser_diagonal_dash():
	var fwd_dir := -transform.basis.z
	var fwd_dir2D := Vector2(fwd_dir.x, fwd_dir.z)
	var dash_dir2D := (fwd_dir2D - fwd_dir2D.orthogonal()).normalized()
	var pos_tween := get_tree().create_tween()
	var lateral_mvmt_vec := lunge_laser_diagonal_dash_dist * Vector3(dash_dir2D.x, 0, dash_dir2D.y)
	pos_tween.tween_property(self, "global_position", Vector3(global_position.x + lateral_mvmt_vec.x, min_y_pos, global_position.z + lateral_mvmt_vec.z), 1.15).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

func start_strafe_laser():
	behav_state = STRAFE_FOLLOW
	strafing_left = false
	# Wait before increasing this
	await get_tree().create_timer(.35)
	follow_speed *= 2

func strafe_laser_deploy_arm():
	right_arm.global_position = x_mesh_right_arm.global_position
	right_arm.rotation = (PI/2 + rotation.y) * Vector3.UP
	right_arm.visible = true
	right_arm.fire_laser()
	hide_rig_right_arm()
	follow_speed /= 2

func far_strafe_laser_deploy_arm():
	right_arm.global_position = x_mesh_right_arm.global_position
	right_arm.rotation = (3*PI/4 + rotation.y) * Vector3.UP
	right_arm.visible = true
	right_arm.fire_laser()
	hide_rig_right_arm()
	follow_speed /= 2

func very_far_strafe_laser_deploy_arm():
	right_arm.global_position = x_mesh_right_arm.global_position
	right_arm.rotation = (7*PI/8 + rotation.y) * Vector3.UP
	right_arm.visible = true
	right_arm.fire_laser()
	hide_rig_right_arm()
	follow_speed /= 2

func semicircle_dash():
	var mvmt_tween := get_tree().create_tween()
	var dash_dir = -1 if x_icon_tp_to_left else 1
	semicircle_center = global_position + semicircle_dash_radius * global_position.direction_to(target.global_position)
	# 2 frames enabling X to freely rotate (X enters attack mode, then stops aiming at target)
	# 18 frames of rotation towards dash dir = .3 secs
	# 145 frames of flight = 2.4167 secs
	# 35 frames of slowdown = .5833 secs
	mvmt_tween.tween_property(self, "global_rotation", Vector3.UP * PI/2 * dash_dir, 0.3).as_relative()
	mvmt_tween.tween_method(semicircle_dash_frame, 0.0, 1.0, 2.4167).set_ease(Tween.EASE_OUT)
	mvmt_tween.tween_callback(semicircle_reset_mesh_rotation)
	mvmt_tween.tween_callback(slowdown.bind(.5833))
	mvmt_tween.tween_method(semicircle_slowdown_frame, 0.0, 1.0, .5833).set_ease(Tween.EASE_OUT)

func semicircle_dash_tp():
	var mvmt_tween := get_tree().create_tween()
	var dash_dir = -1 if x_icon_tp_to_left else 1
	semicircle_center = global_position + semicircle_dash_radius * global_position.direction_to(target.global_position)
	# 2 frames enabling X to freely rotate (X enters attack mode, then stops aiming at target)
	# 18 frames of rotation towards dash dir = .3 secs
	# 82 frames of flight = 1.667 secs
	mvmt_tween.tween_property(self, "rotation", Vector3.UP * PI/2 * dash_dir, 0.3).as_relative()
	mvmt_tween.tween_method(semicircle_dash_frame, 0.0, 1.0, 1.367).set_ease(Tween.EASE_OUT)
	mvmt_tween.tween_callback(semicircle_reset_mesh_rotation)

func semicircle_dash_frame(lerp_val):
	var dir_to_target := global_position.direction_to(semicircle_center)
	var dash_dir := Vector2(dir_to_target.x, dir_to_target.z).orthogonal()
	if x_icon_tp_to_left:
		dash_dir *= -1
	# Linear speed = angular speed * radius
	# Angular speed = PI radians / len of anim in secs
	var angular_speed = PI / 2.4167
	var linear_speed = angular_speed * semicircle_dash_radius
	var dash_dir3D := Vector3(dash_dir.x, 0, dash_dir.y)
	rotation.y = lerp_angle(rotation.y, PI + atan2(dash_dir.x, dash_dir.y), attack_turn_speed)
	global_position.y = 2*sin(PI*lerp_val) + min_y_pos
	x_meshes.rotation.x = deg_to_rad(-10)*cos(PI*lerp_val)
	velocity = linear_speed * dash_dir3D

func semicircle_reset_mesh_rotation():
	x_meshes.rotation.x = 0

func semicircle_slowdown_frame(lerp_val):
	var dir_to_target := global_position.direction_to(target.global_position)
	rotation.y = lerp_angle(global_rotation.y, PI + atan2(dir_to_target.x, dir_to_target.z), lerp_val)
	x_meshes.rotation.x = lerp_angle(x_meshes.rotation.x, 0, lerp_val)
	# Look at target during slowdown
	var old_head_rotation = x_mesh_head.rotation
	x_mesh_head.look_at(Vector3(target.global_position.x, min_y_pos, target.global_position.z), Vector3.UP, true)
	var head_target_rotation = x_mesh_head.rotation
	x_mesh_head.rotation = old_head_rotation
	x_mesh_head.rotation.y = lerp_angle(x_mesh_head.rotation.y, head_target_rotation.y, 2 * attack_turn_speed)
	x_mesh_head.rotation.x = lerp_angle(x_mesh_head.rotation.x, head_target_rotation.x, 2 * attack_turn_speed)
	x_mesh_head.rotation.z = lerp_angle(x_mesh_head.rotation.z, head_target_rotation.z, 2 * attack_turn_speed)

func start_strafeslice():
	global_position.y = min_y_pos + .01
	velocity.y = strafeslice_up_speed
	behav_state = STRAFE_FOLLOW
	strafing_left = false
	follow_speed *= 2

func strafeslice_rush():
	velocity = strafeslice_rush_speed * -transform.basis.z
	velocity.y = -strafeslice_down_speed
	follow_speed /= 2

func dual_blade_dash_back():
	var dir_to_target := global_position.direction_to(target.global_position)
	var mvmt_tween := get_tree().create_tween()
	mvmt_tween.tween_property(self, "global_position", -dual_blade_dash_back_dist * dir_to_target, .2).as_relative().set_ease(Tween.EASE_OUT)

func dual_blade_dash_in():
	stop_dist = dual_blade_dash_stop_dist
	var dir_to_target := global_position.direction_to(target.global_position)
	velocity = dual_blade_dash_in_speed * dir_to_target

func dual_blade_leap():
	var mvmt_tween := get_tree().create_tween()
	mvmt_tween.tween_property(self, "global_position", dual_blade_dash_leap_height * Vector3.UP, .1).as_relative()
	mvmt_tween.tween_interval(.6)
	mvmt_tween.tween_property(self, "global_position", dual_blade_dash_leap_height * Vector3.DOWN, .1).as_relative()

func diamond_rain():
	var rain_tween := get_tree().create_tween()
	var spawn_pos := global_position + diamond_rain_radius * transform.basis.z
	rain_tween.tween_callback(spawn_diamond_at.bind(spawn_pos))
	rain_tween.tween_interval(.25)
	spawn_pos = global_position + diamond_rain_radius * -transform.basis.x
	rain_tween.tween_callback(spawn_diamond_at.bind(spawn_pos))
	spawn_pos = global_position + diamond_rain_radius * transform.basis.x
	rain_tween.tween_callback(spawn_diamond_at.bind(spawn_pos))

func spawn_diamond_at(pos : Vector3):
	var d = diamond.instantiate()
	level.add_child.call_deferred(d)
	await d.tree_entered
	d.global_position = pos + Vector3.UP * 100
	var fall_tween := get_tree().create_tween()
	fall_tween.tween_property(d, "global_position", pos + Vector3.UP * 37.5, .1)
	fall_tween.tween_property(d, "global_position", pos, .25).set_ease(Tween.EASE_IN)
	fall_tween.tween_interval(3.0)
	fall_tween.tween_property(d, "global_position", pos + Vector3.UP * 37.5, 1).set_ease(Tween.EASE_IN)
	fall_tween.tween_property(d, "global_position", pos + Vector3.UP * 100, .1)
	fall_tween.tween_callback(delete_diamond.bind(d))

func delete_diamond(d: Node3D):
	d.queue_free()

func recall_left_arm():
	if not left_arm_deployed():
		return
	left_arm.stop_firing_laser()
	var recall_tween = get_tree().create_tween()
	recall_tween.tween_method(recall_left_arm_frame, 0.0, 1.0, .65).set_ease(Tween.EASE_OUT)

func recall_left_arm_frame(lerp_val):
	left_arm.rotation_degrees = (rotation_degrees.y + 180 + 112) * Vector3.UP
	left_arm.global_position = left_arm.global_position.lerp(x_mesh_left_arm.global_position, lerp_val)

func hide_floating_left_arm():
	left_arm.visible = false

func hide_rig_left_arm():
	x_meshes.set_surface_override_material(2, transparent_mat)

func restore_rig_left_arm():
	x_meshes.set_surface_override_material(2, body_mat)

func rightarmslice_recall_right_arm():
	if not right_arm_deployed():
		return
	right_arm.stop_firing_laser()
	var recall_tween = get_tree().create_tween()
	recall_tween.tween_method(rightarmslice_recall_right_arm_frame, 0.0, 1.0, .25).set_ease(Tween.EASE_OUT)

func rightarmslice_recall_right_arm_frame(lerp_val):
	right_arm.rotation_degrees = rotation_degrees + Vector3(-31.5, -45.8, 80.1)
	right_arm.global_position = right_arm.global_position.lerp(x_mesh_right_arm.global_position, lerp_val)

func strafeslice_recall_right_arm():
	if not right_arm_deployed():
		return
	right_arm.stop_firing_laser()
	var recall_tween = get_tree().create_tween()
	recall_tween.tween_method(strafeslice_recall_right_arm_frame, 0.0, 1.0, .25).set_ease(Tween.EASE_OUT)

func strafeslice_recall_right_arm_frame(lerp_val):
	right_arm.rotation_degrees = rotation_degrees + Vector3(0, 90, 0)
	right_arm.global_position = right_arm.global_position.lerp(x_mesh_right_arm.global_position, lerp_val)

func hide_floating_right_arm():
	right_arm.visible = false

func hide_rig_right_arm():
	x_meshes.set_surface_override_material(5, transparent_mat)

func restore_rig_right_arm():
	x_meshes.set_surface_override_material(5, body_mat)

func set_x_icon_my_pos():
	var lerp_tween = get_tree().create_tween()
	lerp_tween.tween_property(self, "x_icon_lerp_val", 1.0, .5).from_current()
	x_icon_pos_state = MY_POS

func set_x_icon_targetside_pos():
	# No need for lerp since it's not jumping directly to 1.0
	x_icon_lerp_val = .2
	x_icon_pos_state = TARGETSIDE_POS
	x_icon_tp_to_left = rng.randf() < .5

func set_x_icon_targetfront_pos():
	# No need for lerp since it's not jumping directly to 1.0
	x_icon_lerp_val = .2
	x_icon_pos_state = TARGETFRONT_POS

func set_x_icon_stationary():
	x_icon_pos_state = STATIONARY

func x_icon_follow_my_pos():
	x_icon_pos.global_position.x = global_position.x
	x_icon_pos.global_position.z = global_position.z
	x_icon.rotation.y = rotation.y

func x_icon_follow_targetside_pos():
	var dir_to_target := global_position.direction_to(target.global_position)
	var icon_vec := Vector2(dir_to_target.x, dir_to_target.z).orthogonal()
	if x_icon_tp_to_left:
		icon_vec *= -1
	x_icon_pos.global_position.x = target.global_position.x + side_teleport_dist_from_target * icon_vec.x
	x_icon_pos.global_position.z = target.global_position.z + side_teleport_dist_from_target * icon_vec.y

func x_icon_follow_targetfront_pos():
	var dir_to_target := global_position.direction_to(target.global_position)
	x_icon_pos.global_position.x = target.global_position.x - front_teleport_dist_from_target * dir_to_target.x
	x_icon_pos.global_position.z = target.global_position.z - front_teleport_dist_from_target * dir_to_target.z

func set_x_icon_flyingfacerain_pos():
	x_icon_lerp_val = .05
	x_icon_pos.global_position.x = 0
	x_icon_pos.global_position.z = -24
