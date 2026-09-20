extends MeshInstance3D

@export var node_a: Node3D
@export var node_b: Node3D

var immediate_mesh: ImmediateMesh

func _ready():
	immediate_mesh = ImmediateMesh.new()
	mesh = immediate_mesh

func _process(_delta):
	if not is_instance_valid(node_a) or not is_instance_valid(node_b):
		return
	
	immediate_mesh.clear_surfaces()
	
	var start_pos = to_local(node_a.global_position)
	var end_pos = to_local(node_b.global_position)
	
	immediate_mesh.surface_begin(Mesh.PRIMITIVE_LINES)
	immediate_mesh.surface_add_vertex(start_pos)
	immediate_mesh.surface_add_vertex(end_pos)
	immediate_mesh.surface_end()
