extends CharacterBody3D

var invincible := true
var invincibility_secs := .5

@export var rotate_speed := .1
@export var fwd_speed := 1.0

@onready var root := $/root/ViewControl
var level : Node3D
var cotu : Node3D
var target : Node3D

@onready var pivot = $AxrangPivot

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	target = level.find_child("Icon")
	
	global_position = target.global_position
	rotation.y = cotu.armature.rotation.y
	velocity = fwd_speed * transform.basis.z

func _physics_process(delta):
	pivot.rotate_x(rotate_speed)
	var vel_vec = fwd_speed * transform.basis.z
	move_and_collide(vel_vec, false)
	#global_position += vel_vec * delta
