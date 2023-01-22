#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;

/* DRAWBUFFERS:0123 */

#define SHADOW_ENABLE

#ifdef SHADOW_ENABLE
  const int shadowMapResolution = 512; // [64 128 256 512 1024 2048 4096 8192]

	#define END_SHADOW_MUL 0.75 // [0.0 0.025 0.05 0.075 0.1 0.125 0.15 0.275 0.2 0.225 0.25 0.275 0.3 0.325 0.35 0.375 0.4 0.425 0.45 0.475 0.5 0.525 0.55 0.575 0.6 0.625 0.65 0.675 0.7 0.725 0.75 0.775 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5]
	#define SHADER_FILTER_TYPE 0 // [0 1 2 3 4 5]
#endif

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 lmcoord;
uniform vec4 entityColor;

#ifdef SHADOW_ENABLE
  uniform sampler2DShadow shadowtex0;
  varying float mag_NdotL;
  varying vec3 mag_shaodwPos;

  #if SHADER_FILTER_TYPE > 0
    vec2 shaderPosXY = mag_shaodwPos.xy;
    const vec2 offsetBase = vec2(0.25f, 0.25f);
  #endif
#endif

varying vec3 mag_normal;
varying vec4 mag_color;

#ifdef SHADOW_ENABLE
	#if SHADER_FILTER_TYPE == 3
		const float gaussianMatrix[9] = float[9] (
			 0.0947416f, 0.118318f, 0.0947416f,
	 		 0.0947416f, 0.147761f, 0.0947416f,
	 		 0.0947416f, 0.118318f, 0.0947416f
	  );
	#elif SHADER_FILTER_TYPE == 5
		const float gaussianMatrix[25] = float[25] (
			 0.0144188f, 0.0280840f, 0.0350727f, 0.0280840f, 0.0144188f,
	     0.0280840f, 0.0547002f, 0.0683123f, 0.0547002f, 0.0280840f,
	     0.0350727f, 0.0683123f, 0.0853117f, 0.0683123f, 0.0350727f,
	     0.0280840f, 0.0547002f, 0.0683123f, 0.0547002f, 0.0280840f,
	     0.0144188f, 0.0280840f, 0.0350727f, 0.0280840f, 0.0144188f
	  );
	#endif

	float shadowfilter(sampler2DShadow shadowTex) {
	  float posZ = mag_shaodwPos.z;
	  #if SHADER_FILTER_TYPE == 1
	  	vec2 offset = offsetBase / shadowMapResolution;
	  	return clamp(dot(vec4(
	      shadow2D(shadowTex, vec3(shaderPosXY + offset.xx, posZ)).x,
	  	  shadow2D(shadowTex, vec3(shaderPosXY + offset.yx, posZ)).x,
	  	  shadow2D(shadowTex, vec3(shaderPosXY + offset.xy, posZ)).x,
	  	  shadow2D(shadowTex, vec3(shaderPosXY + offset.yy, posZ)).x
	    ), vec4(0.25f)) * mag_NdotL, 0, 1);
	  #elif SHADER_FILTER_TYPE == 2
	    float total = 0;
	    for (int i = -1; i <= 1; i++)
	      for (int j = -1; j <= 1; j++)
	        total += shadow2D(shadowTex, vec3(shaderPosXY + vec2(i, j) / shadowMapResolution, posZ)).x * 0.1111111f;
	    return min(total * mag_NdotL, 1);
	  #elif SHADER_FILTER_TYPE == 3
	    float total = 0;
	    for (int i = -1; i <= 1; i++)
	      for (int j = -1; j <= 1; j++)
	        total += shadow2D(shadowTex, vec3(shaderPosXY + vec2(i, j) / shadowMapResolution, posZ)).x * gaussianMatrix[i + 1 + (j + 1) * 3];
	    return min(total * mag_NdotL, 1);
	  #elif SHADER_FILTER_TYPE == 4
	    float total = 0;
	    for (int i = -2; i <= 2; i++)
	      for (int j = -2; j <= 2; j++)
	        total += shadow2D(shadowTex, vec3(shaderPosXY + vec2(i, j) / shadowMapResolution, posZ)).x * 0.04f;
	    return min(total * mag_NdotL, 1);
	  #elif SHADER_FILTER_TYPE == 5
	    float total = 0;
	    for (int i = -2; i <= 2; i++)
	      for (int j = -2; j <= 2; j++)
	        total += shadow2D(shadowTex, vec3(shaderPosXY + vec2(i, j) / shadowMapResolution, posZ)).x * gaussianMatrix[i + 2 + (j + 1) * 5];
	    return min(total * mag_NdotL, 1);
	  #else
	    return min(shadow2D(shadowTex, mag_shaodwPos).x * mag_NdotL, 1);
      return min(shadow2D(shadowTex, mag_shaodwPos).x * mag_NdotL, 1);
	  #endif
	}

vec2 calShadows() {
	if (mag_NdotL <= 0)
    	return vec2(mix(1.0f, 0.0f, END_SHADOW_MUL), 1.0f);
  	else {
		float shading = shadowfilter(shadowtex0);
    	return vec2(mix(1.0f, shadowfilter(shadowtex0), END_SHADOW_MUL), shading);
  	}
}
#endif

void main() {

  if (lmcoord.s > 255)
    return;

  float magAlpha = mag_color.a;
  bool tag1 = magAlpha > 0.125f && magAlpha < 0.1255f;
  bool tag2 = magAlpha > 0.247f && magAlpha < 0.248f;
  if (tag1 || tag2) {
    gl_FragData[0] = vec4(0, 0, 0, mix(0, 0.2f, float(tag2)));
    gl_FragData[1] = vec4(0, 0, 0, 1);
  }
  else {
    vec4 texColor = texture2D(texture, texcoord.st);
	vec4 finalColor = mix(texColor * mag_color, vec4(entityColor.rgb, entityColor.a), entityColor.a);
    #ifdef SHADOW_ENABLE
      vec2 shadow = calShadows();
    	finalColor.rgb = pow(finalColor.rgb, vec3(2.2f)) * shadow.r;
    	finalColor.rgb = pow(finalColor.rgb, vec3(1 / 2.2f));
      gl_FragData[3] = vec4(0, 0, shadow.g, 1);
    #endif
    gl_FragData[0] = finalColor;
    gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.5, 1);
  }
  gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
}
