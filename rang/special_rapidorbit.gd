extends CharacterBody3D

# Song BPMs:
# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
const SPECIAL_DIST := 7 # max dist from Cotu where doing special input will perform a special move

var BPM := 113.0
var radius := 0.0
var initial_radius := 3.0
var final_radius := 7.0
var angle := 0.0
var speed := 25.0
var duration_secs := 1.5

var invincible := true

@onready var cotu = $/root/Level/cotuCB
@onready var target = $/root/Level/Icon
@onready var hitbox = $PlayerHitbox

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)
	angle = 0
	radius = initial_radius
	$PlayerHitbox.damage *= 1.5
	await get_tree().create_timer(duration_secs).timeout
	queue_free()
	
func rapidorbit(delta):
	angle += speed * delta
	radius += (final_radius - initial_radius) / duration_secs * delta
	var angle_vec := Vector2.from_angle(angle)
	global_position = target.global_position + radius * Vector3(angle_vec.x, 0, angle_vec.y)

func _physics_process(delta):
	rapidorbit(delta)

func get_mvmt_state():
	return "RAPIDORBIT"
