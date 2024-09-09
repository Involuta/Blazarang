extends Area3D

@onready var cotu = $/root/Level/cotuCB
@onready var roserang = get_parent()

func _on_body_entered(body):
	if not roserang.invincible and body == cotu and not cotu.is_dodging:
		Globals.combo_count = 0
		roserang.queue_free()
