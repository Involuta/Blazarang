extends Node3D

# Huge thanks to Crigz Vs Game Dev on YouTube for the Spider Bot Procedural Animation tutorial!

@export var run_speed := 40.0
@export var turn_speed := 1.0
@export var ground_offset := 1.0 # Height of mite's body from the ground

# Why are these nodes export and not onready? So that the paramite, flatmite, jumping spider, etc. can use the same script

# Leg IK targets; note that their positions are also their global positions
# vf = very front, mb = middle back, mf = middle front, vb = very back
@export var lvf_ik : Marker3D
@export var rmb_ik : Marker3D
@export var rvf_ik : Marker3D
@export var lmb_ik : Marker3D
@export var lmf_ik : Marker3D
@export var rvb_ik : Marker3D
@export var rmf_ik : Marker3D
@export var lvb_ik : Marker3D

# Skeleton IK nodes; disabled when mite leaves the ground
@export var lvf_sk : SkeletonIK3D
@export var rmb_sk : SkeletonIK3D
@export var rvf_sk : SkeletonIK3D
@export var lmb_sk : SkeletonIK3D
@export var lmf_sk : SkeletonIK3D
@export var rvb_sk : SkeletonIK3D
@export var rmf_sk : SkeletonIK3D
@export var lvb_sk : SkeletonIK3D

@onready var parent := get_parent()
var avg_normal := Vector3.UP # This is visible in the entire script so that the parent can see it; if it's Vector3.UP, the parent can leap

var ik_stopped := false # IK is stopped when leaping

var biting := false

func _process(delta):
	if ik_stopped:
		return
	
	# Raycast downward to get ground normal
	var space_state := get_world_3d().direct_space_state
	var sight_dir := Vector3.DOWN
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + 10.0 * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if not result:
		return
	avg_normal = result.normal
	
	# Convert the normal to a basis, then a quaternion to prevent a "Basis must be normalized" error, then convert the lerped quaternion back to a Basis
	draw_vector_line(avg_normal * 10)
	var target_basis = _basis_from_normal(avg_normal)
	rotation = lerp(transform.basis.get_rotation_quaternion(), target_basis.get_rotation_quaternion(), run_speed * delta).get_euler()
	
	# Biting moves body meshes' position, so if biting, this script should not change position
	if biting:
		return
	
	# Offset body from the ground
	var avg_ik_pos = (lvf_ik.position + rmb_ik.position + rvf_ik.position + lmb_ik.position + lmf_ik.position + rvb_ik.position + rmf_ik.position + lvb_ik.position) / 8
	var target_pos = avg_ik_pos + transform.basis.y * ground_offset
	# Dot product gets the difference in positions only in this direction
	var dist_to_target_pos = transform.basis.y.dot(target_pos - global_position)
	position = lerp(position, position + transform.basis.y * dist_to_target_pos, run_speed * delta)
	
	# Uncomment this line to move spider using player controls
	#_movement(delta)

func _movement(delta):
	var move_dir = Input.get_vector("WalkLeft", "WalkRight", "WalkForward", "WalkBackward")
	translate(Vector3(0, 0, -move_dir.y) * run_speed * delta)
	rotate_object_local(Vector3.UP, -move_dir.x * turn_speed * delta)

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

func stop_ik_front_legs():
	lvf_sk.stop()
	rvf_sk.stop()
	lmf_sk.stop()
	rmf_sk.stop()

func start_ik_front_legs():
	lvf_sk.start()
	lvf_ik.recalculate_ik_target()
	rvf_sk.start()
	rvf_ik.recalculate_ik_target()
	lmf_sk.start()
	lmf_ik.recalculate_ik_target()
	rmf_sk.start()
	rmf_ik.recalculate_ik_target()

func stop_ik():
	ik_stopped = true
	lvf_sk.stop()
	rmb_sk.stop()
	rvf_sk.stop()
	lmb_sk.stop()
	lmf_sk.stop()
	rvb_sk.stop()
	rmf_sk.stop()
	lvb_sk.stop()

func start_ik():
	ik_stopped = false
	lvf_sk.start()
	rmb_sk.start()
	rvf_sk.start()
	lmb_sk.start()
	lmf_sk.start()
	rvb_sk.start()
	rmf_sk.start()
	lvb_sk.start()
	
	lvf_ik.recalculate_ik_target()
	rmb_ik.recalculate_ik_target()
	rvf_ik.recalculate_ik_target()
	lmb_ik.recalculate_ik_target()
	lmf_ik.recalculate_ik_target()
	rvb_ik.recalculate_ik_target()
	rmf_ik.recalculate_ik_target()
	lvb_ik.recalculate_ik_target()
