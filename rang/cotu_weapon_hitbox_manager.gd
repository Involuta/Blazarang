extends Node

# This script is attached to a direct child Node of all Cotu weapons

var hitboxes : Array[Node3D]

var pre_multiplier_damage := 0.0 # Damage of the weapon before multipliers are applied. Set by the weapon script
var damage_multiplier := 0.0 # Hitbox's damage is pre_multiplier_damage * (1 + damage_multiplier)

func _ready():
	for child in get_parent().get_siblings():
		if "Hitbox" in child.name:
			hitboxes.append(child)

func add_damage_multiplier(mult):
	damage_multiplier += mult
	for hitbox in hitboxes:
		hitbox.damage = pre_multiplier_damage * (1 + mult)
