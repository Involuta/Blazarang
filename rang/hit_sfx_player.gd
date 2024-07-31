extends Area3D

@onready var hit_sfx := $HitAudioStream

func _ready():
	area_entered.connect(play_hit_sound)

func play_hit_sound(area):
	hit_sfx.play()
