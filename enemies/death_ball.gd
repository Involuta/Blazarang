extends CharacterBody3D

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var rang_ricochet_height := 15.0

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= default_gravity * delta
	handle_collision(move_and_collide(velocity * delta, true))
	global_position += velocity * delta

func ricochet_rang_ricochet(collision_normal):
	velocity = velocity - 2 * velocity.project(collision_normal)
	velocity.y = rang_ricochet_height

func handle_collision(collision):
	if collision:
		var cl = collision.get_collider().collision_layer
		if cl == Globals.ARENA_COL_LAYER or cl == Globals.THICK_ENEMY_COL_LAYER:
			velocity = velocity - 2 * velocity.project(collision.get_normal())

func rose_rang_hit(collision, vel_vec, _delta):
	velocity = velocity.length() * (-vel_vec - 2 * -vel_vec.project(collision.get_normal()))
	velocity.y = rang_ricochet_height
