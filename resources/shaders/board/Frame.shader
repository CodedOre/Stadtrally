shader_type spatial;
render_mode cull_disabled, depth_draw_always;

uniform vec4 frame_color : hint_color;

void vertex () {
	COLOR = frame_color;
}

void fragment () {
	float emission_strength = abs (1.0 - mod (TIME, 2.0));
	ALBEDO = vec3 (COLOR.r, COLOR.g, COLOR.b);
	EMISSION = ALBEDO * vec3 (emission_strength / 4.0);
}