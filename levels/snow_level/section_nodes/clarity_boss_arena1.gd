extends Node3D

@export var blizzard_safezone_radius := 15.0

@onready var root := $/root/ViewControl
@onready var blizzard_area := $BlizzardDOTArea
var cotu : Node3D
var clarity : Node3D

func _ready():
	cotu = root.find_child("cotuCB")
	clarity = root.find_child("Clarity")

func _physics_process(_delta):
	if cotu.global_position.distance_to(clarity.global_position) > blizzard_safezone_radius:
		blizzard_area.process_mode = Node.PROCESS_MODE_INHERIT
	else:
		blizzard_area.process_mode = Node.PROCESS_MODE_DISABLED
