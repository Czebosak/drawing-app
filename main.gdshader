shader_type canvas_item;

uniform float zoom = 100;
uniform float pixel_scale = 50.0;

void fragment() {
	vec2 scaled_uv = round(UV * pixel_scale);
	float center = 0.5 * pixel_scale;
	if (!(pow(scaled_uv.x - center, 2.0) + pow(scaled_uv.y - center, 2.0) < pow(20.0, 2.0))) {
		discard;
	}
}