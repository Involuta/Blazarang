extends CharacterBody3D

var shooting := false

var map_import_scale_factor := 240
const SIGHT_DIST := 30.0

const ATTACK_DURATION_SECS := 1.5
const BULLET_SPEED := 30.0

var aiming_at_target := true

var rng := RandomNumberGenerator.new()
var bullet := preload("res://enemies/enemy_bullet.tscn")
@onready var animation_player := $AnimationPlayer
@onready var arena := $/root/Arena
@onready var cotu := $/root/Arena/cotuCB
@onready var target := $/root/Arena/Target

func _ready():
	add_to_group("lockonables")

func _physics_process(delta):
	if can_see_target() and not shooting:
		start_attack()
	if aiming_at_target:
		look_at(target.global_position)

func start_attack():
	shooting = true
	aiming_at_target = true
	animation_player.play("shoot")
	await get_tree().create_timer(ATTACK_DURATION_SECS).timeout
	shooting = false
	
func stop_aiming_at_target():
	aiming_at_target = false

func shoot_bullet():
	var bullet_inst = bullet.instantiate()
	arena.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position
	bullet_inst.velocity = BULLET_SPEED * global_position.direction_to(target.global_position)
	bullet_inst.look_at(target.global_position)

func can_see_target():
	var space_state := get_world_3d().direct_space_state
	var sight_dir := global_position.direction_to(target.global_position)
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + SIGHT_DIST * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER, Globals.TARGET_COL_LAYER])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if not result:
		return false
	if result.collider.collision_layer == Globals.ARENA_COL_LAYER:
		return false
	else:
		return true
