#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;
const int compositeFormat = RGBA16;

// #define WORLDTIME_ANIMATION
// #define WATER_OPAQUE
// #define WATER_BLOCK_FIX

#define WATER_CAUSTIC 3 // [0 2 3 1]

#if WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3
/* DRAWBUFFERS:01234 */
#else
/* DRAWBUFFERS:0123 */
#endif

#if WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3
  const int gaux1Format = RGBA16;
#endif
#ifndef WATER_OPAQUE
  #define WATER_THIN_COLOR vec4(0, 0, 0, 0.105f)
#else
  #define WATER_OPAQUE_COLOR_R 0.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  #define WATER_OPAQUE_COLOR_G 0.3 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  #define WATER_OPAQUE_COLOR_B 0.7 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  #define WATER_OPAQUE_COLOR_A 0.65 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  #define WATER_THIN_COLOR vec4(WATER_OPAQUE_COLOR_R, WATER_OPAQUE_COLOR_G, WATER_OPAQUE_COLOR_B, WATER_OPAQUE_COLOR_A)
#endif
#define WATER_WAVE
#define WATER_WAVE_SPEED 0.15 // [0.02 0.04 0.06 0.08 0.1 0.15 0.2 0.25 0.3]
#define WATER_WAVE_SIZE 0.2 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6]
#define WATER_WAVE_AMPLITUDE 0.2 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define TRANSLUCENT_LIGHT

uniform sampler2D texture;
varying vec3 texcoord;
varying vec2 lmcoord;

uniform sampler2D gdepth;
uniform sampler2D gnormal;
uniform sampler2D composite;

varying vec4 mag_tintcolor;
varying vec3 mag_normal;
#if defined WATER_WAVE || WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3

  uniform int isEyeInWater;
  varying vec3 mag_positionAbs;

  #if defined WORLDTIME_ANIMATION
    uniform int worldTime;
    float frameTime = worldTime;
  #else
    uniform float frameTimeCounter;
    float frameTime = frameTimeCounter * 15;
  #endif

  float waterH(vec2 posxz) {

    float factor = 2.0f;

    vec2 pxy = vec2(posxz) / 50 + 250;
    vec2 fpxy = abs(fract(pxy * 20) - 0.5f) * 2;
    float d = length(fpxy);
    float p1 = pxy.x * pxy.y * WATER_WAVE_SIZE;

    float wave = 0.0f;
    for (int i = 0; i < 3; i++) {
    	wave -= d * factor * cos((1 / factor) * p1 + frameTime * WATER_WAVE_SPEED);
    	factor *= 0.5f;
    }

    factor = 1.0f;
    pxy = vec2(-posxz.x / 50 + 250, -posxz.y / 150 - 250);
    fpxy = abs(fract(pxy * 20) - 0.5f) * 2;
    d = length(fpxy);
    p1 = pxy.x * pxy.y * WATER_WAVE_SIZE;

    float wave2 = 0.0f;
    for (int i = 0; i < 3; i++) {
      wave2 -= d * factor * cos((1 / factor) * p1 + frameTime * WATER_WAVE_SPEED);
      factor *= 0.5f;
    }

    return WATER_WAVE_AMPLITUDE * wave2 + WATER_WAVE_AMPLITUDE * wave;
  }
#endif
#ifdef WATER_WAVE
  varying mat3 mag_tbnMatrix;
#endif

void main() {
  if (texcoord.z > 0) {

    #if defined WATER_WAVE || WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3
      if (isEyeInWater == 1) {
          gl_FragData[0] = WATER_THIN_COLOR;
          gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
      }
      #ifdef WATER_WAVE
      	float deltaPos = 0.2;

    		float h0 = waterH(mag_positionAbs.xz);
    		float h1 = waterH(mag_positionAbs.xz + vec2(deltaPos, 0));
    		float h2 = waterH(mag_positionAbs.xz + vec2(-deltaPos, 0));
    		float h3 = waterH(mag_positionAbs.xz + vec2(0, deltaPos));
    		float h4 = waterH(mag_positionAbs.xz + vec2(0, -deltaPos));

      	float xDelta = ((h1 - h0) + (h0 - h2)) / deltaPos;
      	float yDelta = ((h3 - h0) + (h0 - h4)) / deltaPos;

      	vec3 newnormal = normalize(vec3(xDelta, yDelta, 1 - xDelta * xDelta - yDelta * yDelta));
        float bumpmult = 0.05f;
    		vec3 bump = newnormal * bumpmult + vec3(0, 0, 1 - bumpmult);
        gl_FragData[2] = vec4(normalize(bump * mag_tbnMatrix) * 0.5f + 0.5f, 1);
      #else
        gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
      #endif
      #if WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3
        gl_FragData[4] = vec4(normalize(vec3(2 * xDelta, 2 * yDelta, 1 - 4 * xDelta * xDelta - 4 * yDelta * yDelta)) * 0.5f + 0.5f, 1);
      #endif
    #else
      gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
    #endif
    gl_FragData[0] = WATER_THIN_COLOR;
    gl_FragData[3] = vec4(0, 1, max(lmcoord.s, lmcoord.t) / 240.0f, 1);
  }
  else {
    vec4 color = texture2D(texture, texcoord.st);
    gl_FragData[0] = color * mag_tintcolor;
    #ifdef TRANSLUCENT_LIGHT
      gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.5f, 1);
    #endif
    gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
    #ifdef WATER_BLOCK_FIX
      gl_FragData[3] = vec4(0, 0.1f, 0, 0.5f);
    #else
      gl_FragData[3] = vec4(0, 0, 0, 1);
    #endif
  }

}
