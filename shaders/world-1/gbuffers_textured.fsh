#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int R32F = 114;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gaux2Format = RGBA16;
const int gaux3Format = RGBA16;

#define PARTICLE_DRAWORDER_FIX 1 // [0 1 2]
#define PARTICLE_FOG_FIX 1 // [0 1 2]
#define PARTICLE_FIX 2 // [0 1 2]

#if PARTICLE_FOG_FIX == 2 || PARTICLE_DRAWORDER_FIX == 2
  varying float mag_dis;
#endif
/* DRAWBUFFERS:01256 */

uniform sampler2D texture;
varying vec2 texcoord;

varying vec4 mag_tintcolor;
#if PARTICLE_FIX == 1 || PARTICLE_FIX == 2
  varying vec4 lmcoord;
#endif

void main() {

  vec4 color = texture2D(texture, texcoord);
  #if PARTICLE_FIX == 1
    color.rgb *= min(max(lmcoord.s, lmcoord.t) / 240.0f + 0.2f, 1);
    gl_FragData[0] = color * mag_tintcolor;
    gl_FragData[1] = vec4(0, 0, 0.8f, 1);
  #elif PARTICLE_FIX == 2
    gl_FragData[0] = color * mag_tintcolor;
    gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.8f, 1);
    gl_FragData[2] = vec4(0, 0, 0, 1);
  #else
    gl_FragData[0] = color * mag_tintcolor;
  #endif
  #if PARTICLE_DRAWORDER_FIX == 1 || PARTICLE_DRAWORDER_FIX == 2
    gl_FragData[3] = color * mag_tintcolor;
  #endif
  #if PARTICLE_FOG_FIX == 2 || PARTICLE_DRAWORDER_FIX == 2
    gl_FragData[4] = vec4((1.0f / mag_dis) * float(mag_dis > 0), 0, 0, 1);
  #endif

}
