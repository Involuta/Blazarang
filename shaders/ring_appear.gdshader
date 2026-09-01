shader_type spatial;
render_mode blend_add, depth_draw_opaque;

// Controls overall opacity when fading out the entire ring (1.0 = fully visible, 0.0 = invisible)
uniform float fade_alpha : hint_range(0.0, 1.0) = 1.0;

// Controls progress along the loop (0.0 to 1.2 to allow full spark fade-out)
uniform float progress : hint_range(0.0, 1.2) = 0.0;

// Length of the intense sparkler tip transition zone
uniform float spark_length : hint_range(0.01, 0.5) = 0.15;

// Sharpness/decay speed of the white-hot leading tip
uniform float spark_sharpness : hint_range(1.0, 50.0) = 15.0;

// Shift starting position around the loop (0.25 usually maps to the right side)
uniform float start_offset : hint_range(0.0, 1.0) = 0.25;

// Colors
uniform vec4 leading_color : source_color = vec4(4.0, 4.0, 4.0, 1.0); // HDR white-hot tip
uniform vec4 trailing_color : source_color = vec4(1.0, 0.3, 0.0, 1.0); // Orange ember glow

void fragment() {
    if (fade_alpha <= 0.0) {
        discard;
    }

    // 1. Invert (1.0 - UV.x) to reverse direction from counterclockwise to clockwise
    // 2. Add start_offset to rotate the starting point to the right side
    float current_u = fract((1.0 - UV.x) + start_offset);
    
    // Calculate distance behind progress with seamless circular wrapping
    float dist = fract(progress - current_u);
    
    // Discard geometry ahead of the leading edge until the initial reveal finishes
    if (progress <= 1.0 && current_u > progress) {
        discard;
    }
    
    // Calculate raw tip intensity (1.0 at tip, fading to 0.0 moving backward)
    float tip_factor = clamp(1.0 - (dist / spark_length), 0.0, 1.0);
    float spark_intensity = pow(tip_factor, spark_sharpness);
    
    // Fade out the spark tip entirely as progress moves from 1.0 to (1.0 + spark_length)
    float spark_fade = 1.0 - clamp((progress - 1.0) / spark_length, 0.0, 1.0);
    spark_intensity *= spark_fade;
    
    // Mix between the warm trailing body and the bright sparkler tip
    vec3 final_color = mix(trailing_color.rgb, leading_color.rgb, spark_intensity);
    
    ALBEDO = final_color;
    EMISSION = final_color * (1.0 + spark_intensity * 4.0) * fade_alpha;
    ALPHA = fade_alpha;
}