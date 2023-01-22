#version 120

varying vec3 texcoord;
attribute vec4 mc_Entity;

#define ENTITY_WATER 10008
#define ENTITY_BEACON 10092

#define SHADOW_MAP_BIAS 0.80f

void main() {

	vec4 shadowPos = gl_ModelViewProjectionMatrix * gl_Vertex;
	float distortion = mix(1, length(shadowPos.xy * 1.25f), SHADOW_MAP_BIAS) * 0.85f;
	shadowPos.xy /= distortion;

	gl_Position = shadowPos;

	texcoord.xy = gl_MultiTexCoord0.xy;

	texcoord.z = float(mc_Entity.x != ENTITY_WATER);

}
