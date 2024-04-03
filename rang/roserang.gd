extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
const SPECIAL_DIST := 7 # max dist from Cotu where doing special input will perform a special move

var BPM := 90.0
var max_radius := 30
var petals := 5

var angle_speed := PI / (petals * 120 / BPM)
var angle := 0.0 # angle to calculate radius
var radius := 0.0 # dist from rose center at angle

var invincible := true
var invincibility_secs := .5
var initial_throw_angle := 0.0
var initial_throw_angle_offset := petals*PI-.05 # rang is thrown
var rose_switch_angle_offset_right := petals*PI+2*PI/3 # curve to left
var rose_switch_angle_offset_left := petals*PI-PI/2 # rang switched from ricochet or return to rose
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
@onready var cotu = $/root/Arena/cotuCB
@onready var target = $/root/Arena/Target
@onready var hitbox = $PlayerHitbox

func _ready():
	target.roserang_queued = false
	set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
	initial_throw_angle = petals*cotu.look_angle + initial_throw_angle_offset
	set_direction()
	global_position = target.global_position

func set_direction():
	if cotu.moving_right:
		angle_speed = -1*(PI / (petals * 120 / BPM))
		angle = (-2*PI - initial_throw_angle) / petals
	else:
		# initial angle = (2PI - initial_throw_angle) / petals
		angle_speed = PI / (petals * 120 / BPM)
		angle = (2*PI - initial_throw_angle) / petals
	
func rose(delta):
	angle += angle_speed * delta
	radius = max_radius * sin(petals * angle + initial_throw_angle)
	var angle_vec := Vector2.from_angle(angle)
	return target.global_position + radius * Vector3(angle_vec.x, 0, angle_vec.y)

func _physics_process(delta):
	if Input.is_action_just_pressed("Special") and target.following_cotu and global_position.distance_to(cotu.global_position) < SPECIAL_DIST:
		set_script(rapidorbit_script)
		return
	current_loop_angle += abs(angle_speed) * delta
	invincible = current_loop_angle < PI/(5*petals)
	match(mvmt_state):
		ROSE:
			var new_pos = rose(delta)
			# vel_vec is in meters per frame, which is what move_and_collide wants
			var vel_vec = new_pos - global_position
			var hit_arena = rose_handle_collision(move_and_collide(vel_vec, true), vel_vec, delta)
			if hit_arena:
				set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
				mvmt_state = RICOCHET
				return
			global_position = new_pos
			set_collision_mask_value(Globals.ARENA_COL_LAYER, current_loop_angle < PI/(2*petals))
		RICOCHET:
			if target.roserang_queued:
				switch_to_rose()
			ricochet_handle_collision(move_and_collide(velocity * delta))
			if current_loop_angle >= PI/(2*petals):
				set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
				mvmt_state = RETURN
		RETURN:
			if target.roserang_queued:
				switch_to_rose()
				return
			if velocity.length() < MAX_RETURN_SPEED:
				velocity = (velocity.length() + RETURN_ACC) * global_position.direction_to(target.global_position)
			else:
				velocity = MAX_RETURN_SPEED * global_position.direction_to(target.global_position)
			move_and_slide()

func buff_self():
	current_loop_angle = 0
	hitbox.damage = 30

func switch_to_rose():
	target.roserang_queued = false
	set_collision_mask_value(Globals.ARENA_COL_LAYER, true)
	mvmt_state = ROSE
	current_loop_angle = 0

	initial_throw_angle = petals*(-1*Vector2(velocity.normalized().x, velocity.normalized().z).angle() - PI/2)
	if cotu.moving_right:
		initial_throw_angle += rose_switch_angle_offset_right
	else:
		initial_throw_angle += rose_switch_angle_offset_left
	set_direction()

func ricochet(collision):
	velocity = velocity - 2 * velocity.project(collision.get_normal())

func rose_handle_collision(collision, vel_vec, delta):
	if collision and collision.get_collider().collision_layer == Globals.ARENA_COL_LAYER:
		velocity = (1/delta) * (vel_vec - 2 * vel_vec.project(collision.get_normal()))
		return true

func ricochet_handle_collision(collision):
	if collision and collision.get_collider().collision_layer == Globals.ARENA_COL_LAYER:
		ricochet(collision)

func get_mvmt_state():
	match(mvmt_state):
		ROSE:
			return "ROSE"
		RICOCHET:
			return "RICOCHET"
		RETURN:
			return "RETURN"
