#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA16;

// #define LIGHT_SHAFT
// #define MOTION_BLUR
// #define DOF
// #define SATURATION
// #define CONTRAST
#define VIGNETTE
#define BLOOM
#define BLOOM_RANGE 5 // [1 2 3 4 5 6 7]
#define BLOOM_FACTOR 0.04 // [0.02 0.022 0.024 0.026 0.028 0.03 0.032 0.034 0.36 0.038 0.04 0.042 0.044 0.046 0.048 0.05 0.055 0.06 0.065 0.07 0.075 0.08 0.085 0.09 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.1 1.2 1.3 1.4 1.5]
#define LIGHT_SHAFT_STRENGTH 0.15 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.375 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define EXPOSURE
#define EXPOSURE_VALUE 0.6 // [0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0]
#define BRIGHTNESS
#define BRIGHTNESS_VALUE 1.0 // [0.0 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.65 1.7 1.75 1.8 1.85 1.9 1.95 2.0 2.05 2.1 2.15 2.2 2.25 2.3 2.35 2.4 2.45 2.5 2.55 2.6 2.65 2.7 2.75 2.8 2.85 2.9 2.95 3.0]
#define SATURATION_VALUE 1.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.375 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.1 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.2 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.3 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.4 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.5 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.6 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.7 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.8 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.0]
#define CONTRAST_VALUE 1.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.375 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.1 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.2 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.3 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.4 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.5 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.6 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.7 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.8 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.0]

uniform sampler2D gcolor;
varying vec2 texcoord;
#if defined MOTION_BLUR || defined DOF
  uniform sampler2D gaux2;
#endif
#ifdef LIGHT_SHAFT
  uniform sampler2D gaux3;
#endif
#if defined BLOOM || defined LIGHT_SHAFT || defined MOTION_BLUR || defined DOF
  uniform float viewHeight;
#endif
#ifdef MOTION_BLUR
  uniform float viewWidth;
#endif
#ifdef VIGNETTE
  const vec2 center = vec2(0.5f);
#endif
#if defined BLOOM && !defined MOTION_BLUR && !defined DOF
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

#ifdef MOTION_BLUR
  float calDitherPattern1() {
  	const int[16] ditherPattern = int[16] (
      0 , 9 , 3 , 11,
      13, 5 , 15, 7 ,
      4 , 12, 2,  10,
      16, 8 , 14, 6
    );
  	vec2 count = floor(mod(vec2(texcoord) * vec2(viewWidth, viewHeight), 4));
  	return ditherPattern[int(dot(floor(count), vec2(1, 4)))] / 17.0f;
  }
#endif

void main() {

  vec3 color = texture2D(gcolor, texcoord).rgb;

  #if defined BLOOM && !defined MOTION_BLUR && !defined DOF
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
    color += bloom.rgb * BLOOM_FACTOR;
  #endif

  #ifdef LIGHT_SHAFT
    vec3 sum;
    for (int i = -2; i <= 2; i++)
      sum += texture2D(gaux3, texcoord.st + vec2(0, i / viewHeight)).rgb;
      color = mix(color, sum, 0.2f * LIGHT_SHAFT_STRENGTH);
  #endif

  #if defined MOTION_BLUR || defined DOF
    vec4 velocity = texture2D(gaux2, texcoord);
  #endif
  #ifdef MOTION_BLUR
  	float dither = calDitherPattern1();
  	vec3 blur = vec3(0.0f);
  	for (int i = 0; i < 2; ++i) {
  		vec2 coord = texcoord + velocity.st * (i - 0.5f + dither);
      blur += texture2D(gcolor, clamp(coord, 0, 1)).rgb;
  	}
  	color = mix(color, blur / 3, velocity.a);
  #elif defined DOF
    float dofDis =  velocity.b;
    vec3 dcolor = vec3(0);
    for (int i = -5; i < 6; i++)
      dcolor += texture2D(gcolor, texcoord + vec2(0, i / viewHeight)).rgb;
    color = mix(color, dcolor / 11, velocity.a * dofDis);
  #endif

  #ifdef SATURATION
    float gray = 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
    color = mix(vec3(gray), color, SATURATION_VALUE);
  #endif

  #ifdef EXPOSURE
	 color = color * EXPOSURE_VALUE;
  #endif

  #ifdef VIGNETTE
    float dis = max(distance(texcoord, center) - 0.2f, 0);
    color *= 1 - pow(dis, 1.3f) * 2.2f;
  #endif

	color *= 3.2;
	color = color / sqrt(color * color + 1.0f);
  #ifdef BRIGHTNESS
    color *= BRIGHTNESS_VALUE;
  #endif
  #ifdef CONTRAST
    color = pow(color, vec3(CONTRAST_VALUE));
  #endif
  color = pow(color, vec3(1 / 2.2f));
  gl_FragColor = vec4(color, 1);

}