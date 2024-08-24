extends Node3D

@onready var firing_particles := $FiringParticles
@onready var laser_mesh := $LaserMesh
@onready var hitbox := $EnemyHitbox

func stop_firing_laser():
	firing_particles.emitting = false
	laser_mesh.visible = false
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func fire_laser():
	firing_particles.emitting = true
	laser_mesh.visible = true
	hitbox.process_mode = Node.PROCESS_MODE_INHERIT
