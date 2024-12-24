extends CharacterBody3D

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var gravity := 0.0
var rang_ricochet_height := 15.0
@onready var root := $/root/ViewControl
var target : Node3D
var cotu : CharacterBody3D

func _ready():
	target = root.find_child("Icon")
	cotu = root.find_child("cotuCB")
	gravity = default_gravity

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	handle_collision(move_and_collide(velocity * delta))
	#global_position += velocity * delta

func ricochet_rang_hit(collision_normal):
	velocity = velocity - 2 * velocity.project(collision_normal)
	velocity.y = rang_ricochet_height

func handle_collision(collision):
	if collision:
		#print(instance_from_id(collision.get_collider_id()).name)
		var cl = collision.get_collider().collision_layer
		if Globals.compare_layers(cl, Globals.ARENA_COL_LAYER) or Globals.compare_layers(cl, Globals.THICK_ENEMY_COL_LAYER) or Globals.compare_layers(cl, Globals.COTU_COL_LAYER):
			velocity = velocity - 2 * velocity.project(collision.get_normal())
			#velocity = velocity - 2 * collision.get_normal()
		elif Globals.compare_layers(cl, Globals.ENEMY_BOUND_COL_LAYER):
			velocity = Vector3.ZERO
			gravity = 0
			await get_tree().create_timer(.5).timeout
			velocity = 60 * global_position.direction_to(target.global_position)

func rose_rang_hit(_collision, _vel_vec, _delta):
	var dir_from_cotu := Vector2(global_position.x - cotu.global_position.x, global_position.z - cotu.global_position.z).normalized()
	velocity = velocity.length() * Vector3(dir_from_cotu.x, 0, dir_from_cotu.y)
	velocity.y = rang_ricochet_height
