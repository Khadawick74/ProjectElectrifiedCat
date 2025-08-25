// Adapted from code by DevPoodle at https://youtu.be/6qim01M1Yp0
shader_type spatial;

uniform float height = 64.0;
uniform sampler2D color_gradient;
uniform sampler2D normal_map;
uniform sampler2D noise_gradient;
uniform sampler2D noise_map;

void fragment() {
	// Get pixel of position in world coordinates
	vec4 world_vertex = INV_VIEW_MATRIX * vec4(VERTEX, 1.0);
	// Get vertex in model space
	vec3 model_vertex = (inverse(MODEL_MATRIX) * world_vertex).xyz;
	// Use this and height to figure out where to sample the colour gradient map
	float gradient_uv = (model_vertex.y / height) + 0.5;
	vec2 noise_position = vec2(model_vertex.x / 1024.0, model_vertex.z / 1024.0);
	// Sample both textures and set their corresponding values
	ALBEDO = texture(color_gradient, vec2(gradient_uv)).rgb;
	// Adjust colour based on a noise map
	ALBEDO = ALBEDO * (texture(noise_map, noise_position).rgb);
	NORMAL_MAP = texture(normal_map, UV).xyz;
}

