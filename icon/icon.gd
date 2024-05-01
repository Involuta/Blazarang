extends Area3D

var following_cotu := true
var floored_proximity := .5 # dist from Cotu at which point Icon becomes floored

# For transition from ricochet/return to rose
var roserang_queued := false # did the rang just hit the target while in the ricochet or return state?
var rang_thrown := true # the roserang script has just readied; was the rang thrown by Cotu, or did it come from a ricochet or return state?

@onready var anim_tree = $AnimationTree
@onready var cotu = $/root/Level/cotuCB

func _ready():
	pass

func _physics_process(_delta):
	if Input.is_action_just_pressed("Special"):
		print(following_cotu)
	var dist_to_cotu := global_position.distance_to(cotu.global_position)
	var dir_to_cotu := global_position.direction_to(cotu.global_position)
	if following_cotu:
		global_position += dir_to_cotu * (dist_to_cotu / 4)
		if dist_to_cotu >= floored_proximity:
			look_at(cotu.global_position)
	anim_tree.set("parameters/StateMachine/CotuGroundedBlendSpace/blend_position", dist_to_cotu)
	anim_tree.set("parameters/StateMachine/CotuAirBlendSpace/blend_position", dist_to_cotu)

func start_following_cotu():
	following_cotu = true
	
func stop_following_cotu():
	following_cotu = false

func _on_body_entered(body):
	if body.name.contains("Roserang") and not body.invincible:
		if body.get_mvmt_state() != "ROSE":
			roserang_queued = true
		start_following_cotu()
		cotu.buff_self()
		body.buff_self()
		Globals.award_score(Globals.DODGE_SCORE)
