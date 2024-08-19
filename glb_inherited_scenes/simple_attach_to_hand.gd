@tool
extends Node3D

@export var obj_to_attach_path := "SwordPivot"
@export var bone_attachment_path := "Skeleton3D/BoneAttachment3D"
var obj_to_attach
var bone_attachment

@export var attached := true

func _ready():
	obj_to_attach = get_node(obj_to_attach_path)
	bone_attachment = get_node(bone_attachment_path)

func attach():
	attached = true

func detach():
	attached = false
	
func _process(_delta):
	if attached:
		obj_to_attach.position = bone_attachment.position
