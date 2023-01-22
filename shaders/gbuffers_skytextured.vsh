#version 120

varying vec2 texcoord;

varying vec4 mag_color;

void main() {

  gl_Position = ftransform();
  texcoord = gl_MultiTexCoord0.st;
  mag_color = gl_Color;

}
