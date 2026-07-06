shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// --- Uniforms ---
// Renaming base_color to "albedo" breaks the color
uniform vec4 base_color : source_color = vec4(0.56, 0.8, 1.0, 1.0);
uniform vec4 emission_color : source_color = vec4(0.56, 0.8, 1.0, 1.0);
uniform float emission_energy = 0.0;

uniform vec4 ground_glow_color : source_color = vec4(0.56, 0.8, 1.0, 1.0); // Molten orange/red default
uniform float ground_y = -3.6;       // The Y level of your floor
uniform float ground_glow_gradient_height = 1.2;    // How far up the mesh the glow extends
uniform float ground_glow_intensity = 6.0; // Overdrive for the emission (bloom)

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
	EMISSION = emission_color.rgb * emission_energy;
	ROUGHNESS = 0.12;
	
	float distance_from_ground = world_y - ground_y;
	// smoothstep converts the range (0, ground_glow_gradient_height) to (0, 1), then outputs where distance_from_ground is in the new range
	// 1 - smoothstep makes glow_factor 1 at the ground and 0 at/above ground_glow_gradient_height above the ground
	float glow_factor = 1.0 - smoothstep(0.0, ground_glow_gradient_height, distance_from_ground);
	
	// Calculate this new glow and add it to your existing EMISSION
	vec3 final_ground_glow = ground_glow_color.rgb * glow_factor * ground_glow_intensity;
	
	// "+=" ensures we don't erase any emission your ice already has
	EMISSION += final_ground_glow;
}