extends Level

func _ready():
	super()
	#$MusicPlayer.play()
	root.get_node("UIRoot").hide_black_screen()
	$EntranceDoorRight.add_constant_force(20*Vector3.RIGHT)
	$EntranceDoorForward.add_constant_force(20*Vector3.FORWARD)
	$EntranceDoorBack.add_constant_force(20*Vector3.BACK)
	$EntranceDoorLeft.add_constant_force(20*Vector3.LEFT)
	$EntranceCeiling.add_constant_force(20*Vector3.UP)
