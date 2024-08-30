extends Area3D

var following_cotu := true
var follow_cotu_min_dist := .5

# For transition from ricochet/return to rose
var roserang_queued := false # did the rang just hit the target while in the ricochet or return state?
var rang_thrown := true # the roserang script has just readied; was the rang thrown by Cotu, or did it come from a ricochet or return state?

@onready var anim_tree = $AnimationTree
@onready var cotu = $/root/Level/cotuCB
@onready var cotu_hurtbox = $/root/Level/cotuCB/Hurtbox

@export var icon_self_heal := 18.0
@export var buff_list := [Globals.BUFFS.DAMAGE, Globals.BUFFS.DAMAGE, Globals.BUFFS.DAMAGE]
@export var next_buff_index := 0

func _ready():
	pass

func _physics_process(_delta):
	var dist_to_cotu := global_position.distance_to(cotu.global_position)
	var dir_to_cotu := global_position.direction_to(cotu.global_position)
	if following_cotu:
		global_position += dir_to_cotu * (dist_to_cotu / 4)
	
	if (cotu.is_on_floor() and dist_to_cotu < follow_cotu_min_dist) or (!cotu.is_on_floor() and cotu.walk_input == Vector2.ZERO):
		rotation = Vector3.ZERO
	else:
		look_at(cotu.global_position)
	
	anim_tree.set("parameters/StateMachine/CotuGroundedBlendSpace/blend_position", dist_to_cotu)

func start_following_cotu():
	following_cotu = true
	
func stop_following_cotu():
	following_cotu = false

func _on_body_entered(body):
	if body.name.contains("Roserang") and not body.invincible:
		if body.get_mvmt_state() != "ROSE":
			roserang_queued = true
		start_following_cotu()
		cotu_hurtbox.self_heal(icon_self_heal)
		Globals.award_score(Globals.DODGE_SCORE)
		cotu.add_buff()
		# Why is apply_buffs_to_rang here? Rang is applied buffs when Cotu throws, instant rethrows, or the rang hits the icon
		cotu.apply_buffs_to_rang()
