#version 120

#define WEATHER_PARTICLES

#ifdef WEATHER_PARTICLES

  const int RGBA16 = 1;
  const int gcolorFormat = RGBA16;

  uniform sampler2D texture;
  varying vec2 texcoord;
#else
/* DRAWBUFFERS:0 */
#endif


void main() {

  #ifdef WEATHER_PARTICLES
    vec4 weatherColor = texture2D(texture, texcoord.st);
    gl_FragData[0] = mix(weatherColor, vec4(0.35f, 0.35f, 0.45f, 1), weatherColor.a);
  #else
    gl_FragData[0] = vec4(0);
  #endif

}
