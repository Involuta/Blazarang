extends CharacterBody3D

enum {
	FWD,
	EXPLODE,
	RETURN
}
var mvmt_state = FWD

var invincible := true
var invincibility_secs := .5

@export var rotate_speed := .1

@export var fwd_speed := 1.0

@export var max_return_speed := 55
@export var return_acc := 1.2

@onready var root := $/root/ViewControl
var level : Node3D
var cotu : Node3D
var target : Node3D

@onready var pivot = $Pivot

func _ready():
	level = root.find_child("Level")
	cotu = root.find_child("cotuCB")
	target = level.find_child("Icon")
	
	global_position = target.global_position
	rotation.y = cotu.look_angle + PI
	velocity = fwd_speed * transform.basis.z

func _physics_process(delta):
	pivot.rotate_x(rotate_speed)
	var fwd_vec = fwd_speed * transform.basis.z
	match(mvmt_state):
		FWD:
			var vel_vec = fwd_speed * transform.basis.z
			move_and_collide(vel_vec, false)
		EXPLODE:
			pass
		RETURN:
			if velocity.length() < max_return_speed:
				velocity = (velocity.length() + return_acc) * global_position.direction_to(target.global_position)
			else:
				velocity = max_return_speed * global_position.direction_to(target.global_position)
			look_at(global_position + velocity)
			move_and_slide()

func advance_state():
	match(mvmt_state):
		FWD:
			switch_to_explode()
		EXPLODE:
			switch_to_return()
		RETURN:
			pass

func switch_to_explode():
	mvmt_state = EXPLODE

func switch_to_return():
	mvmt_state = RETURN
