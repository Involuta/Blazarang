shader_type spatial;
render_mode unshaded;

uniform vec3 top_color = vec3(0.0, 0.0, 0.0);    // Black (top)
uniform vec3 middle_color = vec3(1.0, 0.5, 0.0); // Orange (horizon)
uniform vec3 bottom_color = vec3(0.0, 0.0, 0.0);  // Black (bottom)
uniform float horizon_sharpness = 3.0; // Higher values make a sharper transition

void fragment() {
    // Use the world normal to determine the "up" direction
    float factor = clamp(NORMAL.y, -1.0, 1.0);

    // Apply smoothstep with horizon_sharpness to control blending
    float blend = smoothstep(-1.0 / horizon_sharpness, 1.0 / horizon_sharpness, factor);

    // Blend bottom → middle → top
    vec3 color = mix(bottom_color, middle_color, blend);
    color = mix(color, top_color, blend);

    ALBEDO = color;
}
