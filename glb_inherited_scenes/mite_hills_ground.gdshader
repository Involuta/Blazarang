shader_type spatial; // use "canvas_item" if it's 2D

uniform vec4 sand_color : source_color = vec4(0.9, 0.85, 0.6, 1.0);
uniform float grain_scale : hint_range(1.0, 100.0) = 20.0;
uniform float grain_strength : hint_range(0.0, 1.0) = 0.2;

float hash(vec2 p) {
    return fract(sin(dot(p, vec2(127.1, 311.7))) * 43758.5453);
}

float noise(vec2 uv) {
    vec2 i = floor(uv);
    vec2 f = fract(uv);
    float a = hash(i);
    float b = hash(i + vec2(1.0, 0.0));
    float c = hash(i + vec2(0.0, 1.0));
    float d = hash(i + vec2(1.0, 1.0));
    vec2 u = f*f*(3.0-2.0*f);
    return mix(a, b, u.x) +
           (c - a)*u.y*(1.0 - u.x) +
           (d - b)*u.x*u.y;
}

void fragment() {
    vec2 uv = UV * grain_scale;
    float g = noise(uv);
    vec3 base = sand_color.rgb;
    base += (g - 0.5) * grain_strength; // add subtle grain
    ALBEDO = base;
}
