extends Ball

@onready var root := $/root/ViewControl
var target : Node3D
var moving := true

@export var disappear_secs := 3.0
@export var min_speed := 7.0

func _ready():
	target = root.find_child("Icon")
	$EnemyHitbox.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(_delta):
	if linear_velocity.length() < min_speed:
		moving = false
		$AnimationPlayer.play("explode")
		await get_tree().create_timer(disappear_secs).timeout
		queue_free()
