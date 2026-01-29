extends CharacterBody3D
class_name RoserangPower

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
const SPECIAL_DIST := 13 

var BPM := 120.0
var rose_eqn_max_radius := 30
var rose_eqn_petals := 5

var rose_eqn_angle_speed := PI / (rose_eqn_petals * 120 / BPM)
var rose_eqn_current_angle := 0.0 
var rose_eqn_current_radius := 0.0 

var invincible := true 
var invincibility_secs := .5
var rose_eqn_initial_throw_angle := 0.0
var rose_eqn_initial_throw_angle_offset := rose_eqn_petals*PI-.05 
var rose_switch_angle_offset_right := rose_eqn_petals*PI+2*PI/3 
var rose_switch_angle_offset_left := rose_eqn_petals*PI-PI/2 

var can_ricochet := true 
var base_time_until_can_ricochet := 0.02 
var remaining_time_until_can_ricochet := 0.0 

# New Travel State Variables
var travel_speed := 60.0
var travel_max_dist := 25.0
var travel_start_pos := Vector3.ZERO
var travel_returning := false

enum {
	TRAVEL, # Added Travel State
	ROSE,
	RICOCHET,
	RETURN
}
var mvmt_state = TRAVEL # Starts in TRAVEL
var current_loop_angle := 0.0 
const RETURN_ACC := 1.2
const MAX_RETURN_SPEED := 55

# PMD = pre-multiplier damage
var damage_multiplier := 1.0 
var hitbox_pmd := 0.0

var ricochet_particles := preload("res://rang/rang_particles_ricochet.tscn")

@onready var root := $/root/ViewControl
var level : Node3D
var cotu : Node3D
var icon : Node3D

@onready var hitbox = $PlayerHitbox
@onready var mesh = $RoserangMesh
@onready var trail = $Trail
@onready var base_particle_gradient = $RoserangParticlesBase/GPUParticles3D.process_material.color_ramp.gradient
@onready var rang_glow_shader = $RoserangMesh/Boomerang3DModelV1.get_surface_override_material(0)
@export var rotate_speed := 3.6
@export var rose_color := Color(1,0,.8)
@export var ricochet_color := Color(0,.8,0)
@export var return_color := Color(0,0,1)
@export var travel_color := Color(1, 1, 0) # Gold/Yellow for travel

@onready var flying_sfx := $FlyingAudioStream
@onready var ricochet_sfx := $RicochetAudioStream

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	icon = level.find_child("Icon")
	
	hitbox_pmd = Globals.player_hitbox_data.RoserangBaseDamage
	update_hitbox_damage()
	
	flying_sfx.play()
	icon.roserang_queued = false
	
	# Initial travel setup
	global_position = icon.global_position
	travel_start_pos = global_position
	
	# Calculate travel velocity based on throw angle
	var throw_angle = cotu.get_rang_throw_y_angle()
	velocity = Vector3(sin(throw_angle), 0, cos(throw_angle)).normalized() * -travel_speed
	
	change_color(travel_color)

func set_direction():
	if cotu.moving_right:
		rose_eqn_angle_speed = -1*(PI / (rose_eqn_petals * 120 / BPM))
		rose_eqn_current_angle = (-2*PI - rose_eqn_initial_throw_angle) / rose_eqn_petals
	else:
		rose_eqn_angle_speed = PI / (rose_eqn_petals * 120 / BPM)
		rose_eqn_current_angle = (2*PI - rose_eqn_initial_throw_angle) / rose_eqn_petals

func rose(delta):
	rose_eqn_current_angle += rose_eqn_angle_speed * delta
	rose_eqn_current_radius = rose_eqn_max_radius * sin(rose_eqn_petals * rose_eqn_current_angle + rose_eqn_initial_throw_angle)
	var angle_vec := Vector2.from_angle(rose_eqn_current_angle)
	return icon.global_position + rose_eqn_current_radius * Vector3(angle_vec.x, 0, angle_vec.y)

func _physics_process(delta):
	mesh.rotate_y(rotate_speed)
	current_loop_angle += abs(rose_eqn_angle_speed) * delta
	
	if not can_ricochet:
		remaining_time_until_can_ricochet -= delta
		if remaining_time_until_can_ricochet <= 0:
			can_ricochet = true

	match(mvmt_state):
		TRAVEL:
			if not travel_returning:
				# Move out
				var collision = move_and_collide(velocity * delta)
				if collision or global_position.distance_to(travel_start_pos) >= travel_max_dist:
					travel_returning = true
					change_color(return_color)
			else:
				# Return to Icon
				var dir = global_position.direction_to(icon.global_position)
				velocity = dir * travel_speed
				move_and_collide(velocity * delta)
				
				# If we hit the icon, switch to ROSE mode permanently
				if global_position.distance_to(icon.global_position) < 1.0:
					# Initialize Rose variables for the first time
					rose_eqn_initial_throw_angle = rose_eqn_petals * cotu.get_rang_throw_y_angle() + rose_eqn_initial_throw_angle_offset
					set_direction()
					invincible = false
					mvmt_state = ROSE
					current_loop_angle = 0
					change_color(rose_color)
			
			if velocity.length() > 0:
				look_at(global_position + velocity)

		ROSE:
			var new_pos = rose(delta)
			var vel_vec = new_pos - global_position
			look_at(new_pos)
			var hit_arena = rose_handle_collision(move_and_collide(vel_vec, true), vel_vec, delta)
			if hit_arena:
				set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
				mvmt_state = RICOCHET
				return
			global_position = new_pos
			
			var reached_return := current_loop_angle < PI/(2*rose_eqn_petals)
			if reached_return:
				change_color(rose_color)
			else:
				change_color(return_color)

		RICOCHET:
			if icon.roserang_queued:
				switch_to_rose()
			look_at(global_position + velocity)
			ricochet_handle_collision(move_and_collide(velocity * delta))
			if current_loop_angle >= PI/(2*rose_eqn_petals):
				mvmt_state = RETURN

		RETURN:
			if icon.roserang_queued:
				switch_to_rose()
				return
			var target_vel = global_position.direction_to(icon.global_position)
			velocity = velocity.move_toward(target_vel * MAX_RETURN_SPEED, RETURN_ACC)
			look_at(global_position + velocity)
			move_and_slide()

func buff_damage():
	current_loop_angle = 0
	hitbox_pmd = Globals.player_hitbox_data.RoserangDamageBuff1
	update_hitbox_damage()

func update_hitbox_damage():
	# If damage is boosted by 25%, damage_multiplier is 1.25
	hitbox.damage = hitbox_pmd * damage_multiplier

func apply_damage_multiplier(mult: float):
	# Multipliers accumulate multiplicatively
	damage_multiplier *= 1 + mult
	update_hitbox_damage()

func buff_homing_targets(_targets_added: int):
	# This func exists so that if the rang hits the icon while in rose mode, and the homing buff is applied, the current living rang simply does nothing and continues in rose mode. The buff only takes effect when an instant rethrow occurs
	pass

func switch_to_rose():
	icon.roserang_queued = false
	set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
	set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, true)
	mvmt_state = ROSE
	current_loop_angle = 0

	rose_eqn_initial_throw_angle = rose_eqn_petals*(-1*Vector2(velocity.normalized().x, velocity.normalized().z).angle() - PI/2)
	if cotu.moving_right:
		rose_eqn_initial_throw_angle += rose_switch_angle_offset_right
	else:
		rose_eqn_initial_throw_angle += rose_switch_angle_offset_left
	set_direction()
	change_color(rose_color)

func ricochet(collision):
	velocity = velocity - 2 * velocity.project(collision.get_normal())
	can_ricochet = false
	remaining_time_until_can_ricochet = base_time_until_can_ricochet

func rose_handle_collision(collision, vel_vec, delta):
	if collision and (Globals.compare_layers(collision.get_collider().collision_layer, Globals.ARENA_COL_LAYER) or Globals.compare_layers(collision.get_collider().collision_layer, Globals.THICK_ENEMY_COL_LAYER)):
		velocity = (1/delta) * (vel_vec - 2 * vel_vec.project(collision.get_normal()))
		emit_ricochet_particles(vel_vec)
		change_color(ricochet_color)
		ricochet_sfx.play()
		var col_obj := instance_from_id(collision.get_collider_id())
		if col_obj.has_method("rose_rang_hit"):
			col_obj.rose_rang_hit(collision, vel_vec, delta)
		return true
	return false

func ricochet_handle_collision(collision):
	if can_ricochet and collision and (Globals.compare_layers(collision.get_collider().collision_layer, Globals.ARENA_COL_LAYER) or Globals.compare_layers(collision.get_collider().collision_layer, Globals.THICK_ENEMY_COL_LAYER)):
		ricochet(collision)
		emit_ricochet_particles(collision.get_normal())
		ricochet_sfx.play()
		var col_obj := instance_from_id(collision.get_collider_id())
		if col_obj.has_method("ricochet_rang_hit"):
			col_obj.ricochet_rang_hit(collision.get_normal())

func emit_ricochet_particles(dir):
	var inst := ricochet_particles.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = global_position
	inst.look_at(inst.global_position + dir)

func get_mvmt_state():
	match(mvmt_state):
		ROSE:
			return "ROSE"
		RICOCHET:
			return "RICOCHET"
		RETURN:
			return "RETURN"

func change_color(color: Color):
	trail.color_ramp.gradient.colors[1] = color
	base_particle_gradient.set_color(1, color)
	rang_glow_shader.set_shader_parameter("ColorParameter", color)
