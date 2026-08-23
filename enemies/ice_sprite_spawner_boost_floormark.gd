extends Node2D

signal anim_finished

var center = Vector2(256, 256) # Center of a 512x512 viewport
var radius = 200.0
@export var draw_duration = 2.5 # Seconds per animation phase

func _ready():
	start_animation()

func get_point(angle_degrees: float) -> Vector2:
	var rad = deg_to_rad(angle_degrees)
	return center + Vector2(cos(rad), sin(rad)) * radius

func animate_line(start: Vector2, end: Vector2, tween: Tween):
	var line = Line2D.new()
	line.width = 10.0
	line.default_color = Color(0, 1, 0.8) # Neon cyan
	add_child(line)

	# Start with both points at the origin of the line
	line.add_point(start)
	line.add_point(start)

	# Tween the second point to the final destination
	tween.tween_method(
		func(pos: Vector2): line.set_point_position(1, pos),
		start, 
		end, 
		draw_duration
	)

func start_animation():
	# PHASE 1: Center to 0, 120, 240
	var tween1 = create_tween()
	tween1.set_parallel(true)

	animate_line(center, get_point(0), tween1)
	animate_line(center, get_point(120), tween1)
	animate_line(center, get_point(240), tween1)

	# Pause the function here until tween1 completes
	await tween1.finished 

	# PHASE 2: Branches to 60, 180, 300
	var tween2 = create_tween()
	tween2.set_parallel(true)

	animate_line(get_point(0), get_point(60), tween2)
	animate_line(get_point(0), get_point(300), tween2)

	animate_line(get_point(120), get_point(60), tween2)
	animate_line(get_point(120), get_point(180), tween2)

	animate_line(get_point(240), get_point(180), tween2)
	animate_line(get_point(240), get_point(300), tween2)

	# Pause again until tween2 completes
	await tween2.finished

	# PHASE 3: Return to Center
	var tween3 = create_tween()
	tween3.set_parallel(true)

	animate_line(get_point(60), center, tween3)
	animate_line(get_point(180), center, tween3)
	animate_line(get_point(300), center, tween3)
	
	await tween3.finished
	anim_finished.emit()
