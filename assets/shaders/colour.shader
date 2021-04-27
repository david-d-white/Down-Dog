shader_type canvas_item;

uniform vec4 colour : hint_color = vec4(1.0);
uniform bool enabled = false;

void fragment() {
	vec4 tex_col = texture(TEXTURE, UV);
	if (enabled)
		COLOR = mix(tex_col, vec4(colour.rgb, tex_col.a), colour.a);
	else
		COLOR = tex_col;
}