extends RigidBody3D

@export var flight_secs := 2.0
@export var detonate_delay_secs := 12.0


func _ready():
	$FlightParticles.visible = true
	$BombParticles.visible = false
	await get_tree().create_timer(flight_secs).timeout
	$FlightParticles.rotation = Vector3(0,0,-PI)
	$BombParticles.visible = true
	await get_tree().create_timer(detonate_delay_secs).timeout
	
	var volcano_inst = load("res://enemies/x_volcano.tscn").instantiate()
	$/root/Level.add_child(volcano_inst)
	volcano_inst.global_position = global_position
	
	queue_free()
