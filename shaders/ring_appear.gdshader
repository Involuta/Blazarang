shader_type spatial;
render_mode cull_disabled, blend_mix, unshaded;

uniform vec4 albedo : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D texture_albedo : source_color, filter_linear_mipmap;

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
	
	// Normalize angle into a clean 0.0 to 1.0 range
	float ring_coord = fract(angle / (2.0 * PI));
	
	// 2. Circular sweep mask
	float sweep_mask = smoothstep(progress, progress - edge_softness, ring_coord);
	
	// 3. Leading edge glow
	float leading_edge = smoothstep(progress - glow_width - edge_softness, progress - edge_softness, ring_coord) 
                       * (1.0 - sweep_mask);
	
	// Sample base color
	vec4 tex_color = texture(texture_albedo, UV) * albedo;
	
	// Combine base color and glow emission
	ALBEDO = mix(tex_color.rgb, glow_color.rgb * glow_intensity, leading_edge);
	EMISSION = glow_color.rgb * leading_edge * glow_intensity;
	
	// 4. Combine sweep mask, texture alpha, and global fade_alpha
	ALPHA = tex_color.a * sweep_mask * fade_alpha;
}