extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
const SPECIAL_DIST := 7 # max dist from Cotu where doing special input will perform a special move

var duration_secs := 1.5

var rapidorbit_script := preload("res://rang/special_rapidorbit.gd")
@onready var cotu = $/root/Arena/cotuCB
@onready var target = $/root/Arena/Target
@onready var hitbox = $PlayerHitbox

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	await get_tree().create_timer(duration_secs).timeout
	queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	handle_collision(move_and_collide(velocity * delta), delta)
	if Input.is_action_just_pressed("Special") and target.following_cotu and global_position.distance_to(cotu.global_position) < SPECIAL_DIST:
		set_script(rapidorbit_script)

func ricochet(collision):
	velocity = velocity - 2 * velocity.project(collision.get_normal())

func buff_rang():
	hitbox.damage += 10

func handle_collision(collision, delta):
	if not collision:
		return
	if collision.get_collider() == cotu and not cotu.is_dodging:
		queue_free()
	elif collision.get_collider().collision_layer == Globals.ARENA_COL_LAYER:
		ricochet(collision)
