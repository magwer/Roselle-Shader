#version 120

#define WEATHER_PARTICLES

#ifdef WEATHER_PARTICLES
varying vec2 texcoord;
#endif

void main() {

  gl_Position = ftransform();
  #ifdef WEATHER_PARTICLES
    texcoord = gl_MultiTexCoord0.st;
  #endif

}
