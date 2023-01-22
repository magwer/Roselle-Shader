#version 120

#define MC_OLD_LIGHTING
#define SHADOW_ENABLE

#ifdef SHADOW_ENABLE
	const int shadowMapResolution = 512; // [64 128 256 512 1024 2048 4096 8192]

	#define SHADER_BIAS_ADDITION 0.0f // [-0.01f -0.0095f -0.009f -0.0085f -0.008f -0.0075f -0.007f -0.0065f -0.006f -0.0055f -0.005f -0.0045f -0.004f -0.0035f -0.003f -0.0025f -0.002f -0.0015f -0.001f -0.0005f 0.0f 0.0005f 0.001f 0.0015f 0.002f 0.0025f 0.003f 0.0035f 0.004f 0.0045f 0.005f 0.0055f 0.006f 0.0065f 0.007f 0.0075f 0.008f 0.0085f 0.009f 0.0095f 0.01f 0.0105f 0.011f 0.0115f 0.012f]
	#define GRASS_SHADOW_FIX 3 // [0 1 2 3]
#endif
varying vec2 texcoord;
varying vec4 lmcoord;
attribute vec4 mc_Entity;

#ifdef SHADOW_ENABLE
	uniform vec3 shadowLightPosition;
	uniform mat4 shadowModelView;
	uniform mat4 shadowProjection;
	uniform mat4 gbufferModelViewInverse;
	varying float mag_NdotL;
	varying vec3 mag_shaodwPos;

	const float biasBase = 0.008f * 512 / shadowMapResolution + SHADER_BIAS_ADDITION + 0.05;

	#define SHADOW_MAP_BIAS 0.8f
	#define diagonal3(mat) vec3(mat[0].x, mat[1].y, mat[2].z)

#endif

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
#define ENTITY_AOA3_GRASS 10032

float blockId = mc_Entity.x;

#ifdef SHADOW_ENABLE

	vec3 calShadow(in vec3 shadowPos) {

		shadowPos = mat3(shadowModelView) * shadowPos + shadowModelView[3].xyz;
		shadowPos = diagonal3(shadowProjection) * shadowPos + shadowProjection[3].xyz;

		float distortion = mix(1, length(shadowPos.xy * 1.25f), SHADOW_MAP_BIAS) * 0.85f;
		shadowPos.xy /= distortion;

		float cosine = dot(gl_Normal, normalize(shadowLightPosition));
		#if GRASS_SHADOW_FIX == 1 || GRASS_SHADOW_FIX == 2 || GRASS_SHADOW_FIX == 3
		float cantDiffuse = float(
			blockId == ENTITY_SMALLGRASS
				|| blockId == ENTITY_LOWERGRASS
				|| blockId == ENTITY_UPPERGRASS
				|| blockId == ENTITY_SMALLENTS
				//|| blockId == ENTITY_LEAVES
				|| blockId == ENTITY_VINES
				|| blockId == ENTITY_LILYPAD
				//|| blockId == ENTITY_FIRE
				|| blockId == ENTITY_COBWEB
				|| blockId == ENTITY_NETHERWART
				|| blockId == ENTITY_DEADBUSH
				|| blockId == ENTITY_AOA3_GRASS
			);

			#if GRASS_SHADOW_FIX == 2 || GRASS_SHADOW_FIX == 3
				mag_NdotL = clamp(mix(cosine, abs(cosine), cantDiffuse) * 1.02f - 0.02f, 0, 1);
				mag_NdotL = mix(mag_NdotL, 0.75f, cantDiffuse);
			#else
				mag_NdotL = clamp(cosine * 1.02f - 0.02f, 0, 1);
			#endif
				float bias = distortion * distortion * (biasBase * sqrt(1 - mag_NdotL * mag_NdotL) / mag_NdotL);
			bias = mix(bias, 0.0010f, cantDiffuse);
			#if GRASS_SHADOW_FIX == 3 || GRASS_SHADOW_FIX == 1
				mag_isEmissive = mix(mag_isEmissive, 1.0f, cantDiffuse);
			#endif
		#else
			mag_NdotL = clamp(cosine * 1.02f - 0.02f, 0, 1);
			float bias = distortion * distortion * (biasBase * sqrt(1 - mag_NdotL * mag_NdotL) / mag_NdotL);
		#endif
		shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5;
		shadowPos.z -= bias;

		return shadowPos.xyz;
	}
#endif

void main() {

  gl_Position = ftransform();
  texcoord = gl_MultiTexCoord0.st;
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

	#ifdef SHADOW_ENABLE
		mag_shaodwPos = calShadow(mat3(gbufferModelViewInverse) * (gl_ModelViewMatrix * gl_Vertex).xyz + gbufferModelViewInverse[3].xyz);
	#endif

}
