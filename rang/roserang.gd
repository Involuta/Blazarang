extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
const SPECIAL_DIST := 7 # max dist from Cotu where doing special input will perform a special move

var BPM := 90.0
var max_radius := 30
var petals := 5

var speed := PI / (petals * 120 / BPM)
var angle := 0.0 # angle to calculate radius
var radius := 0.0 # dist from rose center at angle

var invincible := true
var invincibility_secs := .5
var initial_throw_angle := 0.0
var initial_throw_angle_offset := petals*PI-.05

var ricochet_script := preload("res://rang/ricochet.gd")
var rapidorbit_script := preload("res://rang/special_rapidorbit.gd")
@onready var cotu := $/root/Arena/cotuCB
@onready var target := $/root/Arena/Target
@onready var hitbox := $PlayerHitbox

func _ready():
	initial_throw_angle = petals*cotu.look_angle + initial_throw_angle_offset
	invincible = true
	await get_tree().create_timer(invincibility_secs).timeout
	invincible = false

func set_direction(walk_input):
	if walk_input.x > 0:
		speed *= -1
		angle = (-2*PI - initial_throw_angle) / petals
	else:
		# initial angle = (2PI - initial_throw_angle) / petals
		angle = (2*PI - initial_throw_angle) / petals
	
func rose(delta):
	angle += speed * delta
	radius = max_radius * sin(petals * angle + initial_throw_angle)
	var angle_vec := Vector2.from_angle(angle)
	return target.global_position + radius * Vector3(angle_vec.x, 0, angle_vec.y)

func _physics_process(delta):
	var new_pos = rose(delta)
	# vel_vec is in meters per frame, which is what move_and_collide wants
	var vel_vec = new_pos - global_position
	var hit_arena = handle_collision(move_and_collide(vel_vec, true), vel_vec, delta)
	if hit_arena:
		set_script(ricochet_script)
		return
	global_position = new_pos
	if Input.is_action_just_pressed("Special") and target.following_cotu and global_position.distance_to(cotu.global_position) < SPECIAL_DIST:
		set_script(rapidorbit_script)

func buff_rang():
	hitbox.damage += 10

func handle_collision(collision, vel_vec, delta):
	if not collision:
		return false
	if not invincible and collision.get_collider() == cotu and not cotu.is_dodging:
		queue_free()
		return false
	elif collision.get_collider().collision_layer == Globals.ARENA_COL_LAYER:
		velocity = (1/delta) * (vel_vec - 2 * vel_vec.project(collision.get_normal()))
		return true
