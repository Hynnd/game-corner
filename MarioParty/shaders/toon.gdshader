shader_type spatial;
render_mode ambient_light_disabled,unshaded;

uniform sampler2D tex:repeat_enable,filter_nearest;
uniform vec3 color:source_color=vec3(1);
uniform float shade = 0.1;
uniform vec3 shade_angles = vec3(0.3,1,0.4);
uniform float wobble_amp = 1;

void fragment() {
	ALBEDO = color * texture(tex, UV).rgb;
	float shd = -NORMAL.x*shade_angles.x-NORMAL.y*shade_angles.y-NORMAL.z*shade_angles.z;
	if (shd > 0.5) {
		ALBEDO = mix(ALBEDO, vec3(0,0,0), shade);
	}
}


void vertex() {
	//float speed = 7.;
	float speed = 4.;
	if (int(floor(TIME*speed)) % 2 == 0) {
		VERTEX.x += sin(VERTEX.y*4.)*0.1 * wobble_amp;
	}
	else {
		VERTEX.z += cos(VERTEX.y*8.)*0.1 * wobble_amp;
	}
}