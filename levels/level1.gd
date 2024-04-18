extends Level

var section_positions = {
	"GunArena" : Vector3(-95, -50, 0),
	"HallwayInvasion" : Vector3(0, 10, 0),
	"FirstMaze" : Vector3(-4, 50, -168),
	"PillarRoom" : Vector3(37, 101.1, -337.1),
	"TopGunBattlefield" : Vector3(16, 118, -444),
	"ArenaElevator" : Vector3(16, 182, -704)
}
var gun_arena_resource := preload("res://levels/level1section_nodes/gun_arena.tscn")
var hallway_invasion_resource := preload("res://levels/level1section_nodes/hallway_invasion.tscn")
var first_maze_resource := preload("res://levels/level1section_nodes/first_maze.tscn")
var pillar_room_resource := preload("res://levels/level1section_nodes/pillar_room.tscn")
var top_gun_battlefield_resource := preload("res://levels/level1section_nodes/top_gun_battlefield.tscn")
var arena_elevator_resource := preload("res://levels/level1section_nodes/arena_elevator.tscn")

@export var spawn_hallway_delay_secs := 10

func _ready():
	var inst = gun_arena_resource.instantiate()
	add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = section_positions["GunArena"]
	inst.rotation.y = -PI/2
	
	await get_tree().create_timer(spawn_hallway_delay_secs).timeout
	if not find_child("HallwayInvasion", false, false):
		var inst2 = hallway_invasion_resource.instantiate()
		add_child.call_deferred(inst2)
		await inst2.tree_entered
		inst2.global_position = section_positions["HallwayInvasion"]
