extends Node3D

@export var max_lifetime_secs := 100.0
var destroyed := false

@onready var impact_particles := $ImpactParticles

func _ready():
	impact_particles.emitting = true
	become_ground_web()
	await get_tree().create_timer(max_lifetime_secs).timeout
	if not destroyed and self:
		destroy_self()

# Func is called by mite_level_main_arena on both enemies and bigwebs, so bigwebs need this func
func set_active(_active):
	pass

func _on_body_entered(body):
	# Prevents collision with other ground webs and paramites; all non-paramites are thick enemies
	if Globals.compare_layers(body.collision_layer, Globals.ENEMY_COL_LAYER) or Globals.compare_layers(body.collision_layer, Globals.ARENA_COL_LAYER):
		pass
	else:
		destroy_self()

func become_ground_web():
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
	# Await disappear effect here
	queue_free()
