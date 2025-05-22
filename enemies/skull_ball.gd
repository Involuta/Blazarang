extends Ball

@onready var root := $/root/ViewControl
var target : Node3D
enum {
	PASSIVE,
	FOLLOW,
	EXPLODE
}
var behav_state = PASSIVE

@export var disappear_secs := 3.0

# Set by spawner
var follow_speed := 10.0
var explode_dist := 4.0

func _ready():
	target = root.find_child("Icon")
	$EnemyHitbox.process_mode = Node.PROCESS_MODE_DISABLED
	$LaughStreamPlayer.play()
	await get_tree().create_timer(1).timeout
	behav_state = FOLLOW

func _physics_process(_delta):
	match(behav_state):
		PASSIVE:
			pass
		FOLLOW:
			var dir_to_target := global_position.direction_to(target.global_position)
			linear_velocity.x = follow_speed * dir_to_target.x
			linear_velocity.z = follow_speed * dir_to_target.z
			
			if global_position.distance_to(target.global_position) < explode_dist:
				behav_state = EXPLODE
				$AnimationPlayer.play("explode")
				await get_tree().create_timer(disappear_secs).timeout
				queue_free()
		EXPLODE:
			linear_velocity = Vector3.ZERO
