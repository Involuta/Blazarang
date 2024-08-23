extends Node3D

@onready var firing_particles := $FiringParticles
@onready var laser_mesh := $LaserMesh

func stop_firing_laser():
	firing_particles.emitting = false
	laser_mesh.visible = false

func fire_laser():
	firing_particles.emitting = true
	laser_mesh.visible = true
