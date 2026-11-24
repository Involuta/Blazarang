shader_type spatial;

uniform vec4 base_color : source_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform sampler2D noise_tex : filter_linear_mipmap;
uniform float cutoff : hint_range(0.0, 1.0) = 0.4;
uniform float softness : hint_range(0.001, 0.5) = 0.05;

void fragment() {
	float n = texture(noise_tex, UV).r;
	// Maps dark values below cutoff to 0.0 (transparent) and bright values above to 1.0 (opaque)
	float alpha = smoothstep(cutoff - softness, cutoff + softness, n);
	ALBEDO = base_color.rgb;
	ALPHA = alpha;
}