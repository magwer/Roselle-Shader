#version 120

varying vec2 texcoord;
uniform sampler2D texture;

varying vec4 mag_color;

/* DRAWBUFFERS:04 */

void main() {

  gl_FragData[0] = texture2D(texture, texcoord) * mag_color;
  gl_FragData[1] = vec4(0, 0, 0.1f, 1);

}
