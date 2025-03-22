shader_type spatial;
render_mode unshaded,cull_front;

uniform vec3 color:source_color = vec3(0);
uniform float thickness = 1;

instance uniform float outline_scale = 1.;

void vertex() {
	VERTEX += NORMAL * thickness * outline_scale;

	//float speed = 7.;
	float speed = 4.;
	if (int(floor(TIME*speed)) % 2 == 0) {
		VERTEX.x += sin(VERTEX.y*7.)*0.05;
	}
	else {
		VERTEX.z += cos(VERTEX.y*5.)*0.05;
	}
}

void fragment() {
	ALBEDO = color;
}
