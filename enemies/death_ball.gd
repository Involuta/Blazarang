extends CharacterBody3D

var default_gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= default_gravity * delta
	handle_collision(move_and_collide(velocity * delta))

func handle_collision(collision):
	if collision:
		var cl = collision.get_collider().collision_layer
		if cl == Globals.ARENA_COL_LAYER or cl == Globals.PLAYER_COL_LAYER or cl == Globals.THICK_ENEMY_COL_LAYER:
			velocity = velocity - 2 * velocity.project(collision.get_normal())
