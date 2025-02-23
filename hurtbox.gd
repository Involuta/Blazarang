class_name Hurtbox
extends Area3D

var rng := RandomNumberGenerator.new()
@export var dp_impulse_limit := 5
@export var dp_count := 5
var health := 100.0
var max_health := 100.0 # This is only set by the Globals script or the CotuHurtbox script.
var current_opponent_hitboxes
@export var opponent_hitboxes := ["default"]
@onready var parent := get_parent()

@onready var root := $/root/ViewControl
var level : Node3D

func _ready():
	level = root.find_child("Level")
	area_entered.connect(on_hit)
	current_opponent_hitboxes = opponent_hitboxes

func set_invincibility(val: bool):
	if val:
		current_opponent_hitboxes = []
	else:
		current_opponent_hitboxes = opponent_hitboxes

func _physics_process(_delta):
	pass

func on_hit(hitbox):
	if hitbox.name in current_opponent_hitboxes:
		if "DOT_dmg_per_frame" in hitbox:
			pass
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

func die():
	parent.queue_free()
