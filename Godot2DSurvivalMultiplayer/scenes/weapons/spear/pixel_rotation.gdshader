shader_type canvas_item;

varying mat2 _Rot;

uniform float _Biais : hint_range(0, 0.1, 0.0001) = 0.01;

vec2 rotate_uv(vec2 uv, mat2 rot){
	return rot * (uv - 0.5) + 0.5;
}

vec2 scale_uv(vec2 uv, vec2 s){
	return (uv - 0.5) * s + 0.5;
}

void vertex(){
	_Rot = mat2(MODEL_MATRIX);
}

void fragment(){
	vec2 def = 1./TEXTURE_PIXEL_SIZE;
	vec2 scale = vec2(def.x / def.y, 1.);
	
	vec2 new_uv = UV;
	new_uv = scale_uv(new_uv, scale);
	new_uv = rotate_uv(new_uv, _Rot);
	def /= scale;
	new_uv = floor(new_uv * def) / (def-1.);
	new_uv = rotate_uv(new_uv, transpose(_Rot));
	new_uv = scale_uv(new_uv, 1./scale);

	bvec2 lim0 = greaterThanEqual(new_uv, vec2(0.-_Biais));
	bvec2 lim1 = lessThanEqual(new_uv, vec2(1.+_Biais));
	
	float mask = float(all(lim0) && all(lim1));
	COLOR = texture(TEXTURE, new_uv) * mask;
}

