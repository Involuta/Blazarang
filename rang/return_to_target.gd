extends CharacterBody3D

const MAX_SPEED := 50
const SPECIAL_DIST := 7 # max dist from Cotu where doing special input will perform a special move
var roserang_script := preload("res://rang/roserang.gd")
var rapidorbit_script := preload("res://rang/special_rapidorbit.gd")
@onready var cotu = $/root/Arena/cotuCB
@onready var target = $/root/Arena/Target
@onready var hitbox = $PlayerHitbox

func _init():
	# When this script is assigned to roserang, _init() is called, but not _ready() bc the roserang is already in the scene tree, and _ready() is only called when a node enters the scene tree for the first time. To get the @onready values, you must call _ready() manually
	_ready()

func _ready():
	set_collision_mask_value(Globals.ARENA_COL_LAYER, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target.roserang_queued:
		target.rang_thrown = false
		set_script(roserang_script)
		return
	velocity = velocity.move_toward(MAX_SPEED * global_position.direction_to(target.global_position), 5)
	#velocity = velocity.length() * global_position.direction_to(target.global_position)
	handle_collision(move_and_collide(velocity * delta), delta)
	if Input.is_action_just_pressed("Special") and target.following_cotu and global_position.distance_to(cotu.global_position) < SPECIAL_DIST:
		set_script(rapidorbit_script)

func buff_rang():
	hitbox.damage += 10

func handle_collision(collision, delta):
	if not collision:
		return
	if collision.get_collider() == cotu and not cotu.is_dodging:
		queue_free()
