extends RigidBody3D
class_name Ball

@export var entity_name := "Ball"

func _physics_process(_delta):
	var new_pos = rose(delta)
	# vel_vec is in meters per frame, which is what move_and_collide wants
	var vel_vec = new_pos - global_position
	look_at(new_pos)
	var hit_arena = rose_handle_collision(move_and_collide(vel_vec, true), vel_vec, delta)
	if global_position.y < -100:
		queue_free()

func ricochet(collision):
	velocity = velocity - 2 * velocity.project(collision.get_normal())

func rose_handle_collision(collision, vel_vec, delta):
	if collision and (Globals.compare_layers(collision.get_collider().collision_layer, Globals.ARENA_COL_LAYER) or Globals.compare_layers(collision.get_collider().collision_layer, Globals.THICK_ENEMY_COL_LAYER)):
		velocity = (1/delta) * (vel_vec - 2 * vel_vec.project(collision.get_normal()))
		#emit_ricochet_particles(vel_vec)
		#ricochet_sfx.play()
		return true
	return false

func ricochet_handle_collision(collision):
	if collision and (collision.get_collider().collision_layer == Globals.ARENA_COL_LAYER or collision.get_collider().collision_layer == Globals.THICK_ENEMY_COL_LAYER):
		ricochet(collision)
		#emit_ricochet_particles(collision.get_normal())
		#ricochet_sfx.play()
