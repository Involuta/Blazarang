@tool
extends Node3D

@onready var sword = $BasicSword
@onready var sword_attachment = $Skeleton3D/SwordAttachment

func _process(delta):
	sword.global_position = sword_attachment.global_position
