extends Node3D

@onready var arena_infest_hitbox := $MiteCloudPivot/EnemyHitbox
var time_btwn_infest_switch_secs := 5.0 # Should be less than half the time it takes for debuff to disappear
var time_to_next_infest_switch_secs := 5.0

func _ready():
	time_to_next_infest_switch_secs = time_btwn_infest_switch_secs

func _physics_process(delta):
	time_to_next_infest_switch_secs -= delta
	if time_to_next_infest_switch_secs <= 0:
		time_to_next_infest_switch_secs = time_btwn_infest_switch_secs
		if arena_infest_hitbox.process_mode == Node.PROCESS_MODE_DISABLED:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_INHERIT
		else:
			arena_infest_hitbox.process_mode = Node.PROCESS_MODE_DISABLED
