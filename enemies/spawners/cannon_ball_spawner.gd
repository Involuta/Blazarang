extends BallSpawner

@onready var animation_player := $AnimationPlayer

func _ready():
	super()
	target = root.find_child("Icon")
	add_to_group("lockonables")

func _physics_process(delta):
	super(delta)
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)

func lerp_look_at_target(turn_speed):
	var old_rotation := rotation
	look_at(target.global_position)
	var target_rotation := rotation
	rotation = old_rotation
	rotation.y = lerp_angle(rotation.y, target_rotation.y, turn_speed)
	rotation.x = lerp_angle(rotation.x, target_rotation.x, turn_speed)
	rotation.z = lerp_angle(rotation.z, target_rotation.z, turn_speed)

func stop_aiming_at_target():
	aiming_at_target = false
