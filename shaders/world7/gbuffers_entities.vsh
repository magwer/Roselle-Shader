#version 120

varying vec2 texcoord;
varying vec4 lmcoord;

varying vec4 mag_color;
varying vec3 mag_normal;

void main() {

  gl_Position = ftransform();
  texcoord = gl_MultiTexCoord0.st;
  lmcoord = gl_MultiTexCoord1;
  mag_normal = gl_NormalMatrix * gl_Normal;
  mag_color = gl_Color;

}
