extends Area3D

var following_cotu := true

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
	if body.name.contains("roserang"):
		start_following_cotu()
		body.buff_rang()
