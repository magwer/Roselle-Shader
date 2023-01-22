#version 120

// #define WORLDTIME_ANIMATION
#define WATER_WAVE

attribute vec2 mc_Entity;
varying vec3 texcoord;
varying vec2 lmcoord;

varying vec4 mag_tintcolor;
varying vec3 mag_normal;

#ifdef WATER_WAVE
  attribute vec4 at_tangent;
  uniform mat4 gbufferModelViewInverse;
  uniform mat4 gbufferModelView;
  uniform vec3 cameraPosition;

  varying vec4 mag_positionInViewCoord;
  varying vec3 mag_positionAbs;
  varying mat3 mag_tbnMatrix;

  #ifdef WORLDTIME_ANIMATION
    uniform int worldTime;
    float frameTime = worldTime;
  #else
    uniform float frameTimeCounter;
    float frameTime = frameTimeCounter * 15;
#endif
#endif

#define ENTITY_WATER 10008

void main() {

  bool isWater = mc_Entity.x == ENTITY_WATER;
  texcoord.z = float(isWater);
	mag_normal = gl_NormalMatrix * gl_Normal;
  lmcoord = gl_MultiTexCoord1.st;

  #ifdef WATER_WAVE
  	if (isWater) {
  		mag_positionInViewCoord = gl_ModelViewMatrix * gl_Vertex;
  		vec4 worldPos = gbufferModelViewInverse * mag_positionInViewCoord;

  		mag_positionAbs = worldPos.xyz + cameraPosition;
  		float y = fract(mag_positionAbs.y);
  		if (y < 0.01f || y > 0.99f)
  			gl_Position = gl_ProjectionMatrix * mag_positionInViewCoord;
  		else {
  			worldPos.y += clamp(0.03f * sin((frameTime * 0.26f + mag_positionAbs.x * 1.2f + mag_positionAbs.z * 3.4f))
  				+ 0.05f * sin((frameTime * 0.15f + mag_positionAbs.x * 6.5f + mag_positionAbs.z * 10.1f)), -0.07f, 0.07f) + 0.02f;
  			gl_Position = gl_ProjectionMatrix * (gbufferModelView * worldPos);
  		}

    	vec3 tangent = normalize(gl_NormalMatrix * at_tangent.xyz);
      vec3 binormal = normalize(cross(tangent, mag_normal));
      mag_tbnMatrix = transpose(mat3(tangent, binormal, mag_normal));
  	}
  	else {
  		gl_Position = ftransform();
  	  mag_tintcolor = gl_Color;
  	  texcoord.st = gl_MultiTexCoord0.st;
      vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
      gl_Position = gl_ProjectionMatrix * viewPos;
  	}
  #else
    vec4 viewPos = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gl_ProjectionMatrix * viewPos;
    mag_tintcolor = gl_Color;
    texcoord.st = gl_MultiTexCoord0.st;
  #endif

}
