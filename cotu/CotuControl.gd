extends CharacterBody3D

var using_controller = false # only affects camera motion

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = default_gravity
const WALK_SPEED := 10
const STEP_DODGE_SPEED := 15
const STEP_DODGE_DURATION_SECS := .5
const STEP_DODGE_COOLDOWN_SECS := .1
const JUMP_SPEED := 14.0
const MAX_JUMP_CHARGE_SECS := .5
# Seconds it takes for Cotu to decelerate to 0 speed when not walking
const WALK_DECEL_SECS := .25

var anim_tree_param_path_base := "parameters/StateMachine/conditions/"

var walk_input := Vector2.ZERO
var moving_right := true # Did the player last try to walk right?
var grounded_speed := 0
@export var can_walk := true # Exported so it can be set via anim
@export var can_rotate := true # Exported so it can be set via anim
var can_dodge := true
var is_dodging := false
var dodge_self_damage := 18.0

var mouse_camera_sensitivity := .001
var joystick_camera_sensitivity := .1
var camera_pitch_limit_deg := 90
var camera_twist_input := .0
var camera_pitch_input := .0
var locked_on := false
var lock_on_target = null

var look_angle := 0.0
var look_angle2 := 0.0
var max_cam_dist := 6.0 # dist btwn player and camera when camera's not colliding with geometry; player can modify this in-game

var rang_catch_input_buffer_secs := .2 # max possible time btwn player inputting throw and rang hitting Cotu that still causes an instant rethrow or catch. Also max possible time btwn player inputting special and the rang hitting Cotu that still causes a special

var can_throw_roserang := true
var roserang_throw_queued := false
var roserang_buff_list := [Globals.BUFFS.DAMAGE, Globals.BUFFS.DAMAGE, Globals.BUFFS.DAMAGE]
var next_roserang_buff_index := 0
var throw_roserang_self_damage := 18.0

var can_throw_axrang := true
var axrang_perfect_catch_queued := false
var axrang_perfect_caught := false
var axrang_buff_list := [Globals.BUFFS.DAMAGE, Globals.BUFFS.DAMAGE, Globals.BUFFS.DAMAGE]
var next_axrang_buff_index := 0
var throw_axrang_self_damage := 36.0

var rapidorbit_script := preload("res://rang/special_rapidorbit.gd")
var homing_script := preload("res://rang/special_homing.gd")
var current_roserang_special_script
var roserang_special_queued := false

var axrang_special_queued := false
var axrang_specials = [
	"AxOverhead",
	"AxArcSlash"
]
var current_axrang_special := "AxOverhead"
@export var arc_slash_projectile_speed := 20.0

var destabilized := false
var grabbed := false
var stunned := false
var grab_pos_node : Node3D

var roserang := preload("res://rang/roserang.tscn")
var roserang_instance = null
var axrang := preload("res://rang/axrang.tscn")
var axrang_instance = null
@onready var physical_collider := $CollisionShape3D
@onready var camera_twist_pivot := $CameraTwistPivot
@onready var camera_pitch_pivot := $CameraTwistPivot/CameraPitchPivot
@onready var camera := $CameraTwistPivot/CameraPitchPivot/CameraVisualObject
@onready var rang_pointer_pivot := $RangPointerPivot
@onready var armature := $CotuAnims/Armature
@onready var anim_tree := $AnimationTree
@onready var hurtbox := $Hurtbox
@onready var axrang_melee_hitbox := $CotuAnims/Armature/AxrangPivot/Axrang/PlayerHitbox
@onready var axrang_overhead_explosion_hitbox := $CotuAnims/Armature/ExplosionPivot/PlayerHitbox

@onready var root := $/root/ViewControl
var level : Node3D
var target: Node3D
var ui: Control

const LERP_VAL := .15 # The rate at which lerp funcs change; used for body mvmt animations

func _ready():
	level = root.find_child("Level")
	target = level.find_child("Icon")
	ui = root.find_child("UIRoot")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	current_roserang_special_script = rapidorbit_script
	current_axrang_special = "AxArcSlash"
	
	Globals.destabilize.connect(on_destabilize)
	Globals.stabilize.connect(on_stabilize)
	# This line fixes a bug that happens when X destroys Cotu with his grab punish (XBossGrab is true, but since Cotu was destroyed, he can't be released from the grab; the grab release sets this bool to false). Then Cotu retries the fight. If X tries another DashGrab, he'll think he successfully grabbed Cotu even though he didn't bc XBossGrab is still true from last time
	Globals.XBossGrab = false
	
	anim_tree.active = true
	
	can_walk = true
	can_rotate = true
	can_dodge = true

func on_destabilize():
	destabilized = true

func on_stabilize():
	destabilized = false

func emit_stabilize():
	Globals.stabilize.emit()

func change_max_cam_dist_over_secs(new_max_cam_dist: float, duration: float):
	# This needs to be a tween instead of keyframes bc modifying max_cam_dist via keyframes will cause the property to be reset to 0 whenever there aren't any keyframes for it. You'd then need to put at least 1 keyframe for this property for every single anim
	var cam_tween := get_tree().create_tween()
	cam_tween.tween_property(self, "max_cam_dist", new_max_cam_dist, duration)

func release_from_grab():
	grabbed = false
	armature.visible = true
	Globals.XBossGrab = false
	anim_tree.set(anim_tree_param_path_base + "XBossGrab", false)

func stop_mvmt():
	velocity = Vector3.ZERO

func stun():
	stunned = true

func end_stun():
	stunned = false

func start_grab_anim(hitbox_name):
	grabbed = true
	armature.visible = false
	match(hitbox_name):
		"XBossGrab":
			Globals.XBossGrab = true
			anim_tree.set(anim_tree_param_path_base + "XBossGrab", true)
		_:
			print("Error in CotuControl: hitbox name from CotuHurtbox not found")

func _physics_process(delta):
	# Set look angle
	look_angle = camera_twist_pivot.basis.get_euler().y
	
	# Camera movement/orientation; ui_cancel means esc
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Lock on logic; if target no longer exists, lock off
	if !lock_on_target:
		lock_off()
	if using_controller:
		camera_twist_input = Input.get_axis("LookRight", "LookLeft") * joystick_camera_sensitivity
		camera_pitch_input = Input.get_axis("LookUp", "LookDown") * joystick_camera_sensitivity
	if locked_on:
		camera_twist_pivot.look_at(lock_on_target.global_position + 2*Vector3.DOWN)
	else:
		camera_twist_pivot.rotate_y(camera_twist_input)
	# While locked on, you can look up and down, but not left and right
	camera_pitch_pivot.rotate_x(camera_pitch_input)
	camera_pitch_pivot.rotation.x = clamp(
		camera_pitch_pivot.rotation.x,
		deg_to_rad(-camera_pitch_limit_deg),
		deg_to_rad(camera_pitch_limit_deg))
	# These 2 lines prevent the camera from continuing to move in the last direction the mouse was moved in
	camera_twist_input = 0
	camera_pitch_input = 0
	
	# Send updates to background camera
	Globals.cam_pos_updated.emit(global_position)
	Globals.cam_rot_updated.emit(camera_twist_pivot.rotation + camera_pitch_pivot.rotation)
	
	# Camera positioning based on level geometry
	place_camera()
	
	# Grabbed logic
	if grabbed:
		global_position = grab_pos_node.global_position - .5 * Vector3.UP
		return
	
	# Falling
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Stunned logic
	if stunned:
		move_and_slide()
		return
	
	# Dodge logic
	if Input.is_action_just_pressed("StepDodge") and can_dodge:
		anim_tree.set(anim_tree_param_path_base + "just_dodged", true)
		step_dodge()
	else:
		anim_tree.set(anim_tree_param_path_base + "just_dodged", false)
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_SPEED
		
	if is_dodging:
		grounded_speed = STEP_DODGE_SPEED
	else:
		grounded_speed = WALK_SPEED
	
	# Cotu movement
	walk_input = Input.get_vector("WalkLeft", "WalkRight", "WalkForward", "WalkBackward")
	if walk_input.x != 0:
		moving_right = walk_input.x > 0
	var mvmt_dir = Vector3(walk_input.x, 0, walk_input.y)
	var oriented_mvmt_dir = (camera_twist_pivot.basis * mvmt_dir).normalized()
	if oriented_mvmt_dir:
		if can_walk:
			velocity.x = lerp(velocity.x, oriented_mvmt_dir.x * grounded_speed, LERP_VAL)
			velocity.z = lerp(velocity.z, oriented_mvmt_dir.z * grounded_speed, LERP_VAL)
		if can_rotate:
			if is_on_floor():
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(oriented_mvmt_dir.x, oriented_mvmt_dir.z), LERP_VAL)
			else:
				armature.rotation.y = lerp_angle(armature.rotation.y, atan2(oriented_mvmt_dir.x, oriented_mvmt_dir.z), LERP_VAL / 5)
	if not oriented_mvmt_dir or not can_walk:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	move_and_slide()
	
	# Recovery rate
	hurtbox.set_fast_recovery_rate(walk_input == Vector2.ZERO and is_on_floor())
	
	# Rang Pointer movement; this block must come before the roserang throw bc if you instantiate the rang, then try to look_at(it) on the same frame, look_at will fail
	if roserang_instance != null:
		rang_pointer_pivot.look_at(roserang_instance.global_position)
	else:
		rang_pointer_pivot.transform.basis = camera_twist_pivot.transform.basis
	
	# Special throw (takes precedence over instant rethrow)
	if Input.is_action_just_pressed("Special") and not roserang_special_queued and roserang_instance != null:
		start_roserang_special_timer()
	if roserang_special_queued and roserang_instance == null:
		throw_special_roserang()
	
	if Input.is_action_just_pressed("Special") and not axrang_special_queued and axrang_instance != null:
		start_axrang_special_timer()
	if axrang_special_queued and axrang_instance == null:
		throw_special_axrang()
	
	if Input.is_action_just_pressed("MeleeAxrang"):
		anim_tree.set(anim_tree_param_path_base + "melee_ax", true)
	else:
		anim_tree.set(anim_tree_param_path_base + "melee_ax", false)
	
	if Input.is_action_just_pressed("ThrowAxrang"):
		if axrang_instance == null and can_throw_axrang:
			# Throw
			if not destabilized and not axrang_perfect_caught:
				hurtbox.self_hit(throw_axrang_self_damage)
			throw_axrang()
		elif axrang_instance != null and not axrang_instance.is_returning():
			axrang_instance.advance_state()
		elif axrang_instance != null and axrang_instance.is_returning():
			start_axrang_perfect_catch_timer()
	
	# Roserang throw
	if Input.is_action_just_pressed("ThrowRoserang"):
		if roserang_instance == null and can_throw_roserang:
			# Manual throw
			if not destabilized:
				hurtbox.self_hit(throw_roserang_self_damage)
			throw_roserang()
		elif not roserang_throw_queued:
			start_roserang_instant_rethrow_timer()
	if roserang_throw_queued and roserang_instance == null and can_throw_roserang:
		# Instant rethrow
		anim_tree.set(anim_tree_param_path_base + "just_instant_rethrew", true)
		roserang_throw_queued = false
		throw_roserang()
		Globals.award_score(Globals.INSTANT_RETHROW_SCORE)
	else:
		anim_tree.set(anim_tree_param_path_base + "just_instant_rethrew", false)
	# Clear roserang buffs (and make target/Icon follow Cotu again) if an instant rethrow didn't just occur (i.e. if roserang_instance is still null after an instant rethrow would have reassigned it)
	if roserang_instance == null:
		target.start_following_cotu()
		next_roserang_buff_index = 0
		if not ui.roserang_buffs_cleared():
			ui.clear_roserang_buffs()
	
	if Input.is_action_just_pressed("UseItem"):
		anim_tree.set(anim_tree_param_path_base + "use_item", true)
	else:
		anim_tree.set(anim_tree_param_path_base + "use_item", false)
	
	# Animation tree parameters
	var vel2D = Vector2(velocity.x, velocity.z)
	var move_blend_space := Vector2(vel2D.length(), 0)
	anim_tree.set("parameters/StateMachine/GroundBlendSpace/blend_position", move_blend_space)
	anim_tree.set("parameters/StateMachine/AerialBlendSpace/blend_position", Vector3.UP*velocity.y)

func _unhandled_input(event: InputEvent) -> void:
	if not using_controller:
		if event is InputEventMouseMotion:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				camera_twist_input = -event.relative.x * mouse_camera_sensitivity
				camera_pitch_input = -event.relative.y * mouse_camera_sensitivity

func place_camera():
	var space_state := get_world_3d().direct_space_state
	var cam_dir_basis = camera_twist_pivot.transform.basis * camera_pitch_pivot.transform.basis
	var cam_dir_vec = cam_dir_basis * Vector3.FORWARD
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position - (max_cam_dist * cam_dir_vec))
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if result:
		camera.position = Vector3.ZERO
		# Make the camera move slightly closer to Cotu after going to the raycast hit to prevent the camera from seeing below the floor
		camera.global_position = result.position + .2 * result.position.direction_to(global_position)
	else:
		camera.position = Vector3.BACK * max_cam_dist

func lock_on(node):
	locked_on = true
	lock_on_target = node

func lock_off():
	locked_on = false

func step_dodge():
	can_dodge = false
	can_throw_roserang = false
	can_throw_axrang = false
	is_dodging = true
	if not destabilized:
		hurtbox.self_hit(dodge_self_damage)
	set_collision_mask_value(Globals.ENEMY_COL_LAYER, false)
	if roserang_instance != null:
		target.stop_following_cotu()
	await get_tree().create_timer(STEP_DODGE_DURATION_SECS).timeout
	is_dodging = false
	set_collision_mask_value(Globals.ENEMY_COL_LAYER, true)
	await get_tree().create_timer(STEP_DODGE_COOLDOWN_SECS).timeout
	can_dodge = true
	can_throw_roserang = true
	can_throw_axrang = true

func throw_roserang():
	roserang_instance = roserang.instantiate()
	add_sibling(roserang_instance)
	apply_buffs_to_roserang_instance()

func start_roserang_instant_rethrow_timer():
	roserang_throw_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	roserang_throw_queued = false

func add_roserang_buff(): # Called by target/Icon when roserang hits it
	if next_roserang_buff_index < roserang_buff_list.size():
		next_roserang_buff_index += 1

func apply_buffs_to_roserang_instance():
	if next_roserang_buff_index <= 0 and not ui.roserang_buffs_cleared():
		ui.clear_roserang_buffs()
	# Apply buffs to the roserang instance and UI simultaneously
	for i in range(next_roserang_buff_index):
		match(roserang_buff_list[i]):
			Globals.BUFFS.DAMAGE:
				roserang_instance.buff_damage()
				ui.apply_roserang_buff1()

func throw_special_roserang():
	roserang_instance = roserang.instantiate()
	add_sibling(roserang_instance)
	roserang_instance.set_script(current_roserang_special_script)
	apply_buffs_to_roserang_instance()

func start_roserang_special_timer():
	roserang_special_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	roserang_special_queued = false

func on_catch_axrang():
	if axrang_perfect_catch_queued:
		# Perfect catch
		axrang_perfect_catch_queued = false
		axrang_perfect_caught = true
		add_axrang_buff()
		# Apply buffs visually in the UI, but not the ax itself because the ax instance doesn't exist yet (catching the axrang sets axrang_instance to null)
		for i in range(next_axrang_buff_index):
			match(axrang_buff_list[i]):
				Globals.BUFFS.DAMAGE:
					ui.apply_axrang_buff1()
	else:
		# Clear axrang buffs if axrang wasn't perfect caught
		axrang_perfect_caught = false
		next_axrang_buff_index = 0
		if not ui.axrang_buffs_cleared():
			ui.clear_axrang_buffs()

func throw_axrang():
	axrang_instance = axrang.instantiate()
	add_sibling(axrang_instance)
	apply_buffs_to_axrang_instance()
	axrang_instance.caught.connect(on_catch_axrang)

func start_axrang_perfect_catch_timer():
	axrang_perfect_catch_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	axrang_perfect_catch_queued = false

func add_axrang_buff(): # Called by Cotu when he catches the axrang
	if next_axrang_buff_index < axrang_buff_list.size():
		next_axrang_buff_index += 1

func apply_buffs_to_axrang_instance():
	# Apply buffs to the ax instance itself, but not the UI because the buffs were already applied in the UI in the previous perfect catch
	for i in range(next_axrang_buff_index):
		match(axrang_buff_list[i]):
			Globals.BUFFS.DAMAGE:
				axrang_instance.buff_damage()

func throw_special_axrang():
	anim_tree.set(anim_tree_param_path_base + current_axrang_special, true)

func start_axrang_special_timer():
	axrang_special_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	axrang_special_queued = false

func end_attack():
	anim_tree.set(anim_tree_param_path_base + "AxOverhead", false)
	anim_tree.set(anim_tree_param_path_base + "AxArcSlash", false)

func shoot_arc_projectile():
	var arc_file := load("res://rang/axrang_arc_slash.tscn")
	var arc_inst = arc_file.instantiate()
	level.add_child.call_deferred(arc_inst)
	await arc_inst.tree_entered
	arc_inst.global_position = global_position
	arc_inst.velocity = arc_slash_projectile_speed * armature.transform.basis.z
	arc_inst.rotation.y = PI + armature.rotation.y
