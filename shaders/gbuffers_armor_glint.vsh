#version 120

varying vec2 texcoord;

varying vec4 mag_tintcolor;

void main() {
  gl_Position = ftransform();
  texcoord.st = (gl_TextureMatrix[0] * gl_MultiTexCoord0).st;
  mag_tintcolor = gl_Color;
}
