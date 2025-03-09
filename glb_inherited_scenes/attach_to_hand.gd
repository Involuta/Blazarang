@tool
extends Node3D

@export var obj_names := ["BasicSword"]
@export var attachment_names := ["SwordAttachment"]
@export var local_offset := [Vector3(.29,.35,.22)]

var objs := []
var attachments := []

func _ready():
	for i in range(obj_names.size()):
		objs.append(get_node(obj_names[i]))
	for i in range(attachment_names.size()):
		attachments.append(get_node("Skeleton3D/"+attachment_names[i]))
	if objs.size() == 0:
		print(obj_names)

func _process(_delta):
	for i in range(objs.size()):
		pass
		#objs[i].global_position = attachments[i].global_position + local_offset[i] * attachments[i].transform.basis
