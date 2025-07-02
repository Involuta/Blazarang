extends RayCast3D

@export var step_target : Node3D

# Step target = child of mite that is constantly set to a position on the ground.
# IK target = the actual node that a Skeleton3D chain points to. Only moves when stepping.
# When the mite's step target is too far from the IK target, a step occurs

# This script sets the step target position every frame

func _physics_process(delta):
	var hit_point = get_collision_point()
	if hit_point:
		step_target.global_position = hit_point
