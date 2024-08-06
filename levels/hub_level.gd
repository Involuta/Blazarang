extends Level

func _ready():
	super()

func _on_exit_room_body_entered(body):
	get_tree().change_scene_to_file("res://levels/gauntlet_level1.tscn")
