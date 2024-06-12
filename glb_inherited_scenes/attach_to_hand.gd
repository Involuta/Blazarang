@tool
extends Node3D

@export var obj_name := ""
@export var attachment_name := ""
@export var local_offset := Vector3.ZERO

var obj
var attachment

func _ready():
	obj = get_node(obj_name)
	attachment = get_node("Skeleton3D/"+attachment_name)

func _process(delta):
	obj.global_position = attachment.global_position + local_offset * attachment.transform.basis
