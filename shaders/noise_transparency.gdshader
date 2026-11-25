shader_type spatial;
render_mode blend_mix, cull_disabled;

uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D noise_tex : filter_linear_mipmap;

// 0.0 = completely hidden, 1.0 = completely revealed
uniform float reveal : hint_range(0.0, 1.0) = 0.5;
uniform float edge_softness : hint_range(0.001, 0.5) = 0.08;
// 0.0 = start at (0, 0) toward (1, 1); 1.0 = start at (1, 0) toward (0, 1)
uniform float diagonal_flip : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	// Flip X if diagonal_flip is 1.0 so you can pick either opposite-corner pair
	float u = mix(UV.x, 1.0 - UV.x, diagonal_flip);
	float v = UV.y;

	// Distance from starting corner (0, 0) to opposite corner (1, 1) is sqrt(2) (~1.4142)
	float dist = length(vec2(u, v)) / 1.41421356;

	// Push the wipe front past 0.0 and 1.0 so the rounded edge clears the entire quad
	float sweep = mix(-edge_softness, 1.0 + edge_softness, reveal);
	float wipe_mask = 1.0 - smoothstep(sweep - edge_softness, sweep + edge_softness, dist);

	// Combine rounded wipe with noise so dark noise spots remain transparent
	float n = texture(noise_tex, UV).r;
	float alpha = wipe_mask * smoothstep(0.05, 0.95, n);

	ALBEDO = base_color.rgb;
	ALPHA = alpha;
}