shader_type spatial;
render_mode blend_mix, depth_draw_opaque, cull_back, diffuse_lambert, specular_schlick_ggx;

// Renaming base_color to "albedo" breaks the color
uniform vec4 base_color : source_color = vec4(0.56, 0.8, 1.0, 1.0);
uniform vec4 glow_color : source_color = vec4(0.56, 0.8, 1.0, 1.0);
uniform float max_brightness : hint_range(0.0, 6.0) = .75;

// Controlled manually via GDScript (0.0 = bottom, 1.0 = fully glowing head)
uniform float glow_progress : hint_range(0.0, 1.0) = 0.0;

// Local space bounds along the shard's axis
uniform float arm_bottom : hint_range(-50.0, 50.0) = 0.0;
uniform float arm_top : hint_range(-60.0, 50.0) = -50.0;
uniform float glow_fade_length : hint_range(0.01, 1.0) = 0.2;

varying float v_local_y;

void vertex() {
	// Use local y axis so glow progresses along length of shard
	v_local_y = VERTEX.y;
}

void fragment() {
	// Extent of the way the current fragment is from the bottom to top (bottom is 0, top is 1)
	float height_ratio = clamp((v_local_y - arm_bottom) / (arm_top - arm_bottom), 0.0, 1.0);
	
	// Smooth transition up to the glow_progress front
	float mask = smoothstep(glow_progress - glow_fade_length, glow_progress, height_ratio);
	float glow_intensity = 1.0 - mask;
	
	ALBEDO = base_color.rgb;
	//EMISSION = glow_color.rgb * 0.0;
	ROUGHNESS = 0.12;
	EMISSION = glow_color.rgb * glow_intensity * max_brightness;
}