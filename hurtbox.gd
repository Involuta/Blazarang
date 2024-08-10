class_name Hurtbox
extends Area3D

var rng := RandomNumberGenerator.new()
@export var dp_impulse_limit := 5
@export var dp_count := 5
var health := 100.0
var max_health := 100.0
@export var opponent_hitboxes := ["default"]
@onready var parent := get_parent()
@onready var level := $/root/Level

var invincible = false

func _ready():
	area_entered.connect(on_hit)

func on_hit(hitbox):
	if hitbox.name in opponent_hitboxes:
		if "is_dodging" in parent:
			if not parent.is_dodging:
				receive_hit(hitbox.damage, hitbox.get_parent())
			else:
				return
		else:
			receive_hit(hitbox.damage, hitbox.get_parent())

func receive_hit(damage: float, _hitter):
	health -= damage
	if health <= 0:
		die()

func _physics_process(_delta):
	if invincible:
		health = max_health
	
func die():
	parent.queue_free()
