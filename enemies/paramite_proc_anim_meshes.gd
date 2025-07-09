extends Node3D

# Huge thanks to Crigz Vs Game Dev on YouTube for the Spider Bot Procedural Animation tutorial!

@export var run_speed := 10.0
@export var turn_speed := 1.0
@export var ground_offset := 1.0 # Height of mite's body from the ground
@export var arena_height := 10.0

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

var ik_stopped := false

func _process(delta):
	#return
	if ik_stopped:
		return
	
	# Create 2 planes made from the 4 IK targets and get the average of their normals
	var plane1 = Plane(lmb_ik.position, lvf_ik.position, rvf_ik.position)
	var plane2 = Plane(rvf_ik.position, rmb_ik.position, lmb_ik.position)
	var avg_normal = ((plane1.normal + plane2.normal) / 2).normalized()
	
	parent.ground_normal = avg_normal
	
	return
	
	# Convert the normal to a basis, then a quaternion to prevent a "Basis must be normalized" error, then convert the lerped quaternion back to a Basis
	var target_basis = _basis_from_normal(avg_normal)
	transform.basis = lerp(transform.basis, target_basis, run_speed * delta).orthonormalized()
	
	# Offset body from the ground
	var avg_ik_pos = (lvf_ik.position + rmb_ik.position + rvf_ik.position + lmb_ik.position + lmf_ik.position + rvb_ik.position + rmf_ik.position + lvb_ik.position) / 8
	var target_pos = avg_ik_pos + transform.basis.y * ground_offset
	# Dot product gets the difference in positions only in this direction
	var dist_to_target_pos = transform.basis.y.dot(target_pos - global_position)
	#global_position = lerp(global_position, global_position + transform.basis.y * dist_to_target_pos, run_speed * delta)

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
