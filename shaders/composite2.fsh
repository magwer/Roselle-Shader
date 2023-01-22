#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA16;

/*DRAWBUFFERS:0 */

// #define LIGHT_SHAFT
#define BLOOM
#define BLOOM_RANGE 5 // [1 2 3 4 5 6 7]
#define BLOOM_FACTOR 0.04 // [0.02 0.022 0.024 0.026 0.028 0.03 0.032 0.034 0.36 0.038 0.04 0.042 0.044 0.046 0.048 0.05 0.055 0.06 0.065 0.07 0.075 0.08 0.085 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.1 1.2 1.3 1.4 1.5]
#define LIGHT_SHAFT_STRENGTH 0.15 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.375 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
uniform sampler2D gcolor;

varying vec2 texcoord;

#if defined BLOOM || defined LIGHT_SHAFT
  uniform float viewHeight;
#endif
#ifdef BLOOM
  uniform sampler2D gdepth;

  const float blurWeight2 = pow(2, 0.25f);
  const float blurWeight3 = pow(3, 0.25f);
  const float blurWeight4 = pow(4, 0.25f);
  const float blurWeight5 = pow(5, 0.25f);
  const float blurWeight6 = pow(6, 0.25f);
  const float blurWeight7 = pow(7, 0.25f);

  vec4 getScaleAndBlur(vec2 anchor, int fact) {
    vec2 scaledCoord = texcoord.st / fact + anchor;
    vec2 relCoord = scaledCoord - anchor;
    float upperLimit = 1.0f / fact;
    if(relCoord.x < 0 || relCoord.x > upperLimit || relCoord.y < 0 || relCoord.y > upperLimit)
      return vec4(0);
    vec4 sum = vec4(0);
    for (int i = -2; i < 3; i++) {
      float fi = float(i);
      float weight = 1.0f - abs(fi) / 3.5;
      sum += texture2D(gdepth, scaledCoord + vec2(0, fi / viewHeight)) * weight;
    }
    return sum;
  }
#endif
#ifdef LIGHT_SHAFT
  uniform sampler2D gaux3;
#endif

void main() {
  vec4 color = texture2D(gcolor, texcoord);
  #ifdef BLOOM
    vec4 bloom = vec4(0);
    #if BLOOM_RANGE == 1
      bloom += getScaleAndBlur(vec2(0.0, 0), 4);
    #elif BLOOM_RANGE == 2
      bloom += getScaleAndBlur(vec2(0.0, 0), 4) * blurWeight2;
      bloom += getScaleAndBlur(vec2(0.3, 0), 8);
    #elif BLOOM_RANGE == 3
      bloom += getScaleAndBlur(vec2(0.0, 0), 4) * blurWeight3;
      bloom += getScaleAndBlur(vec2(0.3, 0), 8) * blurWeight2;
      bloom += getScaleAndBlur(vec2(0.5, 0), 16);
    #elif BLOOM_RANGE == 4
      bloom += getScaleAndBlur(vec2(0.0, 0), 4) * blurWeight4;
      bloom += getScaleAndBlur(vec2(0.3, 0), 8) * blurWeight3;
      bloom += getScaleAndBlur(vec2(0.5, 0), 16) * blurWeight2;
      bloom += getScaleAndBlur(vec2(0.6, 0), 32);
    #elif BLOOM_RANGE == 5
      bloom += getScaleAndBlur(vec2(0.0, 0), 4) * blurWeight5;
      bloom += getScaleAndBlur(vec2(0.3, 0), 8) * blurWeight4;
      bloom += getScaleAndBlur(vec2(0.5, 0), 16) * blurWeight3;
      bloom += getScaleAndBlur(vec2(0.6, 0), 32) * blurWeight2;
      bloom += getScaleAndBlur(vec2(0.7, 0), 64);
    #elif BLOOM_RANGE == 6
      bloom += getScaleAndBlur(vec2(0.0, 0), 4) * blurWeight6;
      bloom += getScaleAndBlur(vec2(0.3, 0), 8) * blurWeight5;
      bloom += getScaleAndBlur(vec2(0.5, 0), 16) * blurWeight4;
      bloom += getScaleAndBlur(vec2(0.6, 0), 32) * blurWeight3;
      bloom += getScaleAndBlur(vec2(0.7, 0), 64) * blurWeight2;
      bloom += getScaleAndBlur(vec2(0.8, 0), 128);
    #elif BLOOM_RANGE == 7
      bloom += getScaleAndBlur(vec2(0.0, 0), 4) * blurWeight7;
      bloom += getScaleAndBlur(vec2(0.3, 0), 8) * blurWeight6;
      bloom += getScaleAndBlur(vec2(0.5, 0), 16) * blurWeight5;
      bloom += getScaleAndBlur(vec2(0.6, 0), 32) * blurWeight4;
      bloom += getScaleAndBlur(vec2(0.7, 0), 64) * blurWeight3;
      bloom += getScaleAndBlur(vec2(0.8, 0), 128) * blurWeight2;
      bloom += getScaleAndBlur(vec2(0.9, 0), 256);
    #endif
    color.rgb += bloom.rgb * BLOOM_FACTOR;
  #endif

  #ifdef LIGHT_SHAFT
    vec3 sum;
    for (int i = -2; i <= 2; i++)
      sum += texture2D(gaux3, texcoord.st + vec2(0, i / viewHeight)).rgb;
    color.rgb = mix(color.rgb, sum, 0.2f * LIGHT_SHAFT_STRENGTH);
  #endif

  gl_FragData[0] = color;
}
