extends Area3D

@onready var cotu = $/root/Arena/cotuCB
@onready var roserang = get_parent()

func _on_body_entered(body):
	if not roserang.invincible and body == cotu and not cotu.is_dodging:
		roserang.queue_free()
