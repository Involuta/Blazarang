class_name MultiHurtboxChild
extends EnemyHurtbox

@export var hurtbox_owner : Node3D

func receive_hit(damage: float, hitter):
	hurtbox_owner.receive_hit(damage, hitter)
