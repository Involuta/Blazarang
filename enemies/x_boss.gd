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
@export var min_long_dist_wait := 1.0
@export var max_long_dist_wait := 2.0
var long_dist_wait_remaining := 5.0
var attack_queued := false
signal no_attack_queued

@export var min_y_pos := 11.4

@export var aggro_distance := -1

@export var follow_speed := 10.0
@export var follow_stop_dist := 2.5
@export var shortrange_attack_distance := 7.5

@export var attack_duration_secs := 2.5

@export var follow_turn_speed := .05
@export var attack_turn_speed := .15

var aiming_at_target := true
var dash_back_canceled := false
@export var bullet_speed := 30.0
@export var fast_bullet_speed := 50.0

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

@export var diagonal_dash_speed := 30.0
@export var dash_speed := 40.0
@export var dash_back_speed := 36.0
@export var side_teleport_dist_from_target := 7.5
@export var front_teleport_dist_from_target := 1.5
@export var slipnslice_speed := 20.0
@export var superman_fwd_speed := 20.0
@export var superman_up_speed := 5.0
@export var superman_down_speed := 7.0
@export var triangle_arm_angle := 36.0
@export var triangle_arm_dist := 90.0
@export var triangle_axkick_dist := 10.0
@export var flyingkick_speed := 200.0
@export var flyingkick_hit_frames := 10 # Put the # of frames that the hitbox is active in the animation here
@export var flying_facerain_piece_speed := 7.5
@export var flying_facerain_height := 20.0
@export var triangle_volcano_ascend_speed := 100.0
@export var armbombs_dashback_lateral_dist := 40.0
@export var armbombs_dashback_height := 20.0

var param_path_base := "parameters/StateMachine/conditions/"
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rng := RandomNumberGenerator.new()
var bullet := preload("res://enemies/enemy_mega_bullet.tscn")
var transparent_mat := preload("res://textures/clear_tile.tres")
var body_mat := preload("res://textures/x_boss_body.tres")
var left_head_piece := preload("res://enemies/x_left_head_piece_rb.tscn")
var right_head_piece := preload("res://enemies/x_right_head_piece_rb.tscn")
var top_head_piece := preload("res://enemies/x_top_head_piece_rb.tscn")
var bottom_head_piece := preload("res://enemies/x_bottom_head_piece_rb.tscn")
@onready var anim_tree := $AnimationTree
@onready var anim_player := $X_boss_meshes/AnimationPlayer
@onready var x_meshes := $X_boss_meshes/Armature/Skeleton3D/Body_001
@onready var x_mesh_head := $X_boss_meshes/Armature/Skeleton3D/Head/XHead
@onready var x_mesh_left_arm := $X_boss_meshes/Armature/Skeleton3D/LeftArm
@onready var x_mesh_right_arm := $X_boss_meshes/Armature/Skeleton3D/RightArm
@onready var level := $/root/Level
@onready var target := $/root/Level/Icon
@onready var left_arm := $/root/Level/XBossArena1/XLeftArm
@onready var right_arm := $/root/Level/XBossArena1/XRightArm
@onready var x_icon := $/root/Level/XBossArena1/XIcon
@onready var x_icon_pos := $/root/Level/XBossArena1/XIconPos

func _ready():
	add_to_group("lockonables")
	if aggro_distance > 0:
		behav_state = WAIT
	Globals.health_segment_lost.connect(on_health_segment_lost)
	anim_tree.active = true
	x_mesh_head.visible = true
	$X_boss_meshes/Armature/Skeleton3D/Head/GlowingHead.visible = false

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
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
	if global_position.distance_to(target.global_position) < follow_stop_dist:
		velocity.x = 0
		velocity.z = 0
		return
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
	var strafe_dest = target.global_position + 5*Vector3(icon_vec.x, 0, icon_vec.y)
	
	lerp_look_at_position(strafe_dest, follow_turn_speed)
	var move_dir = global_position.direction_to(strafe_dest)
	velocity.x = follow_speed / 2 * move_dir.x
	velocity.z = follow_speed / 2 * move_dir.z

func left_arm_deployed():
	return x_meshes.get_surface_override_material(2) != body_mat

func right_arm_deployed():
	return x_meshes.get_surface_override_material(5) != body_mat

func queue_attack(dist_type):
	attack_queued = true
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

func aim_at_target():
	aiming_at_target = true

func start_strafe():
	behav_state = STRAFE_FOLLOW
	strafing_left = rng.randf() < .5

func start_attack():
	# Without this await, the animation player would call end_attack at the end of the previous animation on the exact same frame as when the AnimationPlayer.play func is called below. Since an animation was currently in progress, the func call would do nothing, leaving the enemy in ATTACK mode but with no animation playing to free it from ATTACK mode, causing it to stand still indefinitely
	await get_tree().create_timer(get_process_delta_time()).timeout
	behav_state = ATTACK
	aiming_at_target = true

func end_attack():
	attack_queued = false
	no_attack_queued.emit()
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
	for attack in short_dist_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in long_dist_right_arm_deployed_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	for attack in long_dist_right_arm_not_deployed_attack_chances.keys():
		anim_tree.set(param_path_base + attack, false)
	long_dist_wait_remaining = rng.randf_range(0.1, min_long_dist_wait)
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
	left_arm.stop_firing_laser()
	right_arm.stop_firing_laser()
	var left_mvmt_tween = get_tree().create_tween()
	var right_mvmt_tween = get_tree().create_tween()
	var rotation_tween = get_tree().create_tween()
	rotation_tween.set_parallel()
	rotation_tween.tween_property(left_arm, "rotation_degrees", Vector3(63, -25, -164), .2)
	rotation_tween.tween_property(right_arm, "rotation_degrees", Vector3(63, 25, -164), .2)
	left_mvmt_tween.tween_property(left_arm, "global_position", global_position + Vector3(-.351, .436, -.252), .2)
	right_mvmt_tween.tween_property(right_arm, "global_position", global_position + Vector3(.351, .436, -.252), .2)
	left_mvmt_tween.tween_callback(hide_floating_left_arm)
	left_mvmt_tween.tween_callback(restore_rig_left_arm)
	right_mvmt_tween.tween_callback(hide_floating_right_arm)
	right_mvmt_tween.tween_callback(restore_rig_right_arm)

func triangle_shoot_arms():
	left_arm.rotation_degrees = (rotation_degrees.y + 180 + triangle_arm_angle) * Vector3.UP
	left_arm.visible = true
	var left_arm_tween = get_tree().create_tween()
	left_arm_tween.tween_callback(left_arm.stop_firing_laser)
	left_arm_tween.tween_property(left_arm, "global_position", triangle_arm_dist*left_arm.basis.z, .3).as_relative().from(global_position + Vector3(-.2, .2, 0))
	left_arm_tween.tween_property(left_arm, "rotation_degrees", Vector3.UP * -2 * triangle_arm_angle, .1).as_relative()
	left_arm_tween.tween_callback(left_arm.fire_laser)
	
	right_arm.rotation_degrees = (rotation_degrees.y - 180 - triangle_arm_angle) * Vector3.UP
	right_arm.visible = true
	var right_arm_tween = get_tree().create_tween()
	right_arm_tween.tween_callback(right_arm.stop_firing_laser)
	right_arm_tween.tween_property(right_arm, "global_position", triangle_arm_dist*right_arm.basis.z, .3).as_relative().from(global_position + Vector3(.2, .2, 0))
	right_arm_tween.tween_property(right_arm, "rotation_degrees", Vector3.UP * 2 * triangle_arm_angle, .1).as_relative()
	right_arm_tween.tween_callback(right_arm.fire_laser)

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
	# Without this line, X's fall protection (which sets his y vel to 0 when his global y is below the min) would prevent his y vel from changing
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
	var original_pos := global_position
	var dash_tween = get_tree().create_tween()
	dash_tween.tween_property(self, "global_position", Vector3(-armbombs_dashback_lateral_dist * dir_to_target.x, armbombs_dashback_height, -armbombs_dashback_lateral_dist * dir_to_target.z), .1).from(original_pos).as_relative().set_ease(Tween.EASE_IN)

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

func recall_right_arm():
	if not right_arm_deployed():
		return
	right_arm.stop_firing_laser()
	var recall_tween = get_tree().create_tween()
	recall_tween.tween_method(recall_right_arm_frame, 0.0, 1.0, .25).set_ease(Tween.EASE_OUT)

func recall_right_arm_frame(lerp_val):
	right_arm.rotation_degrees = rotation_degrees + Vector3(-31.5, -45.8, 80.1)
	right_arm.global_position = right_arm.global_position.lerp(x_mesh_right_arm.global_position, lerp_val)

func hide_floating_right_arm():
	right_arm.visible = false

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
