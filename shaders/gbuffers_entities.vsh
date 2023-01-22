#version 120

#define SHADOW_ENABLE

#ifdef SHADOW_ENABLE
	const int shadowMapResolution = 512; // [64 128 256 512 1024 2048 4096 8192]

	#define MORNING_SHADOW_MUL 1.0 // [0.0 0.025 0.05 0.075 0.1 0.125 0.15 0.275 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5]
	#define DAY_SHADOW_MUL 0.75 // [0.0 0.025 0.05 0.075 0.1 0.125 0.15 0.275 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5]
	#define NIGHT_SHADOW_MUL 0.625 // [0.0 0.025 0.05 0.075 0.1 0.125 0.15 0.275 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5]
	#define SHADER_BIAS_ADDITION 0.0f // [-0.01f -0.0095f -0.009f -0.0085f -0.008f -0.0075f -0.007f -0.0065f -0.006f -0.0055f -0.005f -0.0045f -0.004f -0.0035f -0.003f -0.0025f -0.002f -0.0015f -0.001f -0.0005f 0.0f 0.0005f 0.001f 0.0015f 0.002f 0.0025f 0.003f 0.0035f 0.004f 0.0045f 0.005f 0.0055f 0.006f 0.0065f 0.007f 0.0075f 0.008f 0.0085f 0.009f 0.0095f 0.01f 0.0105f 0.011f 0.0115f 0.012f]
#endif

varying vec4 texcoord;
varying vec4 lmcoord;

#ifdef SHADOW_ENABLE
	uniform int worldTime;
	uniform vec3 shadowLightPosition;
	uniform mat4 shadowModelView;
	uniform mat4 shadowProjection;
	uniform mat4 gbufferModelViewInverse;
	varying vec3 mag_shaodwPos;
	varying float mag_NdotL;

	const float biasBase = 0.008f * shadowMapResolution / 512 + SHADER_BIAS_ADDITION;

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

	float calStrength(float morning, float day, float night) {
		return mix(night, mix(day, morning, morningMul), 1 - nightMul);
	}
#endif

void main() {

  gl_Position = ftransform();
  texcoord.st = gl_MultiTexCoord0.st;
  lmcoord = gl_MultiTexCoord1;
  mag_normal = gl_NormalMatrix * gl_Normal;
  mag_color = gl_Color;

	#ifdef SHADOW_ENABLE
		texcoord.b = 1 - (clamp((worldTime - 12000) / 500.0f, 0, 1) - clamp((worldTime - 13000) / 500.0f, 0, 1) + clamp((worldTime - 22500) / 500.0f, 0, 1) - clamp((worldTime - 23250) / 500.0f, 0, 1));
		if (texcoord.b != 0) {
			nightMul = clamp((worldTime - 12000) / 1000.0f, 0, 1) - clamp((worldTime - 23000) / 1000.0f, 0, 1);
			morningMul = 1 - clamp((12500 - worldTime) / 1000.0f, 0, 1) - clamp((worldTime - 23500) / 1000.0f, 0, 1) - clamp((worldTime - 500) / 1000.0f, -0.5f, 0);
			mag_shaodwPos = calShadow(mat3(gbufferModelViewInverse) * (gl_ModelViewMatrix * gl_Vertex).xyz + gbufferModelViewInverse[3].xyz);
			texcoord.a = calStrength(MORNING_SHADOW_MUL, DAY_SHADOW_MUL, NIGHT_SHADOW_MUL);
		}
	#endif

}
