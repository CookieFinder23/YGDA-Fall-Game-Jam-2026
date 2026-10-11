shader_type canvas_item;

uniform bool yah_or_nah;

void fragment() {
	if(yah_or_nah)
	{
		COLOR = vec4(1, 1, 1, COLOR.a);
	}
}
