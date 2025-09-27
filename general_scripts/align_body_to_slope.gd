extends Node3D

# Huge thanks to Crigz Vs Game Dev on YouTube for the Spider Bot Procedural Animation tutorial!

@export var run_speed := 10.0
@export var turn_speed := 1.0
@export var ground_offset := 1.5 # Height of mite's body from the ground

@onready var parent := get_parent()
var avg_normal := Vector3.UP # This is visible in the entire script so that the parent can see it; if it's Vector3.UP, the parent can leap

var alignment_disabled := false

func _process(delta):
	if alignment_disabled:
		return
	
	# Raycast downward to get ground normal
	var space_state := get_world_3d().direct_space_state
	var sight_dir := Vector3.DOWN
	var query = PhysicsRayQueryParameters3D.create(global_position - 10.0*sight_dir, global_position + 20.0*sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if not result:
		return
	avg_normal = result.normal
	
	# Convert the normal to a basis, then a quaternion to prevent a "Basis must be normalized" error, then convert the lerped quaternion back to a Basis
	draw_vector_line(avg_normal * 10)
	var target_basis = Globals.basis_from_normal(transform, avg_normal)
	rotation = lerp(transform.basis.get_rotation_quaternion(), target_basis.get_rotation_quaternion(), run_speed * delta).get_euler()
	
	# Offset body from the ground
	var avg_ik_pos = result.position
	var target_pos = avg_ik_pos + transform.basis.y * ground_offset
	# Dot product gets the difference in positions only in this direction
	var dist_to_target_pos = transform.basis.y.dot(target_pos - global_position)
	position += transform.basis.y * dist_to_target_pos

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
