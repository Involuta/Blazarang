extends CharacterBody3D

@export var entity_name := "EnemyMobileGunner"

var shooting := false

@export var sight_dist := 40.0
@export var ATTACK_DURATION_SECS := 1.5
@export var bullet_speed := 30.0
@export var attack_turn_speed := .25

var aiming_at_target := true

var rng := RandomNumberGenerator.new()
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var bullet := preload("res://enemies/enemy_bullet.tscn")
@onready var animation_player := $AnimationPlayer
@onready var gun_mesh := $GunMesh
@onready var stand_mesh := $BasicStationaryGunStand
@onready var root = $/root/ViewControl

var level : Node3D
var target : Node3D

func _ready():
	level = root.find_child("Level")
	target = root.find_child("Icon")
	add_to_group("lockonables")

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()
	if can_see_target() and not shooting:
		start_attack()
	if aiming_at_target:
		lerp_look_at_target(attack_turn_speed)

func lerp_look_at_target(turn_speed):
	var old_rotation = gun_mesh.rotation
	gun_mesh.look_at(target.global_position)
	var target_rotation = gun_mesh.rotation
	gun_mesh.rotation = old_rotation
	gun_mesh.rotation.y = lerp_angle(gun_mesh.rotation.y, target_rotation.y, turn_speed)
	gun_mesh.rotation.x = lerp_angle(gun_mesh.rotation.x, target_rotation.x, turn_speed)
	gun_mesh.rotation.z = lerp_angle(gun_mesh.rotation.z, target_rotation.z, turn_speed)

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
	level.add_child.call_deferred(bullet_inst)
	await bullet_inst.tree_entered
	bullet_inst.global_position = gun_mesh.global_position
	bullet_inst.rotation = gun_mesh.rotation
	bullet_inst.velocity = bullet_speed * -bullet_inst.get_global_transform().basis.z

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
