extends Marker3D

# Step target = child of mite that is constantly set to a position on the ground.
# IK target = the actual node that a Skeleton3D chain points to. Only moves when stepping.
# When the mite's step target is too far from the IK target, a step occurs

# This script is inside of each IK target. It performs steps by moving the IK target when needed

@export var step_target : Node3D
@export var step_distance := 1.0

# Adjacent target = IK target horizontally opposite this IK target
# Only step when you're not stepping and the adjacent target isn't stepping
@export var adjacent_target : Node3D
var is_stepping := false

func _process(delta):
	if not is_stepping and not adjacent_target.is_stepping and global_position.distance_to(step_target.global_position) > step_distance:
		step()

func step():
	var target_pos = step_target.global_position
	var half_way = (global_position + step_target.global_position) / 2
	is_stepping = true
	
	var step_tween = get_tree().create_tween()
	step_tween.tween_property(self, "global_position", half_way + owner.basis.y, .05)
	step_tween.tween_property(self, "global_position", target_pos, .05)
	step_tween.tween_callback(func(): is_stepping = false)
