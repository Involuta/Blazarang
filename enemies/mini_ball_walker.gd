extends CharacterBody3D

@onready var anim_player := $MiniBallWalkerMeshes/AnimationPlayer
@onready var root := $/root/ViewControl
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var hitbox : Node3D
var target : Node3D
var moving := true

@export var disappear_secs := 3.0

# Set by spawner
var follow_speed := 10.0
var explode_dist := 4.0

func _ready():
	target = root.find_child("Icon")
	hitbox = find_child("EnemyHitbox")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func _physics_process(_delta):
	if moving:
		velocity.y -= gravity
		var dir_to_target := global_position.direction_to(target.global_position)
		velocity.x = follow_speed * dir_to_target.x
		velocity.z = follow_speed * dir_to_target.z
		move_and_slide()
		
		if global_position.distance_to(target.global_position) < explode_dist:
			moving = false
			anim_player.play("kick")
			await get_tree().create_timer(disappear_secs).timeout
			moving = true
	else:
		velocity = Vector3.ZERO
