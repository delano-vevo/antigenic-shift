shader_type canvas_item;

uniform bool hit_flash = false;

void fragment() {
	vec4 sprite_color = texture(TEXTURE, UV);
	vec3 passthrough_rgb = hit_flash ? vec3(1.0,1.0,1.0) : sprite_color.rgb;
	COLOR = vec4(passthrough_rgb, sprite_color.a);
}
