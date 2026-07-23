shader_type spatial;
render_mode cull_disabled, blend_mix, unshaded;

uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);

// Sweep control (0.0 = empty, 1.0 = full ring traced)
uniform float progress : hint_range(0.0, 1.0) = 1.0;

// Overall opacity control (1.0 = fully visible, 0.0 = completely transparent)
uniform float fade_alpha : hint_range(0.0, 1.0) = 1.0;

// Softness of the trace line
uniform float edge_softness : hint_range(0.001, 0.2) = 0.02;

// Glow / Leading edge
uniform vec4 glow_color : source_color = vec4(0.0, 0.8, 1.0, 1.0);
uniform float glow_width : hint_range(0.0, 0.2) = 0.05;
uniform float glow_intensity : hint_range(1.0, 10.0) = 3.0;

varying vec3 local_pos;

void vertex() {
	local_pos = VERTEX;
}

void fragment() {
	// 1. Calculate angle around Y axis
	// atan(x, z) gives 0 at Front (+Z). 
	// atan(-x, z) reverses direction to Clockwise.
	// Subtracting PI/2 offsets the start 90 degrees to the Right (-X as viewed from the front).
	float angle = atan(-local_pos.x, local_pos.z) - (PI * 0.5);
	float angle2 = -atan(-local_pos.x, local_pos.z) + (PI * 0.5);
	
	// Normalize angle into a clean 0.0 to 1.0 range
	float ring_coord = fract(angle / (2.0 * PI));
	float ring_coord2 = fract(angle2 / (2.0 * PI));
	
	// 2. Circular sweep mask. Smoothstep is only used for the edge softness.
	// Note that when the bigger value is used as edge0, the output is inversed (0 when x>e0, 1 when x<e1). Essentially, output 0 is always on the left (e0), output 1 is always on the right (e1)
	float sweep_mask = smoothstep(progress, progress - edge_softness, ring_coord);
	float sweep_mask2 = smoothstep(progress, progress - edge_softness, ring_coord2);
	
	// 3. Leading edge glow
	float leading_edge = smoothstep(progress - glow_width - edge_softness, progress - edge_softness, ring_coord) 
                       * (1.0 - sweep_mask);
	float leading_edge2 = smoothstep(progress - glow_width - edge_softness, progress - edge_softness, ring_coord2) 
                       * (1.0 - sweep_mask2);
	//leading_edge = max(leading_edge, leading_edge2);
	
	// Combine base color and glow emission
	ALBEDO = albedo.rgb * glow_intensity;
	EMISSION = glow_color.rgb * leading_edge * glow_intensity;
	
	// 4. Combine sweep mask, texture alpha, and global fade_alpha
	ALPHA = albedo.a * max(sweep_mask, sweep_mask2) * fade_alpha;
}