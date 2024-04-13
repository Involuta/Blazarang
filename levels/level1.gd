extends Level

var section_positions = {
	"HallwayInvasion" : Vector3(0, 0, 0),
	"FirstMaze" : Vector3(-11, 14, -168),
	"PillarRoom" : Vector3(-165, 0, -128),
	"TopGunBattlefield" : Vector3(-267, 17, -112),
	"ArenaElevator" : Vector3(-527, 80, -112)
}
var hallway_invasion_resource := preload("res://levels/level1section_nodes/hallway_invasion.tscn")
var first_maze_resource := preload("res://levels/level1section_nodes/first_maze.tscn")
var pillar_room_resource := preload("res://levels/level1section_nodes/pillar_room.tscn")
var top_gun_battlefield_resource := preload("res://levels/level1section_nodes/top_gun_battlefield.tscn")
var arena_elevator_resource := preload("res://levels/level1section_nodes/arena_elevator.tscn")

func _ready():
	var inst = hallway_invasion_resource.instantiate()
	add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = section_positions["HallwayInvasion"]

func _on_first_maze_loading_trigger_body_entered(_body):
	var inst = first_maze_resource.instantiate()
	add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = section_positions["FirstMaze"]

func _on_hallway_invasion_deloading_trigger_body_entered(_body):
	# Using if find_child(...) instead of if $section prevents errors from being thrown when $section returns nullptr
	if find_child("HallwayInvasion", false, false):
		$HallwayInvasion.queue_free()

func _on_pillar_room_loading_trigger_body_entered(_body):
	var inst = pillar_room_resource.instantiate()
	add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = section_positions["PillarRoom"]
	inst.rotation.y = -PI/2

func _on_first_maze_deloading_trigger_body_entered(_body):
	if find_child("FirstMaze", false, false):
		$FirstMaze.queue_free()

func _on_top_gun_battlefield_loading_trigger_body_entered(_body):
	var inst = top_gun_battlefield_resource.instantiate()
	add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = section_positions["TopGunBattlefield"]

func _on_pillar_room_deloading_trigger_body_entered(_body):
	if find_child("PillarRoom", false, false):
		$PillarRoom.queue_free()

func _on_arena_elevator_loading_trigger_body_entered(_body):
	var inst = arena_elevator_resource.instantiate()
	add_child.call_deferred(inst)
	await inst.tree_entered
	inst.global_position = section_positions["ArenaElevator"]

func _on_top_gun_battlefield_deloading_trigger_body_entered(_body):
	if find_child("TopGunBattlefield", false, false):
		$TopGunBattlefield.queue_free()
