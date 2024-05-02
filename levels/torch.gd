extends Area3D

@export var begin_glow_secs := .5
@export var maintain_glow_secs := 30
@export var fade_secs := 5
@export var base_energy := 5.0
var can_be_lit := true

func _on_area_3d_body_entered(body):
	if can_be_lit and body.name.contains("Roserang"):
		activate_torch()

func activate_torch():
	can_be_lit = false
	var tween = create_tween()
	# Light up the torch, i.e. begin glow
	tween.tween_property($TorchLight, "light_energy", base_energy, begin_glow_secs)
	# Keep the torch lit; the reason why tween is used again instead of awaiting a timer is so that the tween can maintain its queue of tween_property calls; i.e. I let the tween time everything on its own
	tween.tween_property($TorchLight, "light_energy", base_energy, maintain_glow_secs)
	# Gradually fade the torch to darkness
	tween.tween_property($TorchLight, "light_energy", 0, fade_secs)
	# Set can_be_lit via tween so that it's set after all other tween actions
	tween.tween_property(self, "can_be_lit", true, 0)
