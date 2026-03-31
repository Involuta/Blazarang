extends Node3D

# Script used in Ball Walker Radiation Zone, Harvestman, Blizzard

# This node should contain EnemyHitbox. Why isn't this node's own process_mode changed?
# It's in case this node needs to make any changes to itself or any outer node needs to change it 

@export var time_btwn_damage_ticks := .4
var time_after_prev_dmg_tick := 0.0
@onready var hitbox = $EnemyHitbox

func _physics_process(delta):
	time_after_prev_dmg_tick += delta
	if time_after_prev_dmg_tick >= time_btwn_damage_ticks:
		time_after_prev_dmg_tick = 0
		if hitbox.process_mode == Node.PROCESS_MODE_INHERIT:
			hitbox.process_mode = Node.PROCESS_MODE_DISABLED
		else:
			hitbox.process_mode = Node.PROCESS_MODE_INHERIT
