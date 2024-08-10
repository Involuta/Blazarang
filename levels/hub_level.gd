extends Level

func _ready():
	super()
	$ExitDoor.position = Vector3(-10.25, 4.25, 0)

func _on_exit_room_body_entered(_body):
	# Move ExitDoor y pos from 4.25 to 1.75
	var tween = get_tree().create_tween()
	tween.tween_property($ExitDoor, "position", Vector3(-10.25, 1.75, 0), 1)
	tween.tween_property($hub_room1/OmniLight3D, "omni_range", 10, 1)
	await get_tree().create_timer(2).timeout
	get_tree().change_scene_to_file("res://levels/gauntlet_level1.tscn")
