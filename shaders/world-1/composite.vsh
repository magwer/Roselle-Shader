#version 120
varying vec3 texcoord;

void main() {

  gl_Position = ftransform();
  texcoord.st = gl_MultiTexCoord0.st;

}
