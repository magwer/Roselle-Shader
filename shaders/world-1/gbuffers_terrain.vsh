#version 120

#define MC_OLD_LIGHTING

varying vec4 texcoord;
varying vec4 lmcoord;
attribute vec4 mc_Entity;

varying vec4 mag_tintcolor;
varying vec3 mag_normal;
varying float mag_isEmissive;

#define ENTITY_EMISSIVE_PRO 10089
#define ENTITY_EMISSIVE 10090
#define ENTITY_EMISSIVE_TORCH 10091
#define ENTITY_SMALLGRASS 10031
#define ENTITY_LOWERGRASS 10175
#define ENTITY_UPPERGRASS	10176
#define ENTITY_SMALLENTS 10059
#define ENTITY_LEAVES 10018
#define ENTITY_VINES 10106
#define ENTITY_WATER 10008
#define ENTITY_LILYPAD 10111
#define ENTITY_FIRE 10051
#define ENTITY_LAVA 10010
#define ENTITY_COBWEB 10030
#define ENTITY_NETHERWART 10115
#define ENTITY_DEADBUSH 10032

float blockId = mc_Entity.x;

void main() {

  gl_Position = ftransform();
  texcoord.st = gl_MultiTexCoord0.st;
  lmcoord = gl_MultiTexCoord1;
  mag_tintcolor = gl_Color;
	vec3 worldnormal = gl_Normal;
  mag_normal = gl_NormalMatrix * worldnormal;

	#ifdef MC_OLD_LIGHTING
		if (mag_tintcolor.r != 1.0f && mag_tintcolor.g != 1.0f && mag_tintcolor.b != 1.0f) {
			if (worldnormal.x > 0.85)
				mag_tintcolor.rgb *= 1.0f / 0.6f;
			else if (worldnormal.x < -0.85)
				mag_tintcolor.rgb *= 1.0f / 0.6f;
			else if (worldnormal.z > 0.85)
				mag_tintcolor.rgb *= 1.0f / 0.8f;
			else if (worldnormal.z < -0.85)
				mag_tintcolor.rgb *= 1.0f / 0.8f;
			else if (worldnormal.y < -0.85)
				mag_tintcolor.rgb *= 1.0f / 0.5f;
		}
	#endif

	if (blockId == ENTITY_EMISSIVE_TORCH)
		mag_isEmissive = 0.2f;
	else if (blockId == ENTITY_EMISSIVE_PRO)
		mag_isEmissive = 0.1f;
	else if (blockId == ENTITY_EMISSIVE)
		mag_isEmissive = 0.8f;
	else
		mag_isEmissive = 0.9f;

}
