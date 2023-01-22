#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;

#define BLOOM
#define GRASS_SHADOW_FIX 3 // [0 1 2 3]

#if GRASS_SHADOW_FIX == 1 || GRASS_SHADOW_FIX == 3 || defined BLOOM
  const int compositeFormat = RGBA16;
/* DRAWBUFFERS:0123 */
#else
/* DRAWBUFFERS:012 */
#endif

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 lmcoord;

varying vec4 mag_tintcolor;
varying vec3 mag_normal;

void main() {

  vec4 handColor = texture2D(texture, texcoord);
  vec4 lmVec = vec4(lmcoord.st / 240.0f, 0.4f, 1);
  handColor *= mag_tintcolor;

  gl_FragData[0] = handColor;
  gl_FragData[1] = lmVec;
  gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
  #if GRASS_SHADOW_FIX == 1 || GRASS_SHADOW_FIX == 3 || defined BLOOM
    gl_FragData[3] = vec4(0.9, 0, 0, 1);
  #endif

}
