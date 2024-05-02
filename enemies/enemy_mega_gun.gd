extends CharacterBody3D

var shooting := false

var map_import_scale_factor := 240
@onready var sight_dist := 400.0

@onready var attack_duration_secs := 5
@onready var bullet_speed := 30.0
@onready var attack_turn_speed := .1

var aiming_at_target := true

var rng := RandomNumberGenerator.new()
var mega_bullet := preload("res://enemies/enemy_mega_bullet.tscn")
@onready var animation_player := $AnimationPlayer
@onready var level := $/root/Level
@onready var cotu := $/root/Level/cotuCB
@onready var target := $/root/Level/Target

func _ready():
	add_to_group("lockonables")

func _physics_process(_delta):
	if can_see_target() and not shooting:
		start_attack()
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)

func lerp_look_at_target(turn_speed):
	var old_rotation := rotation
	look_at(target.global_position)
	var target_rotation := rotation
	rotation = old_rotation
	rotation.y = lerp_angle(rotation.y, target_rotation.y, turn_speed)
	rotation.x = lerp_angle(rotation.x, target_rotation.x, turn_speed)
	rotation.z = lerp_angle(rotation.z, target_rotation.z, turn_speed)

func start_attack():
	shooting = true
	aiming_at_target = true
	animation_player.play("shoot")
	await get_tree().create_timer(attack_duration_secs).timeout
	shooting = false
	
func stop_aiming_at_target():
	aiming_at_target = false

func shoot_bullet():
	var bullet_inst = mega_bullet.instantiate()
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = global_position
	bullet_inst.velocity = bullet_speed * global_position.direction_to(target.global_position)
	bullet_inst.look_at(target.global_position)

func can_see_target():
	var space_state := get_world_3d().direct_space_state
	var sight_dir := global_position.direction_to(target.global_position)
	var query = PhysicsRayQueryParameters3D.create(global_position, global_position + sight_dist * sight_dir)
	query.collision_mask = Globals.make_mask([Globals.ARENA_COL_LAYER, Globals.TARGET_COL_LAYER])
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	if not result:
		return false
	if result.collider.collision_layer == Globals.ARENA_COL_LAYER:
		return false
	else:
		return true
