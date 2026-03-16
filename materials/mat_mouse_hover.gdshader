shader_type canvas_item;

global uniform vec2 mouse_position;

uniform float inner_radius = 100.0;
uniform float outer_radius = 100.0;

void fragment() {
	if (mouse_position != vec2(-1.0)) {
		float dist = distance(mouse_position, VERTEX);
		float alpha = (dist - inner_radius) / (outer_radius - inner_radius);
		if (alpha > 1.0) {
			alpha = sqrt(alpha);
		}
		COLOR *= vec4(1.0, 1.0, 1.0, 1.0 - alpha);
	}
}

