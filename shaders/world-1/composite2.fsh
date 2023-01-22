#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA16;

/* DRAWBUFFERS:0 */

#define BLOOM
#define BLOOM_RANGE 5 // [1 2 3 4 5 6 7]
#define BLOOM_FACTOR 0.04 // [0.02 0.022 0.024 0.026 0.028 0.03 0.032 0.034 0.36 0.038 0.04 0.042 0.044 0.046 0.048 0.05 0.055 0.06 0.065 0.07 0.075 0.08 0.085 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.1 1.2 1.3 1.4 1.5]

uniform sampler2D gcolor;

varying vec2 texcoord;

#ifdef BLOOM
  uniform float viewHeight;
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

  gl_FragData[0] = color;
}
