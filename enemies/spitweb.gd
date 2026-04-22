extends Node3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var velocity := Vector3.ONE
@export var max_lifetime_secs := 32.0
var invincible := true # prevents bullet from hitting self
var invincibility_secs := .05
var lifetime := 0.0
var grounded := false
@export var bullet_explosion_secs := 1.0
var destroyed := false

@onready var flight_particles := $FlightParticles
@onready var impact_particles := $ImpactParticles

func _physics_process(delta):
	# Why not use a tween? When the web is destroyed, the tween is destroyed early, which creates an error message and likely some overhead deallocation/destruction that causes lag
	lifetime += delta
	if lifetime > invincibility_secs and invincible:
		invincible = false
	if lifetime > max_lifetime_secs and not destroyed and self:
		destroy_self()
		return
	
	if not grounded:
		global_position += velocity * delta
		look_at(global_position - velocity, Vector3.UP)
		velocity.y -= gravity * delta

func _on_body_entered(body):
	if invincible:
		return
	
	# Prevents collision with other ground webs and paramites; all non-paramites are thick enemies
	if Globals.compare_layers(body.collision_layer, Globals.ENEMY_COL_LAYER):
		pass
	elif Globals.compare_layers(body.collision_layer, Globals.ARENA_COL_LAYER):
		become_ground_web()
	else:
		destroy_self()

func become_ground_web():
	grounded = true
	velocity.y = 0
	$AnimationPlayer.play("become_ground_web")
	
	# Raycast downward to get ground normal
	var space_state := get_world_3d().direct_space_state
	var sight_dir := Vector3.DOWN
	var query = PhysicsRayQueryParameters3D.create(global_position - 10.0*sight_dir, global_position + 20.0*sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if not result:
		return
	
	# Convert the normal to a basis, then a quaternion to prevent a "Basis must be normalized" error, then convert the lerped quaternion back to a Basis
	var target_basis = Globals.basis_from_normal(transform, result.normal)
	rotation = target_basis.get_rotation_quaternion().get_euler()
	
	# Offset body from the ground
	var avg_ik_pos = result.position
	var target_pos = avg_ik_pos + .25 * transform.basis.y
	# Dot product gets the difference in positions only in this direction
	var dist_to_target_pos = transform.basis.y.dot(target_pos - global_position)
	position += transform.basis.y * dist_to_target_pos

func destroy_self():
	destroyed = true
	# For whatever reason, high velocity apparently makes the particles disappear early
	velocity = Vector3.ZERO
	queue_free()
