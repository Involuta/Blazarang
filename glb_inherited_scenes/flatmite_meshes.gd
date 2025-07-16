extends Node3D

# Ground slope-based rotation and ground offset of meshes must be separate from parent rotation (dir the mite faces to match its vel)

@export var ground_offset := 1.0

func _process(delta):
	# Raycast downward to get ground normal
	var space_state := get_world_3d().direct_space_state
	var sight_dir := Vector3.DOWN
	var query = PhysicsRayQueryParameters3D.create(global_position - sight_dir, global_position + 10.0 * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if not result:
		return
	var avg_normal = result.normal
	
	# Convert the normal to a basis, then a quaternion to prevent a "Basis must be normalized" error, then convert the lerped quaternion back to a Basis
	draw_vector_line(avg_normal * 10)
	var target_basis = _basis_from_normal(avg_normal)
	rotation = lerp(transform.basis.get_rotation_quaternion(), target_basis.get_rotation_quaternion(), .15).get_euler()
	
	# Offset body from the ground
	var target_pos = result.position + transform.basis.y * ground_offset
	# Dot product gets the difference in positions only in this direction
	var dist_to_target_pos = transform.basis.y.dot(target_pos - global_position)
	position = lerp(position, position + transform.basis.y * dist_to_target_pos, .15)
	
	return

# If you want to see the normal vec of the mite's body meshes, add a new MeshInstance3D child to the mite parent (sibling of paramite proc anim meshes), and don't give it a mesh property. Just drag it into the Inspector field in this script
@export var normal_line : MeshInstance3D

func draw_vector_line(vec: Vector3):
	var mesh = ImmediateMesh.new()
	mesh.clear_surfaces()
	mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	mesh.surface_add_vertex(Vector3.ZERO)
	mesh.surface_add_vertex(Vector3.ZERO + vec)
	mesh.surface_end()
	if not normal_line:
		return
	normal_line.mesh = mesh

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	
	return result
