#version 120

const int RGBA16 = 1;
const int gcolorFormat = RGBA16;

/* DRAWBUFFERS: 0 */

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 mag_tintcolor;

void main() {
  vec4 color = texture2D(texture, texcoord);
  gl_FragData[0] = color * mag_tintcolor;
}
