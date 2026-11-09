class_name MultiHurtboxChild
extends EnemyHurtbox

func receive_hit(hitbox, hitter):
	hurtbox_owner.receive_hit(hitbox.damage, hitter)
