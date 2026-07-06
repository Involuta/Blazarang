shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// --- Uniforms ---
uniform vec4 base_color : source_color = vec4(0.3, 0.3, 0.3, 1.0);
uniform vec4 glow_color : source_color = vec4(1.0, 0.3, 0.0, 1.0); // Molten orange/red default

uniform float ground_y = 0.0;       // The Y level of your floor
uniform float glow_height = 0.2;    // How far up the mesh the glow extends
uniform float glow_intensity = 5.0; // Overdrive for the emission (bloom)

// --- Varyings ---
varying float world_y;

void vertex() {
	// Calculate the vertex position in World Space so it stays accurate 
	// even if the mesh moves, rotates, or scales.
	world_y = (MODEL_MATRIX * vec4(VERTEX, 1.0)).y;
}

void fragment() {
	// Default material properties
	ALBEDO = base_color.rgb;
	ROUGHNESS = 0.5;
	METALLIC = 0.0;
	
	// Calculate how close this pixel is to the ground
	// 1.0 = exactly at or below ground_y, 0.0 = safely above it
	float distance_from_ground = world_y - ground_y;
	float glow_factor = 1.0 - smoothstep(0.0, glow_height, distance_from_ground);
	
	// Ensure it doesn't glow if it's completely underground (optional)
	// If you want the underground part to stay lit, remove the next line:
	glow_factor *= step(0.0, distance_from_ground); 

	// Apply the emission glow
	// Multiplying by glow_intensity pushes the values past 1.0, triggering WorldEnvironment Bloom
	EMISSION = glow_color.rgb * glow_factor * glow_intensity;
}