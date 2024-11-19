extends Area3D

@onready var root := $/root/ViewControl
var cotu : Node3D
@onready var roserang = get_parent()

func _ready():
	cotu = root.find_child("cotuCB")

func _on_body_entered(body):
	if not roserang.invincible and body == cotu and not cotu.is_dodging:
		Globals.combo_count = 0
		roserang.queue_free()
