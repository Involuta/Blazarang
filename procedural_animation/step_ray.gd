extends Node3D

# Step target = child of mite that is constantly set to a position on the ground.
# IK target = the actual node that a Skeleton3D chain points to. Only moves when stepping.
# When the mite's step target is too far from the IK target, a step occurs

# This script sets the step target position every frame

@export var step_target : Node3D

func _physics_process(_delta):
	# Raycast downward to get ground normal
	var space_state := get_world_3d().direct_space_state
	var sight_dir := Vector3(0.05,-1,0.05)
	var query = PhysicsRayQueryParameters3D.create(global_position - 10.0*sight_dir, global_position + 50.0*sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER])
	var result = space_state.intersect_ray(query)
	if result:
		#print("Step target global pos: ", step_target.global_position)
		step_target.global_position = result.position
