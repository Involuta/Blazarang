extends Node3D

@export var enemy_name := "GauntletMeleeTier1"

@export var hit_particle_color := Color.DODGER_BLUE

var max_health := 100.0
var health := 100.0
var hit_score := 1.0
var kill_score := 1.0
var hit_particles := preload("res://enemies/enemy_hit_particles.tscn")
var rang_hit_particles := preload("res://rang/rang_hit_particles.tscn")
var rang_hit_effect := preload("res://rang/hit_effect1.tscn")
var death_particle := preload("res://enemies/death_particle.tscn")

@onready var root := $/root/ViewControl
var level : Node3D

func _ready():
	max_health = Globals.enemy_hurtbox_data[enemy_name][0]
	health = max_health
	hit_score = Globals.enemy_hurtbox_data[enemy_name][1]
	kill_score = Globals.enemy_hurtbox_data[enemy_name][2]
	
	level = root.find_child("Level")

func receive_hit(damage: float, hitter):
	# Check if this is a healing hit
	if damage > 0:
		emit_hit_particles(hitter)
		award_score(hitter)
	if hitter.name == "Roserang":
		emit_hitter_effect(hitter)
	health -= damage
	if health <= 0:
		call_deferred("die")

func emit_hit_particles(hitter):
	var inst := hit_particles.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = global_position
	inst.global_rotation.y = hitter.global_rotation.y + PI
	var particle_settings = inst.get_node("GPUParticles3D")
	particle_settings.emitting = true
	particle_settings.process_material.color = hit_particle_color

func emit_hitter_particles(hitter):
	var inst := rang_hit_particles.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = hitter.global_position
	inst.global_rotation.y = hitter.global_rotation.y + PI
	var particle_settings = inst.get_node("GPUParticles3D")
	particle_settings.emitting = true

func emit_hitter_effect(hitter):
	var inst := rang_hit_effect.instantiate()
	level.add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = hitter.global_position

func award_score(hitter):
	Globals.award_score(hit_score)
	if hitter.name == "Roserang":
		if hitter.get_mvmt_state() == "RICOCHET":
			Globals.award_score(Globals.RICOCHET_HIT_SCORE)
		elif hitter.get_mvmt_state() == "RAPIDORBIT":
			Globals.award_score(Globals.RAPIDORBIT_HIT_SCORE)
		elif hitter.get_mvmt_state() == "HOMING":
			Globals.award_score(Globals.HOMING_HIT_SCORE)

func death_effect():
	# Eventually, just make a GPUParticles3D node start emitting
	pass

func die():
	var parent = get_parent()
	parent.find_child("LeftFootFleshHurtbox").process_mode = Node.PROCESS_MODE_INHERIT
	parent.find_child("RightFootFleshHurtbox").process_mode = Node.PROCESS_MODE_INHERIT
	parent.find_child("LeftFootArmorHurtbox").process_mode = Node.PROCESS_MODE_DISABLED
	parent.find_child("RightFootArmorHurtbox").process_mode = Node.PROCESS_MODE_DISABLED
	parent.find_child("LeftFootArmorPhysical").process_mode = Node.PROCESS_MODE_DISABLED
	parent.find_child("RightFootArmorPhysical").process_mode = Node.PROCESS_MODE_DISABLED
	Globals.award_score(kill_score)
	death_effect()
