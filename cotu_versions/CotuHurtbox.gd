class_name CotuHurtbox
extends Hurtbox

func receive_hit(damage):
	#print("Cotu HP: ", str(health-damage))
	super(damage)
