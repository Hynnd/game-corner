shader_type spatial;
render_mode ambient_light_disabled,unshaded;

uniform vec3 color:source_color;
uniform float shade = 0.1;
uniform vec3 shade_angles = vec3(0.3,1,0.4);
uniform vec3 shade_color:source_color = vec3(0);

void fragment() {
	ALBEDO = color;
	float shd = -NORMAL.x*shade_angles.x-NORMAL.y*shade_angles.y-NORMAL.z*shade_angles.z;
	if (shd > 0.5) {
		ALBEDO = mix(ALBEDO, shade_color, shade);
	}
}
