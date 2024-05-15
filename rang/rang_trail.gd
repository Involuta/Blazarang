class_name Trail3D extends MeshInstance3D

var points := []
var widths := []
var lifespans := []
var prev_pos : Vector3

@export var trail_visible := true

@export var start_width := .5
@export var end_width := .0
@export_range(.1, 3) var width_scale_acc := 1.0 # higher --> width decreases faster

@export var min_motion_delta := .1 # min_dist btwn current and previous state needed to spawn a trail point
@export var point_lifespan := 1.0

@export var start_color := Color(1.0, 1.0, 1.0, 1.0)
@export var end_color := Color(1.0, 1.0, 1.0, 1.0)

func _ready():
	prev_pos = global_position
	mesh = ImmediateMesh.new()

func append_point():
	points.append(global_position)
	widths.append([
		get_global_transform().basis.x * start_width,
		get_global_transform().basis.x * start_width - get_global_transform().basis.x * end_width
	])
	lifespans.append(0.0)

func remove_point(i):
	points.remove_at(i)
	widths.remove_at(i)
	lifespans.remove_at(i)
	
func _process(delta):
	# If the dist btwn the previous pos and the current pos is greater than the spawn threshold and the trail is visible, spawn a new point
	if (prev_pos - global_position).length() > min_motion_delta and trail_visible:
		append_point()
		prev_pos = global_position
	
	var p := 0
	var max_points := points.size()
	while p < max_points:
		lifespans[p] += delta
		if lifespans[p] >= point_lifespan:
			remove_point(p)
			p -= 1
			if p < 0:
				p = 0
		max_points = points.size()
		p += 1
		
	mesh.clear_surfaces()
	
	if points.size() < 2:
		return
	
	mesh.surface_begin(Mesh.PRIMITIVE_TRIANGLE_STRIP)
	
	for i in range(points.size()):
		var t := float(i) / (points.size() - 1.0)
		
		var current_color := start_color.lerp(end_color, 1-t)
		mesh.surface_set_color(current_color)
		
		var current_width = widths[i][0] - pow(1-t, width_scale_acc) * widths[i][1]
		
		var t0 := float(i) / points.size()
		var t1 := t
		
		mesh.surface_set_uv(Vector2(t0, 0))
		mesh.surface_add_vertex(to_local(points[i] + current_width))
		mesh.surface_set_uv(Vector2(t1, 1))
		mesh.surface_add_vertex(to_local(points[i] - current_width))
	
	mesh.surface_end()
