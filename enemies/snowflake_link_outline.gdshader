shader_type spatial;
render_mode cull_front, unshaded, blend_add;

uniform vec4 outline_color : source_color = vec4(0.0, 0.4, 1.0, 1.0);
uniform float outline_thickness : hint_range(0.0, 6.0) = 0.05;
uniform float outline_alpha : hint_range(0.0, 1.0) = 0.85;

void vertex() {
	// Push the vertices outward along their normals to create the hull
	VERTEX += NORMAL * outline_thickness;
}

void fragment() {
	// Apply the color multiplied by the intensity for a glow effect
	ALBEDO = outline_color.rgb;
	
	// Faint/soft alpha adjustment (Optional: gives it a slightly softer look)
	ALPHA = outline_alpha;
}