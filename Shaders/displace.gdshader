shader_type canvas_item;

uniform float amount: hint_range(0.0, 5) = 1.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	vec4 offset = texture(TEXTURE, UV);
	vec4 color = texture(SCREEN_TEXTURE, SCREEN_UV - vec2(offset.r, offset.b) * 0.05 * amount);
	COLOR = color;
}