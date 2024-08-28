extends Level

@onready var icon := $Target

func _ready():
	icon.visible = false
	$UIRoot.awaken()
	await get_tree().create_timer(2).timeout
	icon.visible = true
	icon.global_position = Vector3.UP * 100.0
