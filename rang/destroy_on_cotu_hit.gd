extends Area3D

@onready var root := $/root/ViewControl
var cotu : Node3D
@onready var rang = get_parent()

func _ready():
	cotu = root.find_child("cotuCB")

func _on_body_entered(body):
	if not rang.invincible and body == cotu:
		if rang.name == "Roserang" and not cotu.is_dodging:
			Globals.combo_count = 0
			rang.queue_free()
		elif rang.name == "Axrang":
			Globals.combo_count = 0
			rang.queue_free()
