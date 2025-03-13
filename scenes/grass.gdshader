shader_type spatial;
render_mode cull_disabled, depth_prepass_alpha;

uniform sampler2D texture_albedo : source_color;
uniform float sway_speed = 1.0;
uniform float sway_strength = 0.1;
uniform float sway_phase_offset = 1.2;
uniform vec2 wind_direction = vec2(1.0, 0.5);

// Tonemapping parameters
uniform vec3 tint_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float tint_strength = 0.3;
uniform float exposure = 1.0;
uniform float saturation = 1.0;
uniform float ambient_occlusion = 0.5;

varying float wind_strength;
varying vec3 vertex_pos;
varying vec3 world_pos;

// Helper function for tonemapping (ACES film curve)
vec3 aces_tone_map(vec3 color) {
    float a = 2.51;
    float b = 0.03;
    float c = 2.43;
    float d = 0.59;
    float e = 0.14;
    return clamp((color * (a * color + b)) / (color * (c * color + d) + e), 0.0, 1.0);
}

void vertex() {
    // Store original position for use in fragment shader
    vertex_pos = VERTEX;

    // Store world position for environmental tonemapping
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;

    // Calculate wind effect based on world position for variation
    vec2 world_xz = world_pos.xz;
    float wind_time = TIME * sway_speed;

    // Create more natural movement with sin and cos combinations
    float wind_x = sin(wind_time + world_xz.x * sway_phase_offset) * cos(wind_time * 0.7 + world_xz.y * 0.4);
    float wind_z = cos(wind_time + world_xz.y * sway_phase_offset) * sin(wind_time * 0.6 + world_xz.x * 0.3);

    vec2 wind = vec2(wind_x, wind_z) * normalize(wind_direction);

    // Apply wind strength based on height (more at the top, less at the bottom)
    wind_strength = smoothstep(0.0, 1.0, VERTEX.y / 1.0); // Adjust divisor based on your grass height

    // Only displace vertices that aren't at the base of the grass
    if (VERTEX.y > 0.1) {
        VERTEX.x += wind.x * sway_strength * wind_strength;
        VERTEX.z += wind.y * sway_strength * wind_strength;
    }
}

void fragment() {
    vec4 albedo_tex = texture(texture_albedo, UV);

    // Apply base color
    vec3 color = albedo_tex.rgb;

    // Apply environmental tonemapping based on world position
    // This creates variation based on position in the world
    float world_factor = sin(world_pos.x * 0.05) * cos(world_pos.z * 0.05) * 0.5 + 0.5;

    // Adjust color based on height for more natural look
    float height_factor = smoothstep(0.0, 1.0, vertex_pos.y);

    // Apply ambient occlusion at the base
    float ao = mix(1.0, 1.0 - ambient_occlusion, 1.0 - height_factor);

    // Apply tint based on world position
    color = mix(color, color * tint_color, tint_strength * world_factor);

    // Apply exposure adjustment
    color *= exposure;

    // Apply saturation adjustment
    float luminance = dot(color, vec3(0.2126, 0.7152, 0.0722));
    color = mix(vec3(luminance), color, saturation);

    // Apply tonemapping for better integration with the scene
    color = aces_tone_map(color);

    // Apply ambient occlusion
    color *= ao;

    // Add slight color variation based on wind
    color = mix(color, color * vec3(1.05, 1.05, 0.95), wind_strength * 0.2);

    ALBEDO = color;

    // Apply alpha from texture
    ALPHA = albedo_tex.a;

    // Apply basic lighting
    SPECULAR = 0.1;
    ROUGHNESS = 0.9;

    // Add a slight rim light effect for better integration
    float rim = 1.0 - max(dot(normalize(VIEW), NORMAL), 0.0);
    rim = pow(rim, 3.0);
    EMISSION = vec3(0.05, 0.07, 0.02) * rim * height_factor;
}