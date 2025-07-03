extends Node3D

# Huge thanks to Crigz Vs Game Dev on YouTube for the Spider Bot Procedural Animation tutorial!

@export var run_speed := 10.0
@export var turn_speed := 1.0
@export var ground_offset := .5 # Height of mite's body from the ground

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

func _process(delta):
	# Create 2 planes made from the 4 IK targets and get the average of their normals
	var plane1 = Plane(lmb_ik.position, lvf_ik.position, rvf_ik.position)
	var plane2 = Plane(rvf_ik.position, rmb_ik.position, lmb_ik.position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	# Convert the normal to a basis
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, run_speed * delta).orthonormalized()
	
	# Offset body from the ground
	var avg_ik_pos = (lvf_ik.position + rmb_ik.position + rvf_ik.position + lmb_ik.position + lmf_ik.position + rvb_ik.position + rmf_ik.position + lvb_ik.position) / 8
	var target_pos = avg_ik_pos + transform.basis.y * ground_offset
	# Dot product gets the difference in positions only in this direction
	var dist_to_target_pos = transform.basis.y.dot(target_pos - position)
	position = lerp(position, position + transform.basis.y * dist_to_target_pos, run_speed * delta)
	
	_movement(delta)

func _movement(delta):
	var move_dir = Input.get_vector("WalkLeft", "WalkRight", "WalkForward", "WalkBackward")
	translate(Vector3(0, 0, -move_dir.y) * run_speed * delta)
	rotate_object_local(Vector3.UP, -move_dir.x * turn_speed * delta)

func _basis_from_normal(normal: Vector3) -> Basis:
	var result = Basis()
	result.x = normal.cross(transform.basis.z)
	result.y = normal
	result.z = transform.basis.x.cross(normal)
	
	result = result.orthonormalized()
	result.x *= scale.x
	result.y *= scale.y
	result.z *= scale.z
	
	return result
