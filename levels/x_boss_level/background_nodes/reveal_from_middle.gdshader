shader_type spatial;
render_mode depth_draw_always, cull_disabled;

uniform vec4 albedo_color : source_color = vec4(0.537, 0.329, 0.271, 1.0); // Default #895445
uniform float reveal_amount : hint_range(0.0, 1.0) = 0.0;
uniform float mesh_height = 2.0;
uniform float glow_width = 0.05;
uniform vec3 glow_color : source_color = vec3(1.0, 0.3, 0.0); // Orange

varying float local_y;

void vertex() {
    // Capture local Y for the reveal logic
    local_y = VERTEX.y;
}

void fragment() {
    // Reveal Logic: Distance from center
    float threshold = (mesh_height / 2.0) * reveal_amount;
    
    // Discard pixels that haven't been "revealed" yet
    if (abs(local_y) > threshold) {
        discard;
    }

    // Material Settings
    ALBEDO = albedo_color.rgb;
    METALLIC = 0.5;
    ROUGHNESS = 0.0;

    // Orange Emission Glow at the leading edges
    if (abs(local_y) > threshold - glow_width) {
        EMISSION = glow_color * 5.0; 
    }
}