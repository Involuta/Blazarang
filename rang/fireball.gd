extends Node3D

signal destroyed(node)

enum State {
	APPROACH,
	EXPLODE
}

var state: State = State.APPROACH

@onready var root := $/root/ViewControl
@onready var hitbox := $PlayerHitbox
@onready var mesh := $BallMesh
@onready var anim_player := $AnimationPlayer
@onready var flight_particles := $FlightParticles
@onready var explosion_particles := $ExplosionParticles
var target: Node3D

# --- Rotation ---
@export var spin_speed := 30.0 

# --- Movement ---
@export var approach_speed := 45.0 
var approach_target_pos := Vector3.ZERO

# --- Explosion ---
@export var explode_duration := 2.0 # Explosion particles take 1 sec to disappear, but remaining flight particles take up to 2 secs to disappear

func _ready():
	hitbox.damage = Globals.player_hitbox_data.FireballBaseDamage

func _physics_process(delta):
	match state:
		State.APPROACH:
			approach_frame(delta)
		State.EXPLODE:
			explode_frame(delta)
	
	if is_instance_valid(mesh):
		mesh.rotate_y(spin_speed * delta)

# -------------------------------------------------
# APPROACH
# -------------------------------------------------
func approach_frame(delta):
	if not is_instance_valid(target) or target.process_mode == Node.PROCESS_MODE_DISABLED:
		switch_to_explode()
		return

	# Fireball targets the center of the enemy directly
	approach_target_pos = target.global_position
	
	global_position = global_position.move_toward(
		approach_target_pos,
		approach_speed * delta
	)
	
	look_at(target.global_position)

	# Impact condition
	if global_position.distance_to(approach_target_pos) < 0.5:
		switch_to_explode()

func switch_to_approach():
	state = State.APPROACH

# -------------------------------------------------
# EXPLODE
# -------------------------------------------------
func explode_frame(_delta):
	pass

func switch_to_explode():
	state = State.EXPLODE
	
	anim_player.play("explode")
	flight_particles.emitting = false
	explosion_particles.emitting = true
	
	# Wait for explosion VFX to finish
	await get_tree().create_timer(explode_duration).timeout
	
	if is_instance_valid(self):
		destroyed.emit(self)
		queue_free()

# -------------------------------------------------
# API
# -------------------------------------------------
func deploy_to_target(new_target: Node3D):
	target = new_target
	switch_to_approach()
