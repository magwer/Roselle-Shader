#version 120

#define SHADOW_ENABLE

#ifdef SHADOW_ENABLE
	const int shadowMapResolution = 512; // [64 128 256 512 1024 2048 4096 8192]

	#define SHADER_BIAS_ADDITION 0.0f // [-0.01f -0.0095f -0.009f -0.0085f -0.008f -0.0075f -0.007f -0.0065f -0.006f -0.0055f -0.005f -0.0045f -0.004f -0.0035f -0.003f -0.0025f -0.002f -0.0015f -0.001f -0.0005f 0.0f 0.0005f 0.001f 0.0015f 0.002f 0.0025f 0.003f 0.0035f 0.004f 0.0045f 0.005f 0.0055f 0.006f 0.0065f 0.007f 0.0075f 0.008f 0.0085f 0.009f 0.0095f 0.01f 0.0105f 0.011f 0.0115f 0.012f]
#endif

varying vec2 texcoord;
varying vec4 lmcoord;

#ifdef SHADOW_ENABLE
	uniform int worldTime;
	uniform vec3 shadowLightPosition;
	uniform mat4 shadowModelView;
	uniform mat4 shadowProjection;
	uniform mat4 gbufferModelViewInverse;
	varying vec3 mag_shaodwPos;
	varying float mag_NdotL;

	const float biasBase = 0.008f * 512 / shadowMapResolution + SHADER_BIAS_ADDITION + 0.05;

	#define SHADOW_MAP_BIAS 0.8f
	#define diagonal3(mat) vec3(mat[0].x, mat[1].y, mat[2].z)

	float nightMul;
	float morningMul;
#endif

varying vec4 mag_color;
varying vec3 mag_normal;

#ifdef SHADOW_ENABLE
	vec3 calShadow(in vec3 shadowPos) {
		
		shadowPos = mat3(shadowModelView) * shadowPos + shadowModelView[3].xyz;
		shadowPos = diagonal3(shadowProjection) * shadowPos + shadowProjection[3].xyz;

		float distortion = mix(1, length(shadowPos.xy * 1.25f), SHADOW_MAP_BIAS) * 0.85f;
		shadowPos.xy /= distortion;

		mag_NdotL = clamp(dot(mag_normal, normalize(shadowLightPosition)) * 1.02f - 0.02f, 0, 1);
		float bias = distortion * distortion * (biasBase * sqrt(1 - mag_NdotL * mag_NdotL) / mag_NdotL);

		shadowPos.xyz = shadowPos.xyz * 0.5 + 0.5;
		shadowPos.z -= bias;

		return shadowPos.xyz;
	}
#endif

void main() {

  gl_Position = ftransform();
  texcoord = gl_MultiTexCoord0.st;
  lmcoord = gl_MultiTexCoord1;
  mag_normal = gl_NormalMatrix * gl_Normal;
  mag_color = gl_Color;
  #ifdef SHADOW_ENABLE
		mag_shaodwPos = calShadow(mat3(gbufferModelViewInverse) * (gl_ModelViewMatrix * gl_Vertex).xyz + gbufferModelViewInverse[3].xyz);
  #endif
}
