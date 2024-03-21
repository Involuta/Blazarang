extends Area3D

# Champion of the Universe - 113
# It's Just You - 120
# BIZARROBOT - 120, 90
var BPM := 113.0
var max_radius := 30
var petals := 5

var speed := PI / (petals * 120 / BPM)
var angle := 0.0 # angle to calculate radius
var radius := 0.0 # dist from rose center at angle

var invincible := true
var invincibility_secs := .5
var initial_throw_angle := 0.0
var initial_throw_angle_offset := petals*PI-.05

@onready var cotu = $/root/Arena/cotuCB
@onready var target = $/root/Arena/Target
@onready var hitbox = $PlayerHitbox

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
	global_position = target.global_position + radius * Vector3(angle_vec.x, 0, angle_vec.y)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	rose(delta)

func _on_area_entered(area):
	if invincible:
		return
	if "Target" in area.name:
		area.start_following_cotu()
		buff_rang()

func _on_body_entered(body):
	if invincible:
		return
	if "cotu" in body.name and not body.is_dodging:
		body.is_rang_thrown = false
		queue_free()

func buff_rang():
	hitbox.damage += 10
