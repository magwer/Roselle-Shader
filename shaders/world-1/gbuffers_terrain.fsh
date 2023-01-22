#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;
const int compositeFormat = RGBA16;

/* DRAWBUFFERS:0123 */

uniform sampler2D texture;
varying vec4 texcoord;
varying vec4 lmcoord;

varying vec4 mag_tintcolor;
varying vec3 mag_normal;
varying float mag_isEmissive;

void main() {

  vec4 blockColor = texture2D(texture, texcoord.st);
  blockColor *= mag_tintcolor;

  gl_FragData[0] = blockColor;
  gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.5f, 1);
  gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
  gl_FragData[3] = vec4(mag_isEmissive, 0, 0, 1);

}
