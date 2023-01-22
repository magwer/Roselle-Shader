#version 120

#define PARTICLE_DRAWORDER_FIX 1 // [0 1 2]
#define PARTICLE_FOG_FIX 1 // [0 1 2]
#define PARTICLE_FIX 2 // [0 1 2]

uniform int worldTime;
varying vec3 texcoord;

varying vec4 mag_tintcolor;

#if PARTICLE_FOG_FIX == 2 || PARTICLE_DRAWORDER_FIX == 2
  varying float mag_dis;
#endif
#if PARTICLE_FIX == 1 || PARTICLE_FIX == 2
  varying vec4 lmcoord;
#endif

void main() {

  #if PARTICLE_FOG_FIX == 2 || PARTICLE_DRAWORDER_FIX == 2
    vec4 positionInViewCoord = gl_ModelViewMatrix * gl_Vertex;
    gl_Position = gl_ProjectionMatrix * positionInViewCoord;
    mag_dis = length(positionInViewCoord.xyz);
  #else
    gl_Position = ftransform();
  #endif

  texcoord.st = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;

  #if PARTICLE_FIX == 1 || PARTICLE_FIX == 2
    #if PARTICLE_FIX == 1
      texcoord.z = 1 - (clamp((worldTime - 13000) / 1000.0f, 0, 1) - clamp((worldTime - 23000) / 1000.0f, 0, 1)) * 0.6f;
    #endif
    lmcoord = gl_MultiTexCoord1;
  #endif
  mag_tintcolor = gl_Color;

}
