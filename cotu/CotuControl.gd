extends CharacterBody3D

var using_controller = false # only affects camera motion

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = default_gravity
const WALK_SPEED := 10.0
const STEP_DODGE_SPEED := 15.0
const step_dodge_duration_secs := .5
const step_dodge_cooldown_secs := .1
const JUMP_SPEED := 14.0
const MAX_JUMP_CHARGE_SECS := .5
# Seconds it takes for Cotu to decelerate to 0 speed when not walking
const WALK_DECEL_SECS := .25

var anim_tree_param_path_base := "parameters/StateMachine/conditions/"

var walk_input := Vector2.ZERO
var moving_right := true # Did the player last try to walk right?
var grounded_speed := 0.0
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

var max_cam_dist := 6.0 # dist btwn player and camera when camera's not colliding with geometry; player can modify this in-game

@export var max_slow_duration := 3.5
@export var max_infest_duration := 10.0
var active_debuffs = {
	Globals.DEBUFFS.SLOW: 0.0,
	Globals.DEBUFFS.INFEST: 0.0,
}

var rang_catch_input_buffer_secs := .2 # max possible time btwn player inputting throw and rang hitting Cotu that still causes an instant rethrow or catch. Also max possible time btwn player inputting special and the rang hitting Cotu that still causes a special

var can_throw_roserang := true
var roserang_throw_queued := false
enum ROSERANG_THROW_TYPES {
	ROSE,
	HOMING,
	POWER,
}
var roserang_throw_type := ROSERANG_THROW_TYPES.ROSE
var homing_targets_added := 0 # Increments for every homing buff applied
@export var roserang_buff_list := [Globals.ROSERANG_BUFFS.HOMING, Globals.ROSERANG_BUFFS.HOMING, Globals.ROSERANG_BUFFS.DAMAGE]
var next_roserang_buff_index := 0
var throw_roserang_self_damage := 18.0

var can_throw_axrang := true
var axrang_perfect_catch_queued := false
var axrang_perfect_caught := false
var axrang_buff_list := [Globals.AXRANG_BUFFS.DAMAGE, Globals.AXRANG_BUFFS.DAMAGE, Globals.AXRANG_BUFFS.DAMAGE]
var next_axrang_buff_index := 0
var throw_axrang_self_damage := 36.0

var rose_script := preload("res://rang/roserang.gd")
var homing_script := preload("res://rang/roserang_homing.gd")
var rapidorbit_script := preload("res://rang/special_rapidorbit.gd")
var special_homing_script := preload("res://rang/special_homing.gd")
var special_homing_explosive_script := preload("res://rang/special_explosive_homing.gd")
var current_roserang_special_script
var roserang_special_queued := false
var roserang_special_just_used := false # Used in instant rethrow code to know whether the IR is happening immediately after a special, in which case buffs should be reset. Set to true when special is used, set to false in IR code

var arc_slash_projectile := preload("res://rang/axrang_arc_slash.tscn")
var axrang_special_queued := false
var axrang_specials = [
	"AxOverhead",
	"AxArcSlash"
]
var current_axrang_special := "AxArcSlash"
@export var arc_slash_projectile_speed := 20.0
var axrang_special_just_used := false # Used by apply_buffs_to_axrang to know whether a perfect catch is happening immediately after a special, in which case buffs should be reset. Set to true when special is used, set to false in apply_buffs_to_axrang
var axrang_melee_hit := false # Set to false right before a special is used. Set to true by ax's hitbox if it hits something during a special
var axrang_special_hit_buff_saving := false # Set to true when player equips Redux, which temporarily keeps axrang buffs if the ax melee hits an enemy during an ax special
@export var axrang_special_buff_save_duration := 6.7
var axrang_special_buff_save_time_remaining := 0.0

var shuriken_scene := preload("res://rang/shuriken.tscn")
var shuriken_deploy_queued := false
@export var max_shurikens := 4
var shurikens := []
@export var throw_shuriken_self_damage := 1.0
var mid_stability_bonus_shurikens := true # Set to true when player equips Resolve, which immediately spawns and deploys 3 shurikens if the player's health is below 50% and deploys exactly 3 shurikens in a single icon hit

var mark_scene := preload("res://rang/mark.tscn")
var active_mark = null
var mark_shuriken_deploy := true # Set to true when player equips Restlessness, which allows them to deploy shurikens by marking an enemy

enum SHURIKEN_MARKLESS_MODE {
	NEAREST,
	HIGHEST_HP,
	LOWEST_HP
}
@export var shuriken_markless_behavior := SHURIKEN_MARKLESS_MODE.NEAREST

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
@onready var roserang_particles := $RoserangTinyParticles/GPUParticles3D
@onready var armature := $CotuAnims/Armature
@onready var anim_tree := $AnimationTree
@onready var hurtbox := $Hurtbox
@onready var axrang_melee_hitbox := $CotuAnims/Armature/AxrangPivot/Axrang/PlayerHitbox
@onready var axrang_overhead_explosion_hitbox := $CotuAnims/Armature/ExplosionPivot/PlayerHitbox

@onready var root := $/root/ViewControl
var level : Node3D
var icon: Node3D
var ui: Control

const LERP_VAL := .15 # The rate at which lerp funcs change; used for body mvmt animations

func _ready():
	level = root.find_child("Level")
	icon = level.find_child("Icon")
	ui = root.find_child("UIRoot")
	
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	current_roserang_special_script = rapidorbit_script
	current_axrang_special = "AxArcSlash"
	
	Globals.destabilize.connect(on_destabilize)
	Globals.stabilize.connect(on_stabilize)
	# This line fixes a bug that happens when X destroys Cotu with his grab punish (XBossGrab is true, but since Cotu was destroyed, he can't set XBossGrab to false; the grab release sets this bool to false). Then Cotu retries the fight. If X tries another DashGrab, he'll think he successfully grabbed Cotu even though he didn't bc XBossGrab is still true from last time
	Globals.XBossGrab = false
	
	anim_tree.active = true
	
	can_walk = true
	can_rotate = true
	can_dodge = true

	can_throw_roserang = true
	can_throw_axrang = true

func on_destabilize():
	destabilized = true

func on_stabilize():
	destabilized = false

func set_can_throw_weapons(state: bool):
	can_throw_roserang = state
	can_throw_axrang = state

func emit_stabilize():
	Globals.stabilize.emit()

func receive_debuff_slow():
	active_debuffs[Globals.DEBUFFS.SLOW] = max_slow_duration

func receive_debuff_infest():
	active_debuffs[Globals.DEBUFFS.INFEST] = max_infest_duration

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

var slow = false
func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		if slow:
			slow = false
			Engine.time_scale = 1
		else:
			slow = true
			Engine.time_scale = .1
	# Camera movement/orientation; ui_cancel means esc
	if Input.is_action_just_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	# Lock on logic; if target no longer exists, lock off
	if lock_on_target \
	and is_effectively_invalid(lock_on_target):
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
	
	if active_debuffs[Globals.DEBUFFS.SLOW] > 0:
		grounded_speed *= .5
		active_debuffs[Globals.DEBUFFS.SLOW] -= delta
	
	if active_debuffs[Globals.DEBUFFS.INFEST] > 0:
		active_debuffs[Globals.DEBUFFS.INFEST] -= delta
	
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
	
	# Rose pointer movement; this block must come before the roserang throw bc if you instantiate the rang, then try to look_at(it) on the same frame, look_at will fail
	# Also enable/disable roserang particles
	if roserang_instance != null:
		rang_pointer_pivot.look_at(roserang_instance.global_position)
		roserang_particles.global_position = roserang_instance.global_position
		if not roserang_particles.emitting:
			roserang_particles.emitting = true
	else:
		rang_pointer_pivot.transform.basis = camera_twist_pivot.transform.basis
		if roserang_particles.emitting:
			roserang_particles.emitting = false
	
	# Special rose throw (takes precedence over instant rethrow). Requires all buffs to be active
	var all_roserang_buffs_active := next_roserang_buff_index >= roserang_buff_list.size()
	if Input.is_action_just_pressed("Special") and not roserang_special_queued and all_roserang_buffs_active and roserang_instance != null:
		start_roserang_special_timer()
	if roserang_special_queued and roserang_instance == null:
		roserang_special_queued = false
		roserang_special_just_used = true
		throw_roserang_with_script(current_roserang_special_script)
	
	# Special ax throw
	var all_axrang_buffs_active := next_axrang_buff_index >= axrang_buff_list.size()
	if Input.is_action_just_pressed("Special") and not axrang_special_queued and all_axrang_buffs_active and axrang_instance != null:
		start_axrang_special_timer()
	# Why not check if axrang_special_queued and axrang_instance == null to call throw_special_axrang like rose? Because on_catch_axrang can be used instead
	# Redux ax buff expiration
	if axrang_special_buff_save_time_remaining > 0.0:
		axrang_special_buff_save_time_remaining -= delta
		if axrang_special_buff_save_time_remaining <= 0.0:
			# Timer just expired → clear buffs once
			clear_axrang_buffs()
	
	if Input.is_action_just_pressed("MeleeAxrang"):
		anim_tree.set(anim_tree_param_path_base + "melee_ax", true)
	else:
		anim_tree.set(anim_tree_param_path_base + "melee_ax", false)
	
	# Axrang throw
	if Input.is_action_just_pressed("ThrowAxrang"):
		if axrang_instance == null and can_throw_axrang:
			# Throw
			if not destabilized and not axrang_perfect_caught:
				hurtbox.self_hit(throw_axrang_self_damage)
			Globals.cotu_throw_ax.emit()
			throw_axrang()
		elif axrang_instance != null and not axrang_instance.is_returning():
			axrang_instance.advance_state()
		elif axrang_instance != null and axrang_instance.is_returning():
			start_axrang_perfect_catch_timer()
	
	# Roserang throw
	if Input.is_action_just_pressed("ThrowRoserang"):
		if roserang_instance == null and can_throw_roserang:
			# Normal throw
			roserang_special_just_used = false
			if not destabilized:
				hurtbox.self_hit(throw_roserang_self_damage)
			Globals.cotu_normal_throw_rose.emit()
			throw_roserang_with_script(rose_script)
		elif not roserang_throw_queued:
			start_roserang_instant_rethrow_timer()
	if roserang_throw_queued and roserang_instance == null and can_throw_roserang:
		# Instant rethrow
		roserang_throw_queued = false
		
		# If you're instant rethrowing after a roserang special was just used, clear roserang buffs
		if roserang_special_just_used:
			roserang_special_just_used = false
			clear_roserang_buffs()
		
		Globals.cotu_instant_rethrow_rose.emit()
		anim_tree.set(anim_tree_param_path_base + "just_instant_rethrew", true)
		
		# Set throw type
		homing_targets_added = roserang_buff_list.slice(0, next_roserang_buff_index).count(Globals.ROSERANG_BUFFS.HOMING)
		if homing_targets_added > 0:
			roserang_throw_type = ROSERANG_THROW_TYPES.HOMING
		else:
			roserang_throw_type = ROSERANG_THROW_TYPES.ROSE
		
		match(roserang_throw_type):
			ROSERANG_THROW_TYPES.ROSE:
				throw_roserang_with_script(rose_script)
			ROSERANG_THROW_TYPES.HOMING:
				throw_roserang_with_script(homing_script)
		
		Globals.award_score(Globals.INSTANT_RETHROW_SCORE)
	else:
		anim_tree.set(anim_tree_param_path_base + "just_instant_rethrew", false)
	# Clear roserang buffs (and make target/Icon follow Cotu again) if an instant rethrow didn't just occur (i.e. if roserang_instance is still null after an instant rethrow would have reassigned it)
	if roserang_instance == null:
		icon.start_following_cotu()
		clear_roserang_buffs()
	
	# Shuriken throw
	if Input.is_action_just_pressed("ThrowShuriken"):
		if shurikens.size() < max_shurikens:
			if not destabilized and not axrang_perfect_caught:
				hurtbox.self_hit(throw_shuriken_self_damage)
			var s = shuriken_scene.instantiate()
			add_sibling(s)
			shurikens.append(s)
	
	if Input.is_action_just_pressed("UseItem"):
		anim_tree.set(anim_tree_param_path_base + "use_item", true)
	else:
		anim_tree.set(anim_tree_param_path_base + "use_item", false)
	
	if Input.is_action_just_pressed("PlaceMark"):
		if active_mark:
			active_mark.queue_free()
		var m = mark_scene.instantiate()
		add_sibling(m)
		if m.try_place_from_camera(camera):
			active_mark = m
			m.mark_applied.connect(_on_mark_applied)
			m.mark_removed.connect(_on_mark_removed)
		else:
			m.queue_free()
		# If mark shuriken deploy is unlocked, then when mark is placed, deploy shurikens
		if mark_shuriken_deploy:
			deploy_shurikens()
	
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
	Globals.cotu_dodge.emit()
	can_dodge = false
	set_can_throw_weapons(false)
	is_dodging = true
	if not destabilized:
		hurtbox.self_hit(dodge_self_damage)
	set_collision_mask_value(Globals.ENEMY_COL_LAYER, false)
	if roserang_instance != null:
		icon.stop_following_cotu()
	await get_tree().create_timer(step_dodge_duration_secs).timeout
	is_dodging = false
	set_collision_mask_value(Globals.ENEMY_COL_LAYER, true)
	await get_tree().create_timer(step_dodge_cooldown_secs).timeout
	can_dodge = true
	set_can_throw_weapons(true)

func throw_roserang_with_script(script):
	roserang_special_queued = false
	roserang_instance = roserang.instantiate()
	add_sibling(roserang_instance)
	roserang_instance.set_script(script)
	apply_buffs_to_roserang_instance()

func start_roserang_instant_rethrow_timer():
	roserang_throw_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	roserang_throw_queued = false

func add_roserang_buff(): # Called by icon when roserang hits it
	if next_roserang_buff_index < roserang_buff_list.size():
		next_roserang_buff_index += 1

func apply_buffs_to_roserang_instance():	
	if next_roserang_buff_index <= 0 and not ui.roserang_buffs_cleared():
		ui.clear_roserang_buffs()
	# Apply buffs to the roserang instance and UI simultaneously
	for i in range(next_roserang_buff_index):
		ui.apply_roserang_buff(i)
		match(roserang_buff_list[i]):
			Globals.ROSERANG_BUFFS.DAMAGE:
				roserang_instance.buff_damage()
			Globals.ROSERANG_BUFFS.HOMING:
				roserang_instance.buff_homing_targets(homing_targets_added)

func clear_roserang_buffs():
	next_roserang_buff_index = 0
	if not ui.roserang_buffs_cleared():
		ui.clear_roserang_buffs()

func start_roserang_special_timer():
	roserang_special_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	roserang_special_queued = false

func on_catch_axrang():
	# If player inputted special right before catching ax, use special axrang and don't clear buffs until the special finishes
	if axrang_special_queued:
		axrang_special_queued = false
		throw_special_axrang()
	elif axrang_perfect_catch_queued:
		# Perfect catch
		axrang_perfect_catch_queued = false
		axrang_perfect_caught = true
		# If you caught the axrang after it came back from using a special (in which it was thrown, of course), clear the buffs. Why not just check axrang_special_just_used in the outer if statement since the else block also clears buffs? We need axrang perfect caught to be true if it was perfectly caught, since perfect catching ax has some benefits, e.g. instant ax throw anim
		if axrang_special_just_used:
			axrang_special_just_used = false
			clear_axrang_buffs()
			return
		add_axrang_buff()
		# Apply buffs visually in the UI, but not the ax itself because the ax instance doesn't exist yet (catching the axrang sets axrang_instance to null)
		for i in range(next_axrang_buff_index):
			match(axrang_buff_list[i]):
				Globals.AXRANG_BUFFS.DAMAGE:
					ui.apply_axrang_buff(i)
	else:
		# Clear axrang buffs if axrang wasn't perfect caught or player isn't using special
		clear_axrang_buffs()

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
	if next_axrang_buff_index <= 0 and not ui.axrang_buffs_cleared():
		ui.clear_axrang_buffs()
	# Apply buffs to the ax instance itself, but not the UI because the buffs were already applied in the UI in the previous perfect catch
	for i in range(next_axrang_buff_index):
		match(axrang_buff_list[i]):
			Globals.AXRANG_BUFFS.DAMAGE:
				axrang_instance.buff_damage()

func throw_special_axrang():
	axrang_special_just_used = true
	anim_tree.set(anim_tree_param_path_base + current_axrang_special, true)

func start_axrang_special_timer():
	axrang_special_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	axrang_special_queued = false

func reset_axrang_melee_hit():
	# Reset whether axrang melee hit or not. Called on the first keyframe of every axrang special anim
	axrang_melee_hit = false

func _on_axrang_melee_hit(_body):
	# Called every time axrang hits something (it can only detect collisions with enemies)
	axrang_melee_hit = true

func clear_or_save_axrang_buffs():
	# If Redux isn't unlocked, or special didn't hit anything, clear buffs immediately
	if not axrang_special_hit_buff_saving or not axrang_melee_hit:
		clear_axrang_buffs()
		return
	
	# Redux is active and special hit → preserve buffs temporarily
	axrang_special_buff_save_time_remaining = axrang_special_buff_save_duration

func clear_axrang_buffs():
	axrang_perfect_caught = false
	next_axrang_buff_index = 0
	if not ui.axrang_buffs_cleared():
		ui.clear_axrang_buffs()

func end_attack():
	anim_tree.set(anim_tree_param_path_base + "AxOverhead", false)
	anim_tree.set(anim_tree_param_path_base + "AxArcSlash", false)

func shoot_arc_projectile():
	var arc_inst = arc_slash_projectile.instantiate()
	level.add_child.call_deferred(arc_inst)
	await arc_inst.tree_entered
	arc_inst.global_position = global_position
	arc_inst.velocity = arc_slash_projectile_speed * armature.transform.basis.z
	arc_inst.rotation.y = PI + armature.rotation.y

func get_nearest_target(targets: Array, origin: Vector3) -> Node3D:
	var best_target: Node3D = null
	var best_dist := INF

	for t in targets:
		# Skip targets that are invalid OR have processing disabled
		if is_effectively_invalid(t):
			continue

		var d = origin.distance_to(t.global_position)
		if d < best_dist:
			best_dist = d
			best_target = t

	return best_target

func get_highest_health_target(targets: Array) -> Node3D:
	var best_target: Node3D = null
	var best_hp := -INF

	for t in targets:
		# Skip targets that are invalid OR have processing disabled
		if is_effectively_invalid(t):
			continue
		
		# To do: verify that all enemies have a hurtbox reference
		if t.hurtbox.health > best_hp:
			best_hp = t.health
			best_target = t

	return best_target

func get_lowest_health_target(targets: Array) -> Node3D:
	var best_target: Node3D = null
	var best_hp := INF

	for t in targets:
		# Skip targets that are invalid OR have processing disabled
		if is_effectively_invalid(t):
			continue
		
		# To do: verify that all enemies have a hurtbox reference
		if t.hurtbox.health < best_hp:
			best_hp = t.health
			best_target = t

	return best_target

func get_shuriken_target() -> Node3D:
	if active_mark:
		return active_mark
	
	var targets = level.get_tree().get_nodes_in_group("lockonables")
	if targets.is_empty():
		return null
	
	match shuriken_markless_behavior:
		SHURIKEN_MARKLESS_MODE.NEAREST:
			return get_nearest_target(targets, global_position)
		SHURIKEN_MARKLESS_MODE.HIGHEST_HP:
			return get_highest_health_target(targets)
		SHURIKEN_MARKLESS_MODE.LOWEST_HP:
			return get_lowest_health_target(targets)
	
	return null

func deploy_shurikens():
	if len(shurikens) == 0:
		return
	
	var target := get_shuriken_target()
	if target == null:
		return
	
	# Resolve/Thrill skills logic start
	if shurikens.size() == 3:
		if mid_stability_bonus_shurikens and hurtbox.health < (hurtbox.max_health * 0.5):
			# Spawn 3 bonus shurikens
			for i in range(3):
				await get_tree().create_timer(.5).timeout
				var bonus_s = shuriken_scene.instantiate()
				add_sibling(bonus_s)
				# Immediately deploy them to the target
				bonus_s.deploy_to_target(target)
				shurikens.append(bonus_s)
	# Resolve/Thrill skills logic end

	for s in shurikens:
		s.deploy_to_target(target)

func is_effectively_invalid(n: Node) -> bool:
	return not is_instance_valid(n) or n.process_mode == Node.PROCESS_MODE_DISABLED

func _on_mark_applied(target):
	active_mark = target

func _on_mark_removed():
	active_mark = null

# Used by roserang.gd to get Cotu's rang throw angle (the angle input of the rose equation)
func get_rang_throw_y_angle():
	return camera_twist_pivot.basis.get_euler().y

# Used by X to get Cotu's rang throw direction
func get_camera_fwd_dir():
	return -camera_twist_pivot.global_transform.basis.z

# Used by Jumping Spider to get Cotu's fwd facing direction
func get_fwd_dir():
	return armature.transform.basis.z
