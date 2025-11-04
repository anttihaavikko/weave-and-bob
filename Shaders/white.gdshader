shader_type canvas_item;

uniform vec3 color: source_color = vec3(1, 1, 1);

void fragment() {
	vec4 offset = texture(TEXTURE, UV);
	COLOR = vec4(color.rgb, offset.a);
}
