#version 120

varying vec4 mag_color;

/* DRAWBUFFERS:04 */

void main() {

  gl_FragData[0] = mag_color;
  gl_FragData[1] = vec4(0, 0, 0.1f, 1);

}
