#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;
const int compositeFormat = RGBA16;

/* DRAWBUFFERS:0123 */

#define SHADOW_ENABLE

#ifdef SHADOW_ENABLE
  const int shadowMapResolution = 512; // [64 128 256 512 1024 2048 4096 8192]

	#define SHADER_FILTER_TYPE 0 // [0 1 2 3 4 5]
#endif

uniform sampler2D texture;
varying vec4 texcoord;
varying vec4 lmcoord;

#ifdef SHADOW_ENABLE
	uniform sampler2DShadow shadowtex0;
	uniform sampler2DShadow shadowtex1;
	uniform sampler2D shadowcolor0;
	varying float mag_NdotL;
	varying vec3 mag_shadowPos;
  	vec2 shaderPosXY = mag_shadowPos.xy;

  #if SHADER_FILTER_TYPE > 0
 	 const vec2 offsetBase = vec2(0.25f, -0.25f);
  #endif
#endif

varying vec4 mag_tintcolor;
varying vec3 mag_normal;
varying float mag_isEmissive;

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
	  float posZ = mag_shadowPos.z;
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
	    return min(shadow2D(shadowTex, mag_shadowPos).x * mag_NdotL, 1);
	  #endif
	}

	vec4 calShadows() {
		bool noLight = texcoord.b == 0;
		if (noLight || mag_isEmissive <= 0.5f)
			return vec4(vec3(mix(1, 0.55f + lmcoord.t * 0.001666f, float(noLight))), 1);
    else if (mag_NdotL <= 0)
        return vec4(mix(vec3(0.55f + lmcoord.t * 0.001666f), mix(vec3(1), vec3(0), texcoord.a), texcoord.b), 0);
	else {
		float shading = shadowfilter(shadowtex0);
		float cshading = shadowfilter(shadowtex1);
		vec3 finalShading = texture2D(shadowcolor0, shaderPosXY).rgb * (cshading - shading) + shading;
		return vec4(mix(vec3(0.55f + lmcoord.t * 0.001666f), mix(vec3(1), finalShading, texcoord.a), texcoord.b), shading);
	  }
	}
#endif

void main() {

	vec4 blockColor = texture2D(texture, texcoord.st) * mag_tintcolor;
	#ifdef SHADOW_ENABLE
    vec4 shadow = calShadows();
	blockColor.rgb = pow(blockColor.rgb, vec3(2.2f)) * shadow.rgb;
	blockColor.rgb = pow(blockColor.rgb, vec3(1 / 2.2f));
  	gl_FragData[3] = vec4(mag_isEmissive, 0, 1 - shadow.a, 1);
	#else
		gl_FragData[3] = vec4(mag_isEmissive, 0, 0, 1);
	#endif

	gl_FragData[0] = blockColor;
	gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.5f, 1);
	gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);

}
