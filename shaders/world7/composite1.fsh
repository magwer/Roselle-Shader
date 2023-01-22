#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA16;
const int gnormalFormat = RGBA16;
const int compositeFormat = RGBA16;
const int gaux1Format = RGBA16;

// #define LIGHT_SHAFT
#define FOG
#define BLOOM
#define BLOOM_RANGE 5 // [1 2 3 4 5 6 7]
#define WATER_REFRACTION 1 // [0 1 2]
#define WATER_REFLECTION
#define WATER_REFLECTION_BRIGHTNESS 0.5 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]
#define WATER_REFLECTION_OPACITY 0.8 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]

/* DRAWBUFFERS:016 */

uniform sampler2D gcolor;
varying vec2 texcoord;

#if defined FOG && defined WATER_REFLECTION
  uniform sampler2D gaux1;
#endif
#if WATER_REFRACTION != 0
  uniform sampler2D gnormal;
#endif
#ifdef WATER_REFLECTION
  uniform sampler2D composite;
#endif

#if defined BLOOM || defined LIGHT_SHAFT
  uniform float viewWidth;
#endif
#ifdef BLOOM
  const bool gdepthMipmapEnabled = true;

  uniform sampler2D gdepth;

  vec4 getScale(vec2 pos, vec2 anchor, int fact) {
    vec2 newCoord = (pos - anchor) * fact;
    if(newCoord.x < 0 || newCoord.x > 1 || newCoord.y < 0 || newCoord.y > 1)
      return vec4(0, 0, 0, 1);
    vec4 sum = vec4(0);
    for (int i = -2; i < 3; i++) {
      float fi = float(i);
      float weight = 1.0f - abs(fi) / 3.5f;
      sum += texture2D(gdepth, newCoord + vec2(fi / viewWidth, 0) * fact) * weight;
    }
    return sum;
  }
#endif
#ifdef LIGHT_SHAFT
  uniform sampler2D gaux3;
#endif

void main() {

  vec4 color = texture2D(gcolor, texcoord.st);

  #ifdef LIGHT_SHAFT
    vec3 sum;
    for (int i = -2; i <= 2; i++)
      sum += texture2D(gaux3, texcoord.st + vec2(i / viewWidth, 0)).rgb;
    gl_FragData[2] = vec4(sum * 0.2f, 1);
  #endif

  #if WATER_REFRACTION != 0
    vec4 refractData = texture2D(gnormal, texcoord.st);
    color.rgb = mix(color.rgb, texture2D(gcolor, refractData.rg).rgb, refractData.b);
  #endif

  #ifdef WATER_REFLECTION
    vec4 reflectData = texture2D(composite, texcoord.st);
    color.rgb = mix(color.rgb, texture2D(gcolor, reflectData.rg).rgb * WATER_REFLECTION_BRIGHTNESS, reflectData.b * WATER_REFLECTION_OPACITY);
    #ifdef FOG
      vec4 fogData = texture2D(gaux1, texcoord.st);
      color.rgb = mix(color.rgb, fogData.rgb, fogData.a);
    #endif
  #endif

  gl_FragData[0] = color;

  #ifdef BLOOM
    vec4 bloom = getScale(texcoord, vec2(0.0f, 0), 4);
    #if BLOOM_RANGE >= 2
      bloom += getScale(texcoord, vec2(0.3f, 0), 8);
    #endif
    #if BLOOM_RANGE >= 3
      bloom += getScale(texcoord, vec2(0.5f, 0), 16);
    #endif
    #if BLOOM_RANGE >= 4
      bloom += getScale(texcoord, vec2(0.6f, 0), 32);
    #endif
    #if BLOOM_RANGE >= 5
      bloom += getScale(texcoord, vec2(0.7f, 0), 64);
    #endif
    #if BLOOM_RANGE >= 6
      bloom += getScale(texcoord, vec2(0.8f, 0), 128);
    #endif
    #if BLOOM_RANGE >= 7
      bloom += getScale(texcoord, vec2(0.9f, 0), 256);
    #endif
    gl_FragData[1] = vec4(bloom.rgb, 1);
  #endif

}
