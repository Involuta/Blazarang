extends Level

const GUNNER_BRIDGE_MAX_HEIGHT := 25.0
const GUNNER_BRIDGE_MIN_HEIGHT := 5.0
const GUNNER_BRIDGE2_START_MOVE_DELAY := 2
var gunner_bridge1_moving := false
var gunner_bridge2_moving := false
var gunner_bridge1_speed := 3.0
var gunner_bridge2_speed := -3.0
var gunner_bridge1_can_switch_dir := true
var gunner_bridge2_can_switch_dir := true

@onready var gunner_bridge1 = $GunnerBridge1
@onready var gunner_bridge2 = $GunnerBridge2

func _ready():
	return

func _physics_process(delta):
	if Input.is_action_just_pressed("Special"):
		gunner_bridge1_moving = true
		start_moving_bridge2_after_delay()
	if gunner_bridge1_moving:
		gunner_bridge1.linear_velocity = gunner_bridge1_speed * Vector3.UP
	if gunner_bridge2_moving:
		gunner_bridge2.linear_velocity = gunner_bridge2_speed * Vector3.UP
	if gb_reached_bounds(gunner_bridge1) and gunner_bridge1_can_switch_dir:
		gb1_switch_dir()
	if gb_reached_bounds(gunner_bridge2) and gunner_bridge2_can_switch_dir:
		gb2_switch_dir()

func start_moving_bridge2_after_delay():
	await get_tree().create_timer(GUNNER_BRIDGE2_START_MOVE_DELAY).timeout
	gunner_bridge2_moving = true

func gb_reached_bounds(gunner_bridge):
	return gunner_bridge.global_position.y > GUNNER_BRIDGE_MAX_HEIGHT or gunner_bridge.global_position.y < GUNNER_BRIDGE_MIN_HEIGHT

func gb1_switch_dir():
	gunner_bridge1_speed *= -1
	gunner_bridge1_can_switch_dir = false
	await get_tree().create_timer(.5).timeout
	gunner_bridge1_can_switch_dir = true
func gb2_switch_dir():
	gunner_bridge2_speed *= -1
	gunner_bridge2_can_switch_dir = false
	await get_tree().create_timer(.5).timeout
	gunner_bridge2_can_switch_dir = true
