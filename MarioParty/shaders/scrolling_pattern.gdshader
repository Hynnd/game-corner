shader_type canvas_item;

uniform sampler2D tex:repeat_enable,filter_nearest;
uniform vec2 velocity;

void fragment() {
	float speed = 7.;
	float screen_size = 960.;
	float tex_size = 128.;
	vec2 uv = (UV*screen_size/tex_size) + TIME * velocity;
	//if (int(floor(TIME*speed)) % 2 == 0) {
		//uv.x += sin(uv.y*55. + uv.x * 24.)*0.005;
	//}
	vec4 col = texture(tex, uv);
	COLOR *= col;
}
