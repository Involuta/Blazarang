extends Area3D

var following_cotu := true

# For transition from rose to ricochet
var angle := 0.0
var angle_speed := 0.0
var max_angle := 0.0
# For transition from ricochet/return to rose
var roserang_queued := false # did the rang just hit the target while in the ricochet or return state?
var rang_thrown := true # the roserang script has just readied; was the rang thrown by Cotu, or did it come from a ricochet or return state?

@onready var cotu = $/root/Arena/cotuCB

func _ready():
	pass

func _process(_delta):
	if following_cotu:
		global_position += global_position.direction_to(cotu.global_position) * (global_position.distance_to(cotu.global_position) / 5)

func start_following_cotu():
	following_cotu = true
	
func stop_following_cotu():
	following_cotu = false

func _on_body_entered(body):
	if body.name.contains("roserang") and not body.invincible:
		if body.mvmt_state != body.ROSE:
			roserang_queued = true
		start_following_cotu()
		body.buff_rang()

func _on_area_entered(area):
	pass
	"""
	if area.name.contains("TargetCollider"):
		var roserang = area.get_parent()
		if roserang.mvmt_state != roserang.ROSE:
			roserang_queued = true
		start_following_cotu()
		roserang.buff_rang()
	else:
		print(area.name)
	"""
