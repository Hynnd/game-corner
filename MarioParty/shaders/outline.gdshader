shader_type spatial;
render_mode unshaded,cull_front;

uniform vec3 color:source_color = vec3(0);
uniform float thickness = 1;

instance uniform float scale = 1.;

void vertex() {
	VERTEX += NORMAL * thickness * scale;
}

void fragment() {
	ALBEDO = color;
}
