shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;
uniform sampler2D DEPTH_TEXTURE : source_color, hint_depth_texture;
varying vec3 world_coords;

uniform float depth_range:hint_range(0.1, 100.0, 0.1);

void vertex(){
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	world_coords = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	float roughness =  texture(NORMAL_TEXTURE, uv).w;
	
	float depth = texture(DEPTH_TEXTURE, SCREEN_UV).x;
	vec3 ndc = vec3(SCREEN_UV * 2.0 - 1.0, depth);
	vec4 view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	view.xyz /= view.w;
	float linear_depth = -view.z / depth_range;
	
	vec3 source_position = vec3(0,0,0);
	
	vec3 possession_ring_color = vec3(sin(linear_depth*100.0),0,0);
	
	vec3 composited_color = vec3(screen_color + possession_ring_color);

	
	
	
	
	// example outputs
	
	ALBEDO = vec3(linear_depth); 	// showing depth texture
	//ALBEDO = normal; 				// showwwing normal texture
	//ALBEDO = vec3(roughness); 	// showing roughness texture
	//ALBEDO = screen_color;		// showing screen texture
	//ALBEDO = world_coords;	
	//ALBEDO = vec3(1,1,1);	
	//ALBEDO = possession_ring_color;		// showing screen texture
}