extends Node3D

@onready var firing_particles := $FiringParticles
@onready var laser_mesh := $LaserMesh
@onready var hitbox := $EnemyHitbox
@onready var arrow := $XArrow
@onready var arrow_mat := preload("res://textures/x_arrow.tres")
@onready var white_mat := preload("res://textures/small_solid_white.tres")

func _ready():
	stop_firing_laser()
	arrow.visible = false

func stop_firing_laser():
	firing_particles.emitting = false
	laser_mesh.visible = false
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED

func fire_laser():
	firing_particles.emitting = true
	laser_mesh.visible = true
	hitbox.process_mode = Node.PROCESS_MODE_INHERIT

func prep_arrow():
	$AnimationPlayer.play("PrepArrow")

func armbomb_trigger():
	$AnimationPlayer.play("ArmBomb")
