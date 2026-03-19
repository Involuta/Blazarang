extends CharacterBody3D

var using_controller = false # only affects camera motion

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity = default_gravity
var walk_speed := 10.0
const WALK_DECEL_SECS := .25 # Seconds it takes for Cotu to decelerate to 0 speed when not walking
const STEP_DODGE_SPEED := 15.0
const step_dodge_duration_secs := .5
const step_dodge_cooldown_secs := .1

# Hoverboard constants
const HOVERBOARD_SPEED := 15.0 # Faster than walk speed
const HOVERBOARD_ASCENT_SPEED := 8.0
const HOVERBOARD_DESCENT_SPEED := 8.0

var super_jump_charge_time := 0.0 # Time passed in the current jump charge
@export var super_jump_min_charge_time := .1
@export var super_jump_full_charge_time := 1.0
var super_jump_fully_charged := false
@export var super_jump_speed := 18.0 # Higher than JUMP_SPEED for that "Super" feel

var anim_tree_param_path_base := "parameters/StateMachine/conditions/"

# True when Cotu is doing any animation EXCEPT instant rethrow
var busy := false

var walk_input := Vector2.ZERO
var moving_right := true # Did the player last try to walk right?
var grounded_speed := 0.0
@export var can_walk := true # Exported so it can be set via anim
@export var can_rotate := true # Exported so it can be set via anim
var is_dodging := false
var dodge_self_damage := 18.0
var dodge_held := false # Tracks if dodge button is held during dodge
var is_hoverboarding := false

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
@export var infest_stability_regen_reduction := .33
var active_debuffs = {
	Globals.DEBUFFS.SLOW: 0.0,
	Globals.DEBUFFS.INFEST: 0.0,
}

@export var rang_catch_input_buffer_secs := .2 # max possible time btwn player inputting throw and rang hitting Cotu that still causes an instant rethrow or catch. Also max possible time btwn player inputting special and the rang hitting Cotu that still causes a special

var roserang_instant_rethrow_queued := false
enum ROSERANG_THROW_TYPES {
	ROSE,
	HOMING,
	POWER,
}
var roserang_throw_type := ROSERANG_THROW_TYPES.ROSE
var homing_targets_added := 0 # Increments for every homing buff applied
# Buff list is in Globals
var next_roserang_buff_index := 0
var normal_throw_roserang_self_damage := 18.0
var power_throw_roserang_self_damage := 24.0
@export var roserang_power_throw_min_charge_time := 0.25
@export var roserang_power_throw_max_charge_time := 0.75
var roserang_power_throw_charge_time := 0.0

var axrang_dodge_rethrow_queued := false
var axrang_perfect_catch_queued := false
var axrang_perfect_caught := false
var axrang_buff_list := [Globals.AXRANG_BUFFS.DAMAGE, Globals.AXRANG_BUFFS.SPEED, Globals.AXRANG_BUFFS.SPEED]
var next_axrang_buff_index := 0
@export var axrang_buff_decay_interval := 4.0 # Seconds between losing buffs
var axrang_buff_decay_timer := 0.0
var throw_axrang_self_damage := 36.0

var rose_script := preload("res://rang/roserang.gd")
var rose_power_throw_script := preload("res://rang/roserang_power.gd")
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
var axrang_special_hit_buff_saving := false # Set to true when player equips skill which temporarily keeps axrang buffs if the ax melee hits an enemy during an ax special (Redux)
@export var axrang_special_buff_save_duration := 6.7
var axrang_special_buff_save_time_remaining := 0.0

var axrang_hit_buffs_other_rangs_damage := true # Set to true when player equips skill where, when the ax hits an enemy, it activates a temporary buff that causes other rangs to deal significantly more damage. Buff wears off after a bit if ax doesn't hit an enemy again (Euphoria (?))
var axrang_hit_buffs_other_rangs_damage_time_remaining := 0.0 # Buff is considered active if time_remaining > 0, inactive otherwise
@export var axrang_hit_buffs_other_rangs_damage_duration := 3.0
@export var axrang_hit_buffs_other_rangs_damage_multiplier := .4 # +40% damage

var shuriken_scene := preload("res://rang/shuriken.tscn")
var shuriken_deploy_queued := false
@export var max_shurikens := 4
var shurikens := []
@export var throw_shuriken_self_damage := 1.0
var mid_stability_bonus_shurikens := true # Set to true when player equips Resolve, which immediately spawns and deploys 3 shurikens if the player's health is below 50% and deploys exactly 3 shurikens in a single icon hit
var fireball_scene := preload("res://rang/fireball.tscn")
var low_stability_fireball := true # Set to true when player equips Thrill, which immediately spawns and deploys a fireball if the player's health is below 25% and deploys exactly 3 shurikens in a single icon hit
var shuriken_base_slashes := 3 # Number of times shuriken will slash its target after reaching it
var shuriken_marked_bonus_slashes := 6 # When player equips Hunger, shurikens will slash a marked target this number of extra times. Unlike other equippable skills/perks, this one isn't a bool; it's a number. The skill is inactive if the number is 0 and active if it's ≥ 0
var shuriken_self_destruction := true # True = Explode, False = Recall

var mark_scene := preload("res://rang/mark.tscn")
var active_mark = null
var mark_shuriken_deploy := true # Set to true when player equips Restlessness, which allows them to deploy shurikens by marking an enemy
var mark_detonation := true # Set to true if "Sacrifice" ability is unlocked, which allows the player to detonate the mark, disabling it for the rest of the level
var mark_destroyed := false # Runtime: Becomes true when detonated, resets on level restart

# Synergy buffs
var rang_mvmt_buff_preservation := true # Set to true when player equips skill where catching one weapon while the other is moving preserves buffs (Mutuality)
var roserang_mvmt_buffs_other_rangs_damage := true # Set to true when player equips skill which enhances the damage of all other rangs when a roserang is moving (Harmony)
var roserang_mvmt_buffs_other_rangs_damage_multiplier := .25 # 25% boost
var axrang_mvmt_buffs_other_rangs_damage := true # Set to true when player equips skill which enhances the damage of all other rangs when the ax is moving (Symphony)
var axrang_mvmt_buffs_other_rangs_damage_multiplier := .25
var roserang_mvmt_buffs_axrang_damage_on_perfect_catch := true # Set to true when player equips skill where perfect catching the axrang while at least 1 rose is moving buffs the axrang's damage (Mania)
var roserang_mvmt_buffs_axrang_damage_on_perfect_catch_damage_multiplier := .4
var roserang_mvmt_buffs_axrang_damage_on_perfect_catch_time_remaining := 0.0 # Buff is considered active if time_remaining > 0, inactive otherwise
@export var roserang_mvmt_buffs_axrang_damage_on_perfect_catch_duration := 8.0

enum SHURIKEN_MARKLESS_MODE {
	NEAREST,
	HIGHEST_HP,
	LOWEST_HP
}
@export var shuriken_markless_behavior := SHURIKEN_MARKLESS_MODE.NEAREST

# Define how many slots the player has
@export var sigil_list: Array[Globals.SIGILS] = [Globals.SIGILS.AUTO_ROSERANG_BUFF, Globals.SIGILS.REGENERATOR]
@export var sigil_auto_roserang_buff_chance := .2
@export var sigil_max_stability_boost_amt := .2
@export var sigil_regenerator_stability_regen_multiplier := 2.0 # Debuffs like Infest reduce stability regen by multiplying the stab recovered per frame by a fraction (e.g. .33). To reduce the regen reduction, the fraction is multiplied by this num, which must be > 1

# Helper to check if a specific sigil is equipped
func has_sigil(sigil: Globals.SIGILS) -> bool:
	return sigil_list.has(sigil)

var destabilized := false
var grabbed := false
var stunned := false
var grab_pos_node : Node3D

var roserang := preload("res://rang/roserang.tscn")
var roserang_instances = [] 
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

func set_busy(state: bool):
	busy = state

func on_destabilize():
	destabilized = true

func on_stabilize():
	destabilized = false

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
	if Input.is_action_just_pressed("PlaceMark"):
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
	
	# Hoverboard dismount logic - pressing Special exits hoverboard mode
	# This check happens before special ability checks so dismount always works
	if is_hoverboarding and Input.is_action_just_pressed("Special"):
		is_hoverboarding = false
		# Restore gravity
		gravity = default_gravity
		# Don't process special abilities this frame if we just dismounted
		# (let the dismount action complete first)
	
	# Hoverboard movement
	if is_hoverboarding:
		handle_hoverboard_movement(delta)
		# Don't return - allow rang throwing and other actions while hoverboarding
	
	# Falling (skip if hoverboarding)
	if not is_on_floor() and not is_hoverboarding:
		velocity.y -= gravity * delta
	
	# Stunned logic
	if stunned:
		move_and_slide()
		return
	
	# Dodge logic with hoverboard activation (can't dodge while already hoverboarding)
	if Input.is_action_just_pressed("StepDodge") and !busy and roserang_power_throw_charge_time <= 0 and !is_hoverboarding:
		anim_tree.set(anim_tree_param_path_base + "just_dodged", true)
		dodge_held = true
		step_dodge()
	else:
		anim_tree.set(anim_tree_param_path_base + "just_dodged", false)
	
	# Track if dodge button is released during dodge
	if is_dodging and not Input.is_action_pressed("StepDodge"):
		dodge_held = false
	
	if Input.is_action_pressed("Jump") and is_on_floor() and icon.following_cotu and !is_hoverboarding:
		super_jump_charge_time += delta
		
		# Once the player starts charging, they become "busy" and stop moving
		if super_jump_charge_time > super_jump_min_charge_time: # Small buffer so a tap doesn't freeze you
			can_walk = false
			can_rotate = false
			set_busy(true)
			velocity.x = 0
			velocity.z = 0
		
		if super_jump_charge_time >= super_jump_full_charge_time:
			super_jump_fully_charged = true
			# You could add a particle effect or sound trigger here for "Charge Complete"
	
	if Input.is_action_just_released("Jump") and !is_hoverboarding:
		if super_jump_fully_charged:
			velocity.y = super_jump_speed
			# Optional: add a 'jump' trigger to your AnimTree here
		
		# Always reset state on release
		super_jump_charge_time = 0.0
		super_jump_fully_charged = false
		set_busy(false)
		can_walk = true
		can_rotate = true
	
	if is_dodging:
		grounded_speed = STEP_DODGE_SPEED
	else:
		grounded_speed = walk_speed
	
	if active_debuffs[Globals.DEBUFFS.SLOW] > 0:
		grounded_speed *= .5
		active_debuffs[Globals.DEBUFFS.SLOW] -= delta
	
	if active_debuffs[Globals.DEBUFFS.INFEST] > 0:
		active_debuffs[Globals.DEBUFFS.INFEST] -= delta
	
	# Cotu movement (skip normal movement if hoverboarding, as it's handled separately)
	if not is_hoverboarding:
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
	if not roserang_instances.is_empty():
		# Track the most recently thrown roserang
		rang_pointer_pivot.look_at(roserang_instances.back().global_position)
		roserang_particles.global_position = roserang_instances.back().global_position
		if not roserang_particles.emitting:
			roserang_particles.emitting = true
	else:
		rang_pointer_pivot.transform.basis = camera_twist_pivot.transform.basis
		if roserang_particles.emitting:
			roserang_particles.emitting = false
	
	# Special rose throw (takes precedence over instant rethrow). Requires all buffs to be active
	var all_roserang_buffs_active := next_roserang_buff_index >= Globals.roserang_buff_list.size()
	# Skip if hoverboarding (player is using Special to dismount)
	if Input.is_action_just_pressed("Special") and not is_hoverboarding and not roserang_special_queued and all_roserang_buffs_active and not roserang_instances.is_empty():
		start_roserang_special_timer()
	if roserang_special_queued and roserang_instances.is_empty():
		roserang_special_queued = false
		roserang_special_just_used = true
		throw_roserang_with_script(current_roserang_special_script)
	
	# Special ax throw
	var all_axrang_buffs_active := next_axrang_buff_index >= axrang_buff_list.size()
	# Skip if hoverboarding (player is using Special to dismount)
	if Input.is_action_just_pressed("Special") and not is_hoverboarding and not axrang_special_queued and all_axrang_buffs_active and axrang_instance != null:
		start_axrang_special_timer()
	# Why not check if axrang_special_queued and axrang_instance == null to call throw_special_axrang like rose? Because on_catch_axrang can be used instead
	# axrang_special_buff_saving ax buff expiration
	if axrang_special_buff_save_time_remaining > 0.0:
		axrang_special_buff_save_time_remaining -= delta
		if axrang_special_buff_save_time_remaining <= 0.0:
			# Timer just expired → clear buffs once
			clear_axrang_buffs()
	
	# axrang_hit_buffs_other_rangs_damage buff timing
	if axrang_hit_buffs_other_rangs_damage_time_remaining > 0:
		axrang_hit_buffs_other_rangs_damage_time_remaining -= delta
	
	# roserang_mvmt_buffs_axrang_damage_on_perfect_catch buff timing
	if roserang_mvmt_buffs_axrang_damage_on_perfect_catch_time_remaining > 0:
		roserang_mvmt_buffs_axrang_damage_on_perfect_catch_time_remaining -= delta
	
	if Input.is_action_just_pressed("MeleeAxrang") and !busy:
		anim_tree.set(anim_tree_param_path_base + "melee_ax", true)
	else:
		anim_tree.set(anim_tree_param_path_base + "melee_ax", false)
	
	# Axrang throw
	if Input.is_action_just_pressed("ThrowAxrang"):
		if axrang_instance == null and !busy:
			if not destabilized and not axrang_perfect_caught:
				anim_tree.set(anim_tree_param_path_base + "NormalThrowAxrang", true)
			else:
				anim_tree.set(anim_tree_param_path_base + "PerfectThrowAxrang", true)
		elif axrang_instance != null and not axrang_instance.is_returning():
			axrang_instance.advance_state()
		elif axrang_instance != null and axrang_instance.is_returning():
			start_axrang_perfect_catch_timer()
	
	# Axrang buff decay
	if axrang_instance != null and next_axrang_buff_index > 0:
		axrang_buff_decay_timer += delta
		if axrang_buff_decay_timer >= axrang_buff_decay_interval:
			remove_axrang_buff()
			axrang_buff_decay_timer = 0.0
	else:
		# Reset the timer when the ax is caught or if there are no buffs
		axrang_buff_decay_timer = 0.0
	
	if roserang_instances.is_empty():
		if roserang_instant_rethrow_queued:
			# Instant rethrow
			roserang_instant_rethrow_queued = false
			
			# If you're instant rethrowing after a roserang special was just used, clear roserang buffs
			if roserang_special_just_used:
				roserang_special_just_used = false
				clear_roserang_buffs()
			
			Globals.cotu_instant_rethrow_rose.emit()
			anim_tree.set(anim_tree_param_path_base + "InstantRethrowRoserang", true)
			
			# Set throw type
			homing_targets_added = Globals.roserang_buff_list.slice(0, next_roserang_buff_index).count(Globals.ROSERANG_BUFFS.HOMING)
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
		elif Input.is_action_pressed("ThrowRoserang"):
			# Prevent other actions while charging power throw
			if roserang_power_throw_charge_time <= 0:
				set_busy(true)
			# Power throw charge
			roserang_power_throw_charge_time += delta
		# Normal and power throw are triggered on button release
		elif Input.is_action_just_released("ThrowRoserang"):
			if roserang_power_throw_charge_time >= roserang_power_throw_min_charge_time:
				# Roserang power throw
				roserang_power_throw_charge_time = 0.0
				# Replace these 3 lines with an anim tree line once you have the power throw anim
				set_busy(true)
				roserang_power_throw()
				set_busy(false)
			else:
				# Roserang normal throw
				roserang_power_throw_charge_time = 0.0
				anim_tree.set(anim_tree_param_path_base + "NormalThrowRoserang", true)
	# Instant rethrow is triggered on button press
	elif Input.is_action_just_pressed("ThrowRoserang") and not roserang_instant_rethrow_queued:
		start_roserang_instant_rethrow_timer()
	
	# Clear buffs if an instant rethrow didn't just occur (i.e. if roserang_instances is still empty after an instant rethrow would have reassigned it)
	# Only clear buffs if rang_mvmt_buff_preservation is inactive OR the axrang isn't currently out and moving
	if roserang_instances.is_empty() and not (rang_mvmt_buff_preservation and axrang_instance != null and not axrang_instance.is_stationary()):
		clear_roserang_buffs()
	
	# Shuriken throw - skip in hoverboard mode
	if Input.is_action_just_pressed("ThrowShuriken") and !busy:
		if not destabilized:
			if shurikens.size() < max_shurikens:
				hurtbox.self_hit(throw_shuriken_self_damage)
			else:
				hurtbox.self_hit(throw_axrang_self_damage)
		throw_shuriken()
	
	if Input.is_action_just_pressed("UseItem") and !busy:
		anim_tree.set(anim_tree_param_path_base + "use_item", true)
	else:
		anim_tree.set(anim_tree_param_path_base + "use_item", false)
	
	if Input.is_action_just_pressed("PlaceMark"):
		if mark_destroyed:
			return
		if active_mark:
			active_mark.try_place_from_camera(camera)
		else:
			var m = mark_scene.instantiate()
			add_sibling(m)
			m.global_position = global_position
			if m.try_place_from_camera(camera):
				active_mark = m
				m.mark_removed.connect(_on_mark_removed)
		# If mark shuriken deploy is unlocked, then when mark is placed, deploy shurikens
		if mark_shuriken_deploy:
			deploy_shurikens()
	
	if mark_detonation and not mark_destroyed and active_mark != null:
		# If holding SPECIAL + pressing THROW SHURIKEN
		if Input.is_action_pressed("Special") and Input.is_action_just_pressed("ThrowShuriken"):
			
			# 1. Trigger the detonation on the mark instance
			active_mark.detonate()
			
			# 2. Mark is unusable for the rest of the level
			mark_destroyed = true
			
			# 3. Disconnect reference so we don't try to recall it or use it for aiming
			active_mark = null
	
	# Animation tree parameters
	var vel2D = Vector2(velocity.x, velocity.z)
	var move_blend_space := Vector2(vel2D.length(), 0)
	anim_tree.set("parameters/StateMachine/GroundBlendSpace/blend_position", move_blend_space)
	anim_tree.set("parameters/StateMachine/AerialBlendSpace/blend_position", Vector3.UP*velocity.y)

func handle_hoverboard_movement(_delta):
	# Get horizontal movement input
	walk_input = Input.get_vector("WalkLeft", "WalkRight", "WalkForward", "WalkBackward")
	if walk_input.x != 0:
		moving_right = walk_input.x > 0
	
	var mvmt_dir = Vector3(walk_input.x, 0, walk_input.y)
	var oriented_mvmt_dir = (camera_twist_pivot.basis * mvmt_dir).normalized()
	
	# Horizontal movement
	if oriented_mvmt_dir:
		velocity.x = lerp(velocity.x, oriented_mvmt_dir.x * HOVERBOARD_SPEED, LERP_VAL)
		velocity.z = lerp(velocity.z, oriented_mvmt_dir.z * HOVERBOARD_SPEED, LERP_VAL)
		if can_rotate:
			armature.rotation.y = lerp_angle(armature.rotation.y, atan2(oriented_mvmt_dir.x, oriented_mvmt_dir.z), LERP_VAL)
	else:
		velocity.x = lerp(velocity.x, 0.0, LERP_VAL)
		velocity.z = lerp(velocity.z, 0.0, LERP_VAL)
	
	# Vertical movement
	var ascending = Input.is_action_pressed("Jump")
	var descending = Input.is_action_pressed("StepDodge")
	
	if ascending and not descending:
		# Ascend
		velocity.y = lerp(velocity.y, HOVERBOARD_ASCENT_SPEED, LERP_VAL)
	elif descending and not ascending:
		# Descend
		velocity.y = lerp(velocity.y, -HOVERBOARD_DESCENT_SPEED, LERP_VAL)
	else:
		# Hovering (both pressed, neither pressed, or any other case)
		velocity.y = lerp(velocity.y, 0.0, LERP_VAL)
	
	# Animation tree parameters
	var vel2D = Vector2(velocity.x, velocity.z)
	var hover_blend_space := Vector2(vel2D.length(), velocity.y)
	anim_tree.set("parameters/StateMachine/HoverBlendSpace/blend_position", hover_blend_space)

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
	set_busy(true)
	is_dodging = true
	if not destabilized:
		hurtbox.self_hit(dodge_self_damage)
	set_collision_mask_value(Globals.ENEMY_COL_LAYER, false)
	if not roserang_instances.is_empty():
		icon.stop_following_cotu()
	await get_tree().create_timer(step_dodge_duration_secs).timeout
	is_dodging = false
	
	# Check if dodge was held throughout - if so, activate hoverboard
	if dodge_held and Input.is_action_pressed("StepDodge"):
		is_hoverboarding = true
		gravity = 0 # Disable gravity while hoverboarding
		velocity.y = 0 # Stop vertical momentum
	
	if axrang_dodge_rethrow_queued:
		axrang_dodge_rethrow_queued = false
		throw_axrang(armature.transform.basis.z)
	set_collision_mask_value(Globals.ENEMY_COL_LAYER, true)
	await get_tree().create_timer(step_dodge_cooldown_secs).timeout
	set_busy(false)
	dodge_held = false # Reset for next dodge

func roserang_normal_throw():
	if has_sigil(Globals.SIGILS.AUTO_ROSERANG_BUFF) and next_roserang_buff_index == 0:
		if randf() <= sigil_auto_roserang_buff_chance:
			next_roserang_buff_index = 1
	
	roserang_special_just_used = false
	if not destabilized:
		hurtbox.self_hit(normal_throw_roserang_self_damage)
	Globals.cotu_normal_throw_rose.emit()
	throw_roserang_with_script(rose_script)

func roserang_power_throw():
	if has_sigil(Globals.SIGILS.AUTO_ROSERANG_BUFF) and next_roserang_buff_index == 0:
		if randf() <= 0.2:
			next_roserang_buff_index = 1
	roserang_special_just_used = false
	if not destabilized:
		hurtbox.self_hit(power_throw_roserang_self_damage)
	Globals.cotu_power_throw_rose.emit()
	throw_roserang_with_script(rose_power_throw_script)

func throw_roserang_with_script(script):
	roserang_special_queued = false
	
	var new_roserang = roserang.instantiate()
	add_sibling(new_roserang)
	new_roserang.set_script(script)
	
	roserang_instances.append(new_roserang)
	# Connect tree_exiting to handle cleanup when the node is freed/caught
	new_roserang.tree_exiting.connect(_on_roserang_exiting.bind(new_roserang))
	
	apply_buffs_to_roserang_instance(new_roserang)
	
	# Unlike the damage buff, the homing buff (which sets homing targets) is only applied once: when the rang is instant rethrown for the first time in the buff cycle. Since it's only applied once per cycle, it's not applied in the same way as other buffs in apply_buffs_to_roserang_instance
	if script == homing_script:
		new_roserang.set_homing_targets(homing_targets_added)
	
	if axrang_mvmt_buffs_other_rangs_damage and axrang_instance != null and not axrang_instance.is_stationary():
		new_roserang.apply_damage_multiplier(axrang_mvmt_buffs_other_rangs_damage_multiplier)
	if axrang_hit_buffs_other_rangs_damage_time_remaining > 0:
		new_roserang.apply_damage_multiplier(axrang_hit_buffs_other_rangs_damage_multiplier)

func _on_roserang_exiting(roserang_node):
	roserang_instances.erase(roserang_node)
	# Logic for clearing buffs/resetting icon happens in _physics_process based on is_empty()
	if roserang_instances.is_empty():
		icon.start_following_cotu()

func start_roserang_instant_rethrow_timer():
	roserang_instant_rethrow_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	roserang_instant_rethrow_queued = false

func add_roserang_buff(): # Called by icon when roserang hits it
	if next_roserang_buff_index < Globals.roserang_buff_list.size():
		var newly_added_buff = Globals.roserang_buff_list[next_roserang_buff_index]
		
		# Check if the newly added buff is DUPLICATE
		if newly_added_buff == Globals.ROSERANG_BUFFS.DUPLICATE:
			# The duplicate manifests from the icon and is thrown.
			# It uses the default 'rose_script' since it's a new throw,
			# and it's marked as a duplicate to prevent infinite spawning.
			throw_roserang_with_script(rose_script)
		
		next_roserang_buff_index += 1

func apply_buffs_to_roserang_instance(target_roserang):
	if next_roserang_buff_index <= 0 and not ui.roserang_buffs_cleared():
		ui.clear_roserang_buffs()
	
	# Apply buffs to the roserang instance and UI simultaneously
	for i in range(next_roserang_buff_index):
		ui.apply_roserang_buff(i)
		match(Globals.roserang_buff_list[i]):
			Globals.ROSERANG_BUFFS.DAMAGE:
				target_roserang.buff_damage()
			Globals.ROSERANG_BUFFS.HOMING:
				# Unlike the damage buff, the homing buff (which sets homing targets) is only applied once: when the rang is instant rethrown for the first time in the buff cycle. Since it's only applied once per cycle, it's not applied in the same way as other buffs in apply_buffs_to_roserang_instance
				pass
			Globals.ROSERANG_BUFFS.DUPLICATE:
				# A duplicate spawns when a duplicate buff is added, not every time buffs are applied
				pass

func clear_roserang_buffs():
	if not roserang_instances.is_empty():
		return
		
	next_roserang_buff_index = 0
	if not ui.roserang_buffs_cleared():
		ui.clear_roserang_buffs()

func start_roserang_special_timer():
	roserang_special_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	roserang_special_queued = false

func on_catch_axrang():
	# If you're dodging, you queue an axrang dodge rethrow. Since dodging is important for survival, it gets the highest priority action
	if is_dodging:
		axrang_dodge_rethrow_queued = true
		return
	# If player inputted special right before catching ax, use special axrang and don't clear buffs until the special finishes. Special is checked before perfect catch since it's a more impactful action
	if axrang_special_queued:
		axrang_special_queued = false
		throw_special_axrang()
		return
	# Check this condition first; if perfect catch buff adding is checked first, then perfect_catch_queued is set to false, THEN this condition would check and clear the buffs
	if not axrang_perfect_catch_queued and not is_dodging:
		# Clear axrang buffs if axrang wasn't perfect caught or player isn't using special
		# UNLESS rang_mvmt_buff_preservation is active AND at least one roserang is flying
		if not (rang_mvmt_buff_preservation and not roserang_instances.is_empty()):
			clear_axrang_buffs()
		return
	if axrang_perfect_catch_queued:
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
			ui.apply_axrang_buff(i)
		if roserang_mvmt_buffs_axrang_damage_on_perfect_catch and not roserang_instances.is_empty():
			roserang_mvmt_buffs_axrang_damage_on_perfect_catch_time_remaining = roserang_mvmt_buffs_axrang_damage_on_perfect_catch_duration

func throw_axrang_with_self_damage():
	hurtbox.self_hit(throw_axrang_self_damage)
	throw_axrang()

func throw_axrang(dir := Vector3.ZERO):
	Globals.cotu_throw_ax.emit()
	axrang_instance = axrang.instantiate()
	add_sibling(axrang_instance)
	apply_buffs_to_axrang_instance()
	axrang_instance.caught.connect(on_catch_axrang)
	axrang_instance.hit_enemy.connect(on_axrang_ranged_hit)
	if roserang_mvmt_buffs_other_rangs_damage and not roserang_instances.is_empty():
		axrang_instance.apply_damage_multiplier(roserang_mvmt_buffs_other_rangs_damage_multiplier)
	if roserang_mvmt_buffs_axrang_damage_on_perfect_catch_time_remaining > 0:
		axrang_instance.apply_damage_multiplier(roserang_mvmt_buffs_axrang_damage_on_perfect_catch_damage_multiplier)
	if dir != Vector3.ZERO:
		# Axrang instance travels in Cotu's rang throw direction by default (i.e. if not set by set_direction)
		axrang_instance.set_direction(dir)

func start_axrang_perfect_catch_timer():
	axrang_perfect_catch_queued = true
	await get_tree().create_timer(rang_catch_input_buffer_secs).timeout
	axrang_perfect_catch_queued = false

func add_axrang_buff(): # Called by Cotu when he catches the axrang
	if next_axrang_buff_index < axrang_buff_list.size():
		next_axrang_buff_index += 1

func remove_axrang_buff():
	if next_axrang_buff_index > 0:
		next_axrang_buff_index -= 1
		ui.remove_axrang_buff(next_axrang_buff_index)
		
		# Update the current ax instance's damage
		if axrang_instance != null:
			apply_buffs_to_axrang_instance()

func apply_buffs_to_axrang_instance():
	if next_axrang_buff_index <= 0 and not ui.axrang_buffs_cleared():
		ui.clear_axrang_buffs()
	# CLear all buffs before buffing
	axrang_instance.reset_buffs()
	# Apply buffs to the ax instance itself, but not the UI because the buffs were already applied in the UI in the previous perfect catch
	for i in range(next_axrang_buff_index):
		match(axrang_buff_list[i]):
			Globals.AXRANG_BUFFS.DAMAGE:
				axrang_instance.buff_damage()
			Globals.AXRANG_BUFFS.SPEED:
				axrang_instance.buff_speed()

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

func on_axrang_ranged_hit():
	if axrang_hit_buffs_other_rangs_damage:
		activate_axrang_hit_buffs_other_rangs_damage()

# Activates or refreshes axrang_hit_buffs_other_rangs_damage
func activate_axrang_hit_buffs_other_rangs_damage():
	axrang_hit_buffs_other_rangs_damage_time_remaining = axrang_hit_buffs_other_rangs_damage_duration

func _on_axrang_melee_hit(_body):
	# Called every time axrang hits something (it can only detect collisions with enemies)
	axrang_melee_hit = true

func clear_or_save_axrang_buffs():
	# If axrang_special_hit_buff_saving isn't unlocked, or special didn't hit anything, clear buffs immediately
	if not axrang_special_hit_buff_saving or not axrang_melee_hit:
		clear_axrang_buffs()
		return
	
	# axrang_special_hit_buff_saving is active and special hit → preserve buffs temporarily
	axrang_special_buff_save_time_remaining = axrang_special_buff_save_duration

func clear_axrang_buffs():
	axrang_perfect_caught = false
	next_axrang_buff_index = 0
	if not ui.axrang_buffs_cleared():
		ui.clear_axrang_buffs()

func end_attack():
	anim_tree.set(anim_tree_param_path_base + "NormalThrowRoserang", false)
	anim_tree.set(anim_tree_param_path_base + "InstantRethrowRoserang", false)
	anim_tree.set(anim_tree_param_path_base + "NormalThrowAxrang", false)
	anim_tree.set(anim_tree_param_path_base + "PerfectThrowAxrang", false)
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

func throw_shuriken():
	var s = shuriken_scene.instantiate()
	add_sibling(s)
	shurikens.append(s)
	s.destroyed.connect(_on_shuriken_destroyed)
	if roserang_mvmt_buffs_other_rangs_damage and not roserang_instances.is_empty():
		s.apply_damage_multiplier(roserang_mvmt_buffs_other_rangs_damage_multiplier)
	if axrang_mvmt_buffs_other_rangs_damage and axrang_instance != null and !axrang_instance.is_stationary():
		s.apply_damage_multiplier(axrang_mvmt_buffs_other_rangs_damage_multiplier)
	if axrang_hit_buffs_other_rangs_damage_time_remaining > 0: # Buff is active when time remaining > 0
		s.apply_damage_multiplier(axrang_hit_buffs_other_rangs_damage_multiplier)

func deploy_shurikens():
	if len(shurikens) == 0:
		return
	
	var target := get_shuriken_target()
	if target == null:
		return
	
	# Check if the target is marked (i.e., if there is an active mark) and there are shuriken_marked_bonus_slashes
	var marked_bonus_slashes = shuriken_marked_bonus_slashes if active_mark != null else 0
	
	for s in shurikens:
		# Configure the shuriken with the correct bonus for this specific target
		s.configure(shuriken_base_slashes, marked_bonus_slashes, shuriken_self_destruction)
		s.deploy_to_target(target)
	
	# Resolve/Thrill skills logic
	if shurikens.size() == 3:
		if mid_stability_bonus_shurikens and hurtbox.health < (hurtbox.max_health * 0.5):
			for i in range(3):
				var bonus_s = shuriken_scene.instantiate()
				add_sibling(bonus_s)
				
				# Ensure bonus shurikens also get the correct configuration
				bonus_s.configure(shuriken_base_slashes, marked_bonus_slashes, shuriken_self_destruction)
				
				await get_tree().create_timer(.3).timeout
				bonus_s.deploy_to_target(target)
				shurikens.append(bonus_s)
				bonus_s.destroyed.connect(_on_shuriken_destroyed)
		
		# Thrill fireball logic
		if low_stability_fireball and hurtbox.health < (hurtbox.max_health * 0.25):
			var fb = fireball_scene.instantiate()
			add_sibling(fb)
			fb.global_position = icon.global_position
			fb.deploy_to_target(target)

func is_effectively_invalid(n: Node) -> bool:
	return not is_instance_valid(n) or n.process_mode == Node.PROCESS_MODE_DISABLED

func _on_shuriken_destroyed(s_node):
	if s_node in shurikens:
		shurikens.erase(s_node)

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
