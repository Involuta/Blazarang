extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
const SPECIAL_DIST := 13 # max dist from Cotu where doing special input will perform a special move

var BPM := 120.0
var rose_eqn_max_radius := 30
var rose_eqn_petals := 5

var rose_eqn_angle_speed := PI / (rose_eqn_petals * 120 / BPM)
var rose_eqn_current_angle := 0.0 # angle to calculate radius
var rose_eqn_current_radius := 0.0 # dist from rose center at angle

var invincible := true # This var prevents the rang from being destroyed right after Cotu throws it (and also stops the Icon from buffing the rang as soon as the rang is thrown)
var invincibility_secs := .5
var rose_eqn_initial_throw_angle := 0.0
var rose_eqn_initial_throw_angle_offset := rose_eqn_petals*PI-.05 # rang is thrown
var rose_switch_angle_offset_right := rose_eqn_petals*PI+2*PI/3 # curve to left
var rose_switch_angle_offset_left := rose_eqn_petals*PI-PI/2 # rang switched from ricochet or return to rose
# vel.angle(): right = 0, fwd = -pi/2, left = ±pi, back = pi/2
# look_angle: right = -pi/2, fwd = 0, left = pi/2, back = ±pi
# (-pi, pi/2) (-pi/2, 0) (0, -pi/2) (pi/2, -pi) (pi, -3pi/2)

enum {
	ROSE,
	RICOCHET,
	RETURN
}
var mvmt_state = ROSE
var current_loop_angle := 0.0 # shows how far into the current loop the rang is (i.e. how far it would be if it were still in rose mode) to know whether to start returning during ricochet
const RETURN_ACC := 1.2
const MAX_RETURN_SPEED := 55

var rapidorbit_script := preload("res://rang/special_rapidorbit.gd")
var homing_script := preload("res://rang/special_homing.gd")
var ricochet_particles := preload("res://rang/rang_particles_ricochet.tscn")

@onready var root := $/root/ViewControl
var level : Node3D
var cotu : Node3D
var target : Node3D

@onready var hitbox = $PlayerHitbox
@onready var mesh = $RoserangMesh
@onready var trail = $Trail
@onready var base_particle_gradient = $RangParticlesBase/GPUParticles3D.process_material.color_ramp.gradient
@onready var rang_glow_shader = $RoserangMesh/Boomerang3DModelV1.get_surface_override_material(0)
@export var rotate_speed := 3.6
@export var rose_color := Color(1,0,.8)
@export var ricochet_color := Color(0,.8,0)
@export var return_color := Color(0,0,1)

@onready var flying_sfx := $FlyingAudioStream
@onready var ricochet_sfx := $RicochetAudioStream

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	target = level.find_child("Icon")
	
	hitbox.damage = Globals.roserang_base_damage
	
	flying_sfx.play()
	target.roserang_queued = false
	set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
	set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, true)
	rose_eqn_initial_throw_angle = rose_eqn_petals*cotu.look_angle + rose_eqn_initial_throw_angle_offset
	set_direction()
	global_position = target.global_position
	change_color(rose_color)

func set_direction():
	if cotu.moving_right:
		rose_eqn_angle_speed = -1*(PI / (rose_eqn_petals * 120 / BPM))
		rose_eqn_current_angle = (-2*PI - rose_eqn_initial_throw_angle) / rose_eqn_petals
	else:
		# initial angle = (2PI - initial_throw_angle) / petals
		rose_eqn_angle_speed = PI / (rose_eqn_petals * 120 / BPM)
		rose_eqn_current_angle = (2*PI - rose_eqn_initial_throw_angle) / rose_eqn_petals
	
func rose(delta):
	rose_eqn_current_angle += rose_eqn_angle_speed * delta
	rose_eqn_current_radius = rose_eqn_max_radius * sin(rose_eqn_petals * rose_eqn_current_angle + rose_eqn_initial_throw_angle)
	var angle_vec := Vector2.from_angle(rose_eqn_current_angle)
	return target.global_position + rose_eqn_current_radius * Vector3(angle_vec.x, 0, angle_vec.y)

func change_color(color: Color):
	trail.color_ramp.gradient.colors[1] = color
	base_particle_gradient.set_color(1, color)
	rang_glow_shader.set_shader_parameter("ColorParameter", color)

func _physics_process(delta):
	mesh.rotate_y(rotate_speed)
	current_loop_angle += abs(rose_eqn_angle_speed) * delta
	invincible = current_loop_angle < PI/(5*rose_eqn_petals)
	match(mvmt_state):
		ROSE:
			var new_pos = rose(delta)
			# vel_vec is in meters per frame, which is what move_and_collide wants
			# CharacterBody3D's velocity is in meters per second
			var vel_vec = new_pos - global_position
			look_at(new_pos)
			var hit_arena = rose_handle_collision(move_and_collide(vel_vec, true), vel_vec, delta)
			if hit_arena:
				set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
				set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, true)
				mvmt_state = RICOCHET
				return
			global_position = new_pos
			var reached_return := current_loop_angle < PI/(2*rose_eqn_petals)
			set_collision_mask_value(Globals.ARENA_COL_LAYER, reached_return)
			set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, reached_return)
			if reached_return:
				change_color(rose_color)
			else:
				change_color(return_color)
		RICOCHET:
			if target.roserang_queued:
				switch_to_rose()
			look_at(global_position + velocity)
			ricochet_handle_collision(move_and_collide(velocity * delta))
			if current_loop_angle >= PI/(2*rose_eqn_petals):
				set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
				set_collision_mask_value(Globals.THICK_ENEMY_COL_LAYER, false)
				change_color(return_color)
				mvmt_state = RETURN
		RETURN:
			if target.roserang_queued:
				switch_to_rose()
				return
			if velocity.length() < MAX_RETURN_SPEED:
				velocity = (velocity.length() + RETURN_ACC) * global_position.direction_to(target.global_position)
			else:
				velocity = MAX_RETURN_SPEED * global_position.direction_to(target.global_position)
			look_at(global_position + velocity)
			move_and_slide()

func buff_damage():
	current_loop_angle = 0
	hitbox.damage = 20

func switch_to_rose():
	target.roserang_queued = false
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
	if collision and (Globals.compare_layers(collision.get_collider().collision_layer, Globals.ARENA_COL_LAYER) or Globals.compare_layers(collision.get_collider().collision_layer, Globals.THICK_ENEMY_COL_LAYER)):
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
