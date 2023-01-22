#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;

/* DRAWBUFFERS:012 */

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 lmcoord;
uniform vec4 entityColor;

varying vec3 mag_normal;
varying vec4 mag_color;

void main() {
  vec4 texColor = texture2D(texture, texcoord);
  vec4 finalColor = mix(texColor * mag_color, entityColor, entityColor.a);

  gl_FragData[0] = mix(finalColor, vec4(1), 0.3);
  gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.1f, 1);
  gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
}
