extends Label3D

func _ready():
	# Randomized direction so numbers don't stack perfectly
	var tween = get_tree().create_tween().set_parallel(true)
	var random_x = randf_range(-1.0, 1.0)
	
	# Animate position (float upwards and slightly sideways)
	tween.tween_property(self, "position", position + Vector3(random_x, 1.5, 0), 1.0)
	
	# Animate scale (pop effect)
	scale = Vector3.ZERO
	tween.tween_property(self, "scale", Vector3.ONE, 0.2).set_trans(Tween.TRANS_BACK)
	
	# Animate transparency (fade out)
	tween.tween_property(self, "modulate:a", 0.0, .7).set_delay(0.3)
	tween.tween_property(self, "outline_modulate:a", 0.0, .7).set_delay(0.3)
	# Remove the node when finished
	tween.chain().tween_callback(queue_free)

func setup(amount: float, color: Color = Color.LIGHT_SALMON):
	text = str(round(amount))
	modulate = color
	# Optional: Change color based on damage amount or type
	if amount > 50:
		modulate = Color.GOLD
