extends RayCast3D

# Step target = Vector3 that is constantly set to a position on the ground.
# IK target = the actual node that a Skeleton3D chain points to. Only moves when stepping.
# When the step target is too far from the IK target, a step occurs

# This script sets the step target position every frame

var step_target := Vector3.ZERO

func _physics_process(_delta):
	# Raycast downward to get ground normal
	var result = get_collision_point()
	if result:
		step_target = result
