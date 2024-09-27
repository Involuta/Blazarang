extends RigidBody3D

@export var flight_secs := 2.0
@export var detonate_delay_secs := 12.0
@export var warning_secs := 2.0

@onready var flight_particles := $FlightParticles
@onready var bomb_particles := $BombParticles
@onready var level := $/root/Level

func _ready():
	flight_particles.visible = true
	bomb_particles.visible = false
	await get_tree().create_timer(flight_secs).timeout
	flight_particles.rotation = Vector3(0,0,-PI)
	bomb_particles.visible = true
	await get_tree().create_timer(detonate_delay_secs).timeout
	
	flight_particles.visible = false
	bomb_particles.visible = false
	var warning_sun_inst = load("res://enemies/x_warning_sun.tscn").instantiate()
	level.add_child(warning_sun_inst)
	warning_sun_inst.global_position = global_position
	await get_tree().create_timer(warning_secs).timeout
	
	warning_sun_inst.queue_free()
	var volcano_inst = load("res://enemies/x_volcano.tscn").instantiate()
	level.add_child(volcano_inst)
	volcano_inst.global_position = global_position
	
	queue_free()
