extends RigidBody3D

@export var flight_secs := 2.0
@export var detonate_delay_secs := 12.0

func _ready():
	$FlightParticles.visible = true
	$BombParticles.visible = false
	await get_tree().create_timer(flight_secs).timeout
	$FlightParticles.visible = false
	$BombParticles.visible = true
	await get_tree().create_timer(detonate_delay_secs).timeout
	queue_free()
