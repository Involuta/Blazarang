shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;
uniform sampler2D depth_tex : hint_depth_texture, repeat_disable, filter_nearest;
uniform sampler2D ghost_tex : source_color;
uniform sampler2D noise_tex : repeat_enable;

uniform float jitter_amount : hint_range(0.0, 0.01) = 0.002;
uniform float jitter_speed : hint_range(0.0, 5.0) = 1.0;

uniform float depth_threshold : hint_range(0.0, 2.0) = 0.2;
uniform float color_threshold : hint_range(0.0, 1.0) = 0.1;
uniform vec4 edge_color : source_color = vec4(0.0, 0.0, 0.0, 1.0);
uniform float edge_width : hint_range(0.1, 5.0) = 1.0;

void vertex() {
	// Ensure the quad stays in front of the camera in clip space
    POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    // 1. Check center raw depth
    // If the Ghost Camera sees "Sky" (the hidden floor), raw_d_center will be 0.0.
    float raw_d_center = texture(depth_tex, SCREEN_UV).r;
    vec3 scene_color = texture(screen_tex, SCREEN_UV).rgb;

    if (raw_d_center > 0.0001) {
        // --- START OF OUTLINE LOGIC ---
        vec2 jitter = texture(noise_tex, SCREEN_UV + TIME * jitter_speed).rg * jitter_amount;
        vec2 ps = (1.0 / VIEWPORT_SIZE) * edge_width;

        float d[9];
        float l[9];

        // SET N TO YOUR CAMERA NEAR PLANE, F TO FAR PLANE
        float n = 0.2;
        float f = 500.0;

        int index = 0;
        for (int y = -1; y <= 1; y++) {
            for (int x = -1; x <= 1; x++) {
                vec2 uv = (SCREEN_UV + jitter) + vec2(float(x), float(y)) * ps;

                float raw_d = texture(depth_tex, uv).r;
                d[index] = n * f / (f - raw_d * (f - n));

                vec3 ghost_c = texture(ghost_tex, uv).rgb;
                l[index] = dot(ghost_c, vec3(0.299, 0.587, 0.114));

                index++;
            }
        }

        float s_h_d = d[2] + (2.0 * d[5]) + d[8] - (d[0] + (2.0 * d[3]) + d[6]);
        float s_v_d = d[0] + (2.0 * d[1]) + d[2] - (d[6] + (2.0 * d[7]) + d[8]);
        float depth_mag = sqrt(s_h_d * s_h_d + s_v_d * s_v_d);

        float s_h_l = l[2] + (2.0 * l[5]) + l[8] - (l[0] + (2.0 * l[3]) + l[6]);
        float s_v_l = l[0] + (2.0 * l[1]) + l[2] - (l[6] + (2.0 * l[7]) + l[8]);
        float color_mag = sqrt(s_h_l * s_h_l + s_v_l * s_v_l);

        float final_depth_mag = depth_mag / max(d[4], 0.1);

        if (final_depth_mag > depth_threshold || color_mag > color_threshold) {
            ALBEDO = edge_color.rgb;
        } else {
            ALBEDO = scene_color;
        }
    } else {
        // 2. If it's the "Sky" (where the floor is hidden), just show the main scene.
        ALBEDO = scene_color;
    }
}