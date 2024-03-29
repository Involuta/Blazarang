class_name Hurtbox
extends Area3D

var rng := RandomNumberGenerator.new()
@export var dp_impulse_limit := 5
@export var dp_count := 5
@export var health := 100
@export var enemy_hitboxes := ["default"]
@onready var parent := get_parent()
@onready var arena := $/root/Arena

func _ready():
	area_entered.connect(on_hit)

func on_hit(hitbox):
	if hitbox.name in enemy_hitboxes:
		if "is_dodging" in parent:
			if not parent.is_dodging:
				receive_hit(hitbox.damage, hitbox.get_parent())
			else:
				return
		else:
			receive_hit(hitbox.damage, hitbox.get_parent())

func receive_hit(damage: int, hitter):
	health -= damage
	if health <= 0:
		die()
	
func die():
	parent.queue_free()
