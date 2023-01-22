#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int RGBA32F = 2;
const int RGBA16F = 3;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA16;
const int gnormalFormat = RGBA16;
const int compositeFormat = RGBA16;
const int gaux1Format = RGBA16;
const int gaux2Format = RGBA16F;
const int gaux3Format = RGBA16;

#define NETHER_AMBIENTLIGHT_COLOR_R 0.8 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.375 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.1 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.2 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.3 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.4 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.5 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.6 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.7 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.8 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.0]
#define NETHER_AMBIENTLIGHT_COLOR_G 0.3 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.625 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.1 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.2 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.3 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.4 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.5 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.6 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.7 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.8 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.0]
#define NETHER_AMBIENTLIGHT_COLOR_B 0.5 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0 1.01 1.02 1.03 1.04 1.05 1.06 1.07 1.08 1.09 1.1 1.11 1.12 1.13 1.14 1.15 1.16 1.17 1.18 1.19 1.2 1.21 1.22 1.23 1.24 1.25 1.26 1.27 1.28 1.29 1.3 1.31 1.32 1.33 1.34 1.35 1.36 1.37 1.38 1.39 1.4 1.41 1.42 1.43 1.44 1.45 1.46 1.47 1.48 1.49 1.5 1.51 1.52 1.53 1.54 1.55 1.56 1.57 1.58 1.59 1.6 1.61 1.62 1.63 1.64 1.65 1.66 1.67 1.68 1.69 1.7 1.71 1.72 1.73 1.74 1.75 1.76 1.77 1.78 1.79 1.8 1.81 1.82 1.83 1.84 1.85 1.86 1.87 1.88 1.89 1.9 1.91 1.92 1.93 1.94 1.95 1.96 1.97 1.98 1.99 2.0]
#define NETHERAMBIENT_COLOR vec3(NETHER_AMBIENTLIGHT_COLOR_R, NETHER_AMBIENTLIGHT_COLOR_G, NETHER_AMBIENTLIGHT_COLOR_B)
#define NETHERAMBIENT_STRENGTH 0.5 // [0.0 0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9 1.0 1.1 1.2 1.3 1.4 1.5 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5 2.6 2.7 2.8 2.9 3.0 3.1 3.2 3.3 3.4 3.5 3.6 3.7 3.8 3.9 4.0 4.1 4.2 4.3 4.4 4.5 4.6 4.7 4.8 4.9 5.0]

#define NETHER_FOG_COLOR_R 0.04 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define NETHER_FOG_COLOR_G 0.002 // [0.0 0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define NETHER_FOG_COLOR_B 0.002 // [0.0 0.005 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLINDNESS_FOG_COLOR_R 0.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLINDNESS_FOG_COLOR_G 0.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLINDNESS_FOG_COLOR_B 0.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define NETHERFOG_COLOR vec3(NETHER_FOG_COLOR_R, NETHER_FOG_COLOR_G, NETHER_FOG_COLOR_B)
#define NETHERFOG_STRENGTH 0.15 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLINDNESSFOG_COLOR vec3(BLINDNESS_FOG_COLOR_R, BLINDNESS_FOG_COLOR_G, BLINDNESS_FOG_COLOR_B)
#define BLINDNESSFOG_STRENGTH 5.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLINDNESSFOG_FAR 5.0 // [0.0 0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 4.8 4.0 4.2 4.4 4.6 3.8 5.0 5.2 5.4 5.6 5.8 6.0 6.2 6.4 6.6 6.8 7.0 7.2 7.4 7.6 7.8 8.0 8.2 8.4 8.6 8.8 9.0]

#define NETHERFOG_FAR 3.0 // [0.0 0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 4.8 4.0 4.2 4.4 4.6 3.8 5.0 5.2 5.4 5.6 5.8 6.0 6.2 6.4 6.6 6.8 7.0 7.2 7.4 7.6 7.8 8.0 8.2 8.4 8.6 8.8 9.0]

#define BLOCK_LIGHT_COLOR_R 1.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLOCK_LIGHT_COLOR_G 0.62 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLOCK_LIGHT_COLOR_B 0.2 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define BLOCKLIGHT_COLOR vec3(BLOCK_LIGHT_COLOR_R, BLOCK_LIGHT_COLOR_G, BLOCK_LIGHT_COLOR_B)
#define BLOCKLIGHT_STRENGTH 7.0 // [0.0 0.2 0.4 0.6 0.8 1.0 1.2 1.4 1.6 1.8 2.0 2.2 2.4 2.6 2.8 3.0 3.2 3.4 3.6 3.8 4.0 4.2 4.4 4.6 4.8 5.0 5.2 5.4 5.6 5.8 6.0 6.2 6.4 6.6 6.8 7.0 7.2 7.4 7.6 7.8 8.0 8.2 8.4 8.6 8.8 9.0  9.2 9.4 9.6 9.8 10.0 10.2 10.4 10.6 10..8 11.0 11.2 11.4 11.6 11.8 12.0]
#define BLOCKLIGHT_TYPE 3 // [1 2 3]

#define EMISSIVEBLOCK_BLOOM_FACTOR 0.24 // [0.1 0.12 0.14 0.16 0.18 0.2 0.22 0.24 0.26 0.28 0.3 0.32 0.34 0.36 0.38 0.4 0.42 0.44 0.46 0.48 0.5 0.52 0.54 0.56 0.58 0.6]
#define EMISSIVETORCH_BLOOM_FACTOR 1.3 // [0.1 0.3 0.5 0.7 0.9 1.1 1.3 1.5 1.7 1.9 2.1 2.3 2.5 2.7 2.9 3.1 3.3 3.5 3.7 3.9 4.1 4.3 4.5 4.7 4.9 5]

// #define WORLDTIME_ANIMATION
// #define MOTION_BLUR
// #define DOF
#define AO
#define FOG
#define BLOOM
#define DESATURATION
#define MOTION_BLUR_STRENGTH 200.0 // [20.0 40.0 60.0 80.0 100.0 120.0 140.0 160.0 180.0 200.0 220.0 240.0 260.0 280.0 300.0 320.0 340.0 360.0 380.0 400.0 420.0 440.0 460.0 480.0 500.0]
#define DOF_STRENGTH 90.0 // [10.0 20.0 30.0 40.0 50.0 60.0 70.0 80.0 90.0 100.0 110.0 120.0 130.0 140.0 150.0 160.0 170.0 180.0 190.0 200.0 210.0 220.0 230.0 240.0 250.0 260.0 270.0 280.0 290.0 300.0]

#define WATER_FOG 3 // [0 1 2 3]
#define WATER_FOG_TYPE1_COLOR_R 0.25 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define WATER_FOG_TYPE1_COLOR_G 0.65 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define WATER_FOG_TYPE1_COLOR_B 0.75 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define WATER_FOG_TYPE1_COLOR vec3(WATER_FOG_TYPE1_COLOR_R, WATER_FOG_TYPE1_COLOR_G, WATER_FOG_TYPE1_COLOR_B)
#define WATER_FOG_TYPE1_START 0.05 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.22 0.24 0.26 0.28 0.3 0.32 0.34 0.36 0.38 0.4 0.44 0.48 0.52 0.56 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define WATER_FOG_TYPE1_STRENGTH_NEAR 0.85 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.2 1.3 1.4 1.5]
#define WATER_FOG_TYPE1_STRENGTH_FAR 0.07 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.22 0.24 0.26 0.28 0.3 0.32 0.34 0.36 0.38 0.4 0.42 0.44 0.46 0.48 0.5]
#define WATER_FOG_TYPE1_MAX 1.25 // [0.1 0.2 0.3 0.4 0.5 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.05 1.1 1.15 1.2 1.25 1.3 1.35 1.4 1.45 1.5 1.55 1.6 1.7 1.8 1.9 2.0 2.1 2.2 2.3 2.4 2.5]

#define WATER_FOG_TYPE2_COLOR_R 0.0 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define WATER_FOG_TYPE2_COLOR_G 0.02 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define WATER_FOG_TYPE2_COLOR_B 0.1 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define WATER_FOG_TYPE2_COLOR vec3(WATER_FOG_TYPE2_COLOR_R, WATER_FOG_TYPE2_COLOR_G, WATER_FOG_TYPE2_COLOR_B)
#define WATER_FOG_TYPE2_STRENGTH 0.07 // [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.22 0.24 0.26 0.28 0.3 0.32 0.34 0.36 0.38 0.4 0.44 0.48 0.52 0.56 0.6 0.64 0.68 0.72 0.76 0.8 0.85 0.9 0.95 1.0]
#define WATER_FOG_TYPE2_START -0.3 // [-3.0 -3.8 -2.6 -2.4 -2.2 -2.0 -1.8 -1.6 -1.4 -1.2 -1.0 -0.8 -0.6 -0.4 -0.3 -0.2 0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0]
#define WATER_FOG_TYPE2_MAX 0.9 // [0.0 0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1.0 1.1 1.2 1.3 1.4 1.5]

#define WATER_CAUSTIC 3 // [0 3 2 1]
#define WATER_REFRACTION 1 // [0 1 2]
#define WATER_REFLECTION
#define WATER_SKY_REFLECTION
#define WATER_SKY_REFLECTION_OPACITY 1 // [0.05 0.1 0.15 0.2 0.25 0.3 0.35 0.4 0.45 0.5 0.55 0.6 0.65 0.7 0.75 0.8 0.85 0.9 0.95 1]
#define WATER_SKY_REFLECTION_START 0.01 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
#define PARTICLE_DRAWORDER_FIX 1 // [0 1 2]
#define WATER_REFLECTION_RAYTRACE_ACCURENCY 0.2 // [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.12 0.14 0.18 0.2 0.22 0.24 0.26 0.28 0.30 0.35 0.4 0.45 0.5 0.6 0.7 0.8 0.9 1.0]
#define WATER_REFLECTION_RAYTRACE_ITERATIONS 20 // [2 4 6 8 10 12 14 16 18 20 22 24 26 28 30 32 34 36 38 40 42 44 46 48 50 55 60 65 70 75 80 85 90 95 100]
#define WATER_REFLECTION_RAYTRACE_METHOD 1 // [1 2]
#define PARTICLE_FIX 2 // [0 1 2]
#define PARTICLE_FOG_FIX 1 // [0 1 2]

/* DRAWBUFFERS:0123456 */

varying vec3 texcoord;
uniform sampler2D gcolor;
uniform sampler2D gdepth;
uniform sampler2D gnormal;
uniform sampler2D composite;
#if PARTICLE_DRAWORDER_FIX == 1 || PARTICLE_DRAWORDER_FIX == 2
  uniform sampler2D gaux2;
#endif
#if defined FOG && PARTICLE_FOG_FIX == 2 || PARTICLE_DRAWORDER_FIX == 2
  uniform sampler2D gaux3;
#endif
#if WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3
  uniform sampler2D gaux1;
  uniform mat4 gbufferModelView;
#endif
#if defined AO || defined SUNBLOOM || defined FOG || WATER_FOG != 0 || WATER_CAUSTIC != 0 || PARTICLE_DRAWORDER_FIX == 2 || defined WATER_REFRACTION || defined WATER_REFLECTION || defined WATER_SKY_REFLECTION || defined MOTION_BLUR
  uniform sampler2D depthtex0;
  uniform float viewWidth;
  uniform float viewHeight;
#endif
#if defined FOG || WATER_CAUSTIC != 0 || WATER_FOG != 0 || defined WATER_REFRACTION || defined WATER_SKY_REFLECTION || defined LIGHT_SHAFT
  uniform int isEyeInWater;
  uniform sampler2D depthtex1;
#endif
uniform vec3 shadowLightPosition;
uniform vec3 cameraPosition;
#ifdef MOTION_BLUR
  uniform vec3 previousCameraPosition;
  uniform mat4 gbufferPreviousModelView;
  uniform mat4 gbufferPreviousProjection;
#endif
#ifdef DOF
  const float centerDepthHalflife = 1; // [0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 32 34 36 38 40 42 44 46 48 50 55 60 65 70 75 80 85 90 95 100 110 120 130 140 150 160 170 180 190 200 220 240 260 280 300 320 340 360 380 400]
  uniform float centerDepthSmooth;
#endif
#if WATER_FOG != 0 || GRASS_SHADOW_FIX == 1 || GRASS_SHADOW_FIX == 3
  uniform vec3 upPosition;
#endif
uniform float near;
uniform float far;
uniform float aspectRatio;
#if defined SUNBLOOM || defined FOG || WATER_FOG != 0 || WATER_CAUSTIC != 0 || defined WATER_REFRACTION || defined WATER_REFLECTION || defined WATER_SKY_REFLECTION || defined MOTION_BLUR
  uniform mat4 gbufferProjectionInverse;
  uniform mat4 gbufferModelViewInverse;
#endif
#if defined WATER_REFLECTION || WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3 || defined LIGHT_SHAFT
  uniform mat4 gbufferProjection;
#endif
#ifdef WORLDTIME_ANIMATION
  uniform int worldTime;
  float frameTime = worldTime;
#else
  uniform float frameTimeCounter;
  float frameTime = frameTimeCounter * 15;
#endif
#if defined SUNBLOOM || defined LIGHT_SHAFT
  uniform vec3 sunPosition;
  uniform vec3 moonPosition;
#endif
#ifdef WATER_SKY_REFLECTION
  #define NETHER_SKY_COLOR_R 0.6 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  #define NETHER_SKY_COLOR_G 0.1 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  #define NETHER_SKY_COLOR_B 0.5 // [0.0 0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1 0.11 0.12 0.13 0.14 0.15 0.16 0.17 0.18 0.19 0.2 0.21 0.22 0.23 0.24 0.25 0.26 0.27 0.28 0.29 0.3 0.31 0.32 0.33 0.34 0.35 0.36 0.37 0.38 0.39 0.4 0.41 0.42 0.43 0.44 0.45 0.46 0.47 0.48 0.49 0.5 0.51 0.52 0.53 0.54 0.55 0.56 0.57 0.58 0.59 0.6 0.61 0.62 0.63 0.64 0.65 0.66 0.67 0.68 0.69 0.7 0.71 0.72 0.73 0.74 0.75 0.76 0.77 0.78 0.79 0.8 0.81 0.82 0.83 0.84 0.85 0.86 0.87 0.88 0.89 0.9 0.91 0.92 0.93 0.94 0.95 0.96 0.97 0.98 0.99 1.0]
  const vec3 mag_skyColor = vec3(NETHER_SKY_COLOR_R, NETHER_SKY_COLOR_G, NETHER_SKY_COLOR_B);
#endif
const vec3 mag_ambientLight = NETHERAMBIENT_COLOR * NETHERAMBIENT_STRENGTH;
#ifdef FOG
  uniform float blindness;
	vec3 mag_fogColor;
	float mag_fogStrength;
	float mag_fogFarMul;
#endif

const vec3 mag_blockLight = BLOCKLIGHT_COLOR * BLOCKLIGHT_STRENGTH;

#define ENTITY_MISSIVEBLOCK_PRO 10089
#define ENTITY_MISSIVEBLOCK 10090

#ifdef AO

  float ld(in float depth) {
     return (2 * near) / (far + near - depth * far + depth * near);
  }

  float dither5x3() {
  	const int ditherPattern[15] = int[15] (
  		 9, 3, 7,12, 0,
  		11, 5, 1, 8,14,
  		 2,13,10, 4, 6
       );

    vec2 position = floor(mod(vec2(texcoord.s * viewWidth, texcoord.t * viewHeight), vec2(5, 3)));
  	int dither = ditherPattern[int(position.x) + int(position.y) * 5];

  	return dither / 15.0f;
  }

  float calAO(sampler2D depth, float deep) {

  	float ao = 0.0f;

  	const int aoloop = 3;
  	const int aoside = 6;
  	const float piangle = 22.0 / (7*180);
  	float size = 0.2f;
  	float dither2 = dither5x3();
  	float d = ld(deep);
  	float rot = 0;
  	float scale = size * dither2;
  	float sd = 0.0;


  	for (int i = 0; i < aoloop; i++) {
      float angle = 0.0f;
      float dist = 0.0f;
  		for (int j = 0; j < aoside; j++) {
        float someAngle = rot * piangle;
  			sd = ld(
          texture2D(
            depth,
            texcoord.st + vec2(cos(someAngle), sin(someAngle))
              * scale / max(far * d, 16) * vec2(1 / aspectRatio, 1)).r
        );
        float someNumber = far * (d - sd) / size;
        angle += clamp(1 - 2 * someNumber, 0, 2);
  			dist += clamp(0.25f * someNumber, 0, 1);
  			rot += 360.0f / aoside;
  		}
  		rot += 180.0f / aoside;
  		scale = size + size * dither2;
  		size *= 2;
  		ao += clamp(angle / aoside + dist / aoside, 0, 1);
  	}

  	ao /= aoloop;
  	ao *= ao;

  	return ao;
  }

#endif

#if WATER_CAUSTIC == 2 || WATER_CAUSTIC == 3
  float waterH(vec2 posxz) {

    float factor = 2.0f;
    const float amplitude = 0.2f;
    const float speed = 0.15f;
    const float size = 0.2f;

    float wave = 0.0f;
    vec2 pxy = vec2(posxz) / 50 + 250;
    vec2 fpxy = abs(fract(pxy * 20) - 0.5f) * 2;

    float d = length(fpxy);
    float p1 = pxy.x * pxy.y * size;

    for (int i = 0; i < 3; i++) {
    	wave -= d * factor * cos((1 / factor) * p1 + frameTime * speed);
    	factor *= 0.5f;
    }

    float wave2 = 0.0f;
    factor = 1.0f;
    pxy = vec2(-posxz.x / 50 + 250, -posxz.y / 150 - 250);
    fpxy = abs(fract(pxy * 20) - 0.5f) * 2;

    d = length(fpxy);
    p1 = pxy.x * pxy.y * size;

    for (int i = 0; i < 3; i++) {
    	wave2 -= d * factor * cos((1/ factor) * p1 + frameTime * speed);
    	factor *= 0.5f;
    }

    return amplitude * wave2 + amplitude * wave;
  }
#endif

#if WATER_CAUSTIC == 1
  float calWaves(in vec2 pos) {

  	//float wsize = 2.9;
  	//float wspeed = 0.25f;

  	//float rs0 = abs(sin((worldTime*wspeed/5.0) + (pos.s*wsize) * 20.0)+0.2);
  	//float rs1 = abs(sin((worldTime*wspeed/7.0) + (pos.t*wsize) * 27.0));
  	//float rs2 = abs(sin((worldTime*wspeed/2.0) + (pos.t*wsize) * 60.0 - sin(pos.s*wsize) * 13.0)+0.4);
  	//float rs3 = abs(sin((worldTime*wspeed/1.0) - (pos.s*wsize) * 20.0 + cos(pos.t*wsize) * 83.0)+0.1);

  	float wsize2 = 2.0f;
  	float wspeed2 = 0.27f;

  	float rs0a = abs(sin((frameTime * wspeed2 / 4) + (pos.s * wsize2) * 24));
  	float rs1a = abs(sin((frameTime * wspeed2 / 11) + (pos.t * wsize2) * 77) + 0.3f);
  	float rs2a = abs(sin((frameTime * wspeed2 / 6) + (pos.s * wsize2) * 50 - (pos.t * wsize2) * 23.0)+0.12);
  	float rs3a = abs(sin((frameTime * wspeed2 / 14) - (pos.t * wsize2) * 4 + (pos.s * wsize2) * 98.0));

  	float wsize3 = 0.5f;
  	float wspeed3 = 0.35f;

  	float rs0b = abs(sin((frameTime * wspeed3 / 4) + (pos.s * wsize3) * 14));
  	float rs1b = abs(sin((frameTime * wspeed3 / 11) + (pos.t * wsize3) * 37));
  	float rs2b = abs(sin((frameTime * wspeed3 / 6) + (pos.t * wsize3) * 47 - cos(pos.s * wsize3) * 33 + rs0a + rs0b));
  	//float rs3b = abs(sin((worldTime*wspeed3/14.0) - (pos.s*wsize3) * 13.0 + sin(pos.t*wsize3) * 98.0 + rs0 + rs1));
  	float rs3b = abs(sin((frameTime * wspeed3 / 14) - (pos.s * wsize3) * 13 + sin(pos.t * wsize3) * 98));

  	//float waves = (rs1 * rs0 + rs2 * rs3)/2.0f;
  	float waves2 = (rs0a * rs1a + rs2a * rs3a) * 0.5f;
  	float waves3 = (rs0b + rs1b + rs2b + rs3b) * 0.25f;

  	return waves2 * 0.33333f + waves3 * 0.33333f;
  	//return (waves + waves2 + waves3)/3.0f;
  }
#endif

#ifdef WATER_REFLECTION
  #if WATER_REFLECTION_RAYTRACE_METHOD == 1
    vec3 reflectionRaytrace(float startDepth, vec3 startPoint, vec3 direction) {
        vec3 dxyz = direction * WATER_REFLECTION_RAYTRACE_ACCURENCY;
        vec3 point = startPoint;
        for(int i = 0; i < WATER_REFLECTION_RAYTRACE_ITERATIONS; i++) {
            point += dxyz;

            vec4 positionInScreenCoord = gbufferProjection * vec4(point, 1.0f);
            positionInScreenCoord.xyz /= positionInScreenCoord.w;
            positionInScreenCoord.xyz = positionInScreenCoord.xyz * 0.5f + 0.5f;

            if (positionInScreenCoord.x < 0 || positionInScreenCoord.x > 1 ||
              positionInScreenCoord.y < 0 || positionInScreenCoord.y > 1)
                return vec3(0);

            float depth = texture2D(depthtex0, positionInScreenCoord.st).r;
            float emissionChannel = texture2D(gdepth, positionInScreenCoord.st).b;
            float dis = positionInScreenCoord.z - depth;
            if (direction.z >= 0 == depth <= startDepth && dis > 0 && abs(emissionChannel - 0.4f) > 0.01f && abs(emissionChannel - 0.08f) > 0.005f) {
              float edge = abs(texcoord.s - 0.5) * 2;
              return vec3(positionInScreenCoord.st, 1 - clamp(edge * edge, 0, 1));
            }
        }
        return vec3(0);
    }
  #elif WATER_REFLECTION_RAYTRACE_METHOD == 2
    vec3 reflectionRaytrace(float startDepth, vec3 startPoint, vec3 direction) {
        vec3 totaldxyz = direction * WATER_REFLECTION_RAYTRACE_ACCURENCY * WATER_REFLECTION_RAYTRACE_ITERATIONS;
        vec3 r = totaldxyz * 0.5;
        vec3 point = startPoint + r;
        vec3 result = vec3(0);
        for(int i = 0; i < WATER_REFLECTION_RAYTRACE_ITERATIONS; i++) {
            r /= 2;

            vec4 positionInScreenCoord = gbufferProjection * vec4(point, 1.0f);
            positionInScreenCoord.xyz /= positionInScreenCoord.w;
            positionInScreenCoord.xyz = positionInScreenCoord.xyz * 0.5f + 0.5f;

            if (positionInScreenCoord.x < 0 || positionInScreenCoord.x > 1 ||
                positionInScreenCoord.y < 0 || positionInScreenCoord.y > 1) {
                  point -= r;
                  continue;
            }

            float depth = texture2D(depthtex0, positionInScreenCoord.st).r;
            float emissionChannel = texture2D(gdepth, positionInScreenCoord.st).b;
            float dis = positionInScreenCoord.z - depth;
            if (direction.z >= 0 == depth <= startDepth && dis > 0 && abs(emissionChannel - 0.4f) > 0.01f && abs(emissionChannel - 0.08f) > 0.005f) {
              float edge = abs(texcoord.s - 0.5) * 2;
              result = vec3(positionInScreenCoord.st, 1 - clamp(edge * edge, 0, 1));
              point -= r;
            }
            else
              point += r;
        }
        return result;
    }
  #endif
#endif

void main() {

    #ifdef FOG
      mag_fogColor = mix(NETHERFOG_COLOR, BLINDNESSFOG_COLOR, blindness);
      mag_fogStrength = mix(NETHERFOG_STRENGTH, BLINDNESSFOG_STRENGTH, blindness);
      mag_fogFarMul = mix(NETHERFOG_FAR, BLINDNESSFOG_FAR, blindness);
    #endif

  vec3 color = pow(texture2D(gcolor, texcoord.st).rgb, vec3(2.2f));
  vec3 normal = normalize(texture2D(gnormal, texcoord.st).rgb * 2 - 1);
  vec4 comp = texture2D(composite, texcoord.st);

  vec3 normalizeLightPosition = normalize(shadowLightPosition);
  vec4 blockLight = texture2D(gdepth, texcoord.st);
  float blockEmLight = blockLight.r;

	float emissionChannel = blockLight.b;
  float type = comp.r;
  bool isHand = emissionChannel > 0.39f && emissionChannel < 0.41f;

  #ifdef DESATURATION
    float gray = 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
    color = mix(vec3(gray), color, blockEmLight * 0.5 + 0.5);
  #endif

  vec3 finalColor = color;

  #if PARTICLE_FOG_FIX == 2 && defined FOG || PARTICLE_DRAWORDER_FIX == 2
    float particleDis = texture2D(gaux3, texcoord.st).r;
    if (particleDis != 0)
      particleDis = 1.0f / particleDis;
  #endif
  #if PARTICLE_DRAWORDER_FIX == 2 || PARTICLE_FOG_FIX == 2 && defined FOG
    float isParticle = float(particleDis > 0);
  #elif PARTICLE_FOG_FIX == 1 || PARTICLE_FIX == 1 || PARTICLE_FIX == 2
    float isParticle = float(emissionChannel > 0.79f && emissionChannel < 0.81f);
  #endif

  #if PARTICLE_DRAWORDER_FIX == 1
    vec4 particle = texture2D(gaux2, texcoord.st);
    finalColor = mix(finalColor, pow(particle.rgb, vec3(2.2f)), float(particle.a > 0 && comp.g > 0));
  #endif

  #if defined SUNBLOOM || defined FOG || WATER_FOG != 0 || WATER_CAUSTIC != 0 || PARTICLE_DRAWORDER_FIX == 2 || defined WATER_REFRACTION || defined WATER_REFLECTION || defined WATER_SKY_REFLECTION || defined MOTION_BLUR

    float depth = texture2D(depthtex0, texcoord.st).r;
    vec4 positionInNdcCoord = vec4(texcoord.st * 2 - 1, depth * 2 - 1, 1);
    vec4 positionInClipCoord = gbufferProjectionInverse * positionInNdcCoord;
    vec4 positionInViewCoord = vec4(positionInClipCoord.xyz / positionInClipCoord.w, 1.0);
    vec4 positionInWorldCoord = gbufferModelViewInverse * positionInViewCoord;
    vec3 absPos = positionInWorldCoord.xyz + cameraPosition;
    #if defined FOG && (PARTICLE_FOG_FIX == 1 || PARTICLE_FOG_FIX == 2)
      #if PARTICLE_FOG_FIX == 1
        float realabsdis = length(positionInViewCoord.xyz);
        float absDis = mix(realabsdis, 0, isParticle);
      #else
        float realabsdis = length(positionInViewCoord.xyz);
        float absDis = mix(realabsdis, particleDis, isParticle);
      #endif
    #else
      float realabsdis = length(positionInViewCoord.xyz);
      float absDis = realabsdis;
    #endif
    float dis = absDis / far;

    #if defined FOG || WATER_CAUSTIC != 0 || WATER_FOG != 0 || defined WATER_REFRACTION || defined WATER_SKY_REFLECTION || PARTICLE_DRAWORDER_FIX == 1 || PARTICLE_DRAWORDER_FIX == 2
      float depthWater = texture2D(depthtex1, texcoord.st).r;
      vec4 waterPositionInNdcCoord = vec4(texcoord.st * 2 - 1, depthWater * 2 - 1, 1);
      vec4 waterPositionInClipCoord = gbufferProjectionInverse * waterPositionInNdcCoord;
      vec4 waterPositionInViewCoord = vec4(waterPositionInClipCoord.xyz / waterPositionInClipCoord.w, 1.0);
      vec4 waterPositionInWorldCoord = gbufferModelViewInverse * waterPositionInViewCoord;
      vec3 waterAbsPos = waterPositionInWorldCoord.xyz + cameraPosition;
      float waterAbsDis = length(waterPositionInViewCoord.xyz);
      float waterDis = waterAbsDis - absDis;
      #if PARTICLE_DRAWORDER_FIX == 1
        bool atWater = particle.a == 0 && comp.g > 0.1f && isEyeInWater == 0 && waterDis > 0;
      #elif PARTICLE_DRAWORDER_FIX == 2
        bool atWater = comp.g > 0.1f && isEyeInWater == 0 && (particleDis == 0 || realabsdis <= particleDis);
      #else
        bool atWater = comp.g > 0.1f && isEyeInWater == 0 && waterDis > 0;
      #endif
    #endif
  #endif
  #if PARTICLE_DRAWORDER_FIX == 2
    vec4 particle = texture2D(gaux2, texcoord.st);
    finalColor = mix(finalColor, pow(particle.rgb, vec3(2.2f)), float(particle.a > 0 && comp.g > 0 && realabsdis > particleDis));
  #endif

	if (emissionChannel > 0.3) {
    #ifdef AO
      float ao = calAO(depthtex0, depth);
    #endif
  	finalColor = finalColor *
    #if PARTICLE_FIX == 1
      mix(vec3(1),
    #endif
    (
			mag_ambientLight +
      #if BLOCKLIGHT_TYPE == 3
        mix(1, 0.4f, float(isHand)) * blockEmLight * blockEmLight * blockEmLight * mag_blockLight
      #elif BLOCKLIGHT_TYPE == 2
        mix(1, 0.4f, float(isHand)) * blockEmLight * blockEmLight * mag_blockLight
      #else
        mix(1, 0.4f, float(isHand)) * blockEmLight * mag_blockLight
      #endif
    )
    #ifdef AO
			#if PARTICLE_FIX == 2
        * mix(1, ao, (1 - isParticle))
			#else
			   * ao
			#endif
    #endif
    #if PARTICLE_FIX == 1
    , 1 - isParticle)
    #endif
    ;
  }

  #if WATER_CAUSTIC != 0 || defined WATER_REFRACTION

    #if WATER_REFRACTION != 0
      vec4 refractData = vec4(0, 0, 0, 1);
    #endif
    #if WATER_CAUSTIC == 2
      if (atWater && waterAbsDis / far < 1.4f) {
        vec3 newnormal;
        vec4 waterDeepWorldPos = waterPositionInWorldCoord;
        waterDeepWorldPos.xyz += normalizeLightPosition;
        waterDeepWorldPos.y = positionInWorldCoord.y;
        vec4 waterDeepPositionInViewCoord = gbufferModelView * waterDeepWorldPos;
        vec4 waterDeepPositionInScreenCoord = gbufferProjection * waterDeepPositionInViewCoord;
        waterDeepPositionInScreenCoord.xyz /= waterDeepPositionInScreenCoord.w;
        waterDeepPositionInScreenCoord.xyz = waterDeepPositionInScreenCoord.xyz * 0.5f + 0.5f;
        bool outofrange = waterDeepPositionInScreenCoord.x < 0 || waterDeepPositionInScreenCoord.x > 1 ||
          waterDeepPositionInScreenCoord.y < 0 || waterDeepPositionInScreenCoord.y > 1;
        vec4 buffered = texture2D(gaux1, waterDeepPositionInScreenCoord.st);
        if (buffered.a > 0 && !outofrange)
          newnormal = buffered.rgb * 2 - 1;
        else {
          vec3 waterDeepPos = waterAbsPos + normalizeLightPosition;
          float deltaPos = 0.4;

          float h0 = waterH(waterDeepPos.xz);
          float h1 = waterH((waterDeepPos.xz + vec2(deltaPos, 0)));
          float h2 = waterH((waterDeepPos.xz + vec2(-deltaPos, 0)));
          float h3 = waterH((waterDeepPos.xz + vec2(0, deltaPos)));
          float h4 = waterH((waterDeepPos.xz + vec2(0, -deltaPos)));
          float xDelta = 2 * ((h1 - h0) + (h0 - h2)) / deltaPos;
          float yDelta = 2 * ((h3 - h0) + (h0 - h4)) / deltaPos;
          newnormal = normalize(vec3(xDelta, yDelta, 1 - xDelta * xDelta - yDelta * yDelta));
        }

        float cosine = dot(normalize(positionInViewCoord.xyz), newnormal);
        cosine = sqrt(1 - cosine * cosine);
        float factor = 1 - cosine;
        factor = factor * factor;
        finalColor *= mix(1, 1.0f + factor * 2.0f, min(texcoord.b + 0.4f, 1));
      }
    #endif
    #if WATER_CAUSTIC == 1 || WATER_CAUSTIC == 3 || defined WATER_REFRACTION
      if (isEyeInWater == 1 && waterDis == 0 || atWater && waterAbsDis / far < 1.4f) {
        #if WATER_CAUSTIC == 1
          vec3 waterDeepPos = waterAbsPos + normalizeLightPosition;

          float deltaPos = 0.4;

          float h0 = calWaves(waterDeepPos.xz * 0.02f);
          float h1 = calWaves((waterDeepPos.xz + vec2(deltaPos, 0)) * 0.02f);
          float h2 = calWaves((waterDeepPos.xz + vec2(-deltaPos, 0)) * 0.02f);
          float h3 = calWaves((waterDeepPos.xz + vec2(0, deltaPos)) * 0.02f);
          float h4 = calWaves((waterDeepPos.xz + vec2(0, -deltaPos)) * 0.02f);
          float xDelta = 2 * ((h1 - h0) + (h0 - h2)) / deltaPos;
          float yDelta = 2 * ((h3 - h0) + (h0 - h4)) / deltaPos;

          vec3 newnormal = normalize(vec3(xDelta, yDelta, 1 - xDelta * xDelta - yDelta * yDelta));

          float cosine = dot(normalize(positionInViewCoord.xyz), newnormal);
          cosine = sqrt(1 - cosine * cosine);
          float factor = 1 - cosine;
          factor = factor * factor;
          finalColor *= mix(1, 0.8f + factor * 2, min(texcoord.b + 0.4f, 1));
        #elif WATER_CAUSTIC == 3
          vec3 newnormal;
          if (isEyeInWater == 1) {
            vec3 waterDeepPos = waterAbsPos + normalizeLightPosition;
            float deltaPos = 0.4;

            float h0 = waterH(waterDeepPos.xz);
            float h1 = waterH((waterDeepPos.xz + vec2(deltaPos, 0)));
            float h2 = waterH((waterDeepPos.xz + vec2(-deltaPos, 0)));
            float h3 = waterH((waterDeepPos.xz + vec2(0, deltaPos)));
            float h4 = waterH((waterDeepPos.xz + vec2(0, -deltaPos)));
            float xDelta = 2 * ((h1 - h0) + (h0 - h2)) / deltaPos;
            float yDelta = 2 * ((h3 - h0) + (h0 - h4)) / deltaPos;
            newnormal = normalize(vec3(xDelta, yDelta, 1 - xDelta * xDelta - yDelta * yDelta));
          }
          else {
            vec4 waterDeepWorldPos = waterPositionInWorldCoord;
            waterDeepWorldPos.xyz += normalizeLightPosition;
            waterDeepWorldPos.y = positionInWorldCoord.y;
            vec4 waterDeepPositionInViewCoord = gbufferModelView * waterDeepWorldPos;
            vec4 waterDeepPositionInScreenCoord = gbufferProjection * waterDeepPositionInViewCoord;
            waterDeepPositionInScreenCoord.xyz /= waterDeepPositionInScreenCoord.w;
            waterDeepPositionInScreenCoord.xyz = waterDeepPositionInScreenCoord.xyz * 0.5f + 0.5f;
            bool outofrange = waterDeepPositionInScreenCoord.x < 0 || waterDeepPositionInScreenCoord.x > 1 ||
              waterDeepPositionInScreenCoord.y < 0 || waterDeepPositionInScreenCoord.y > 1;
            if (!outofrange)
              newnormal = normalize(texture2D(gaux1, waterDeepPositionInScreenCoord.st).rgb * 2 - 1);
            else {
              vec3 waterDeepPos = waterAbsPos + normalizeLightPosition;
              float deltaPos = 0.4;

              float h0 = waterH(waterDeepPos.xz);
              float h1 = waterH((waterDeepPos.xz + vec2(deltaPos, 0)));
              float h2 = waterH((waterDeepPos.xz + vec2(-deltaPos, 0)));
              float h3 = waterH((waterDeepPos.xz + vec2(0, deltaPos)));
              float h4 = waterH((waterDeepPos.xz + vec2(0, -deltaPos)));
              float xDelta = 2 * ((h1 - h0) + (h0 - h2)) / deltaPos;
              float yDelta = 2 * ((h3 - h0) + (h0 - h4)) / deltaPos;
              newnormal = normalize(vec3(xDelta, yDelta, 1 - xDelta * xDelta - yDelta * yDelta));
            }
          }

          float cosine = dot(normalize(positionInViewCoord.xyz), newnormal);
          cosine = sqrt(1 - cosine * cosine);
          float factor = 1 - cosine;
          factor = factor * factor;
          finalColor *= mix(1, 1.0f + factor * 2, min(texcoord.b + 0.4f, 1));
        #endif

        #if WATER_REFRACTION != 0
          vec2 refract = vec2(cos(texcoord.y * 32.0f + frameTime * 0.3f), sin(texcoord.x * 32.0f + frameTime * 0.3f)) * 0.001f;
          vec2 newcoord = texcoord.st + refract;
          refractData = vec4(newcoord, float(newcoord.x >= 0 && newcoord.x <= 1 && newcoord.y >= 0 && newcoord.y <= 1), 1);
        #endif
      }
    #endif
    #if WATER_REFRACTION != 0
      gl_FragData[2] = refractData;
    #endif
  #endif

  #if WATER_FOG != 0
    if (isEyeInWater == 1 || atWater) {
      float lightFactor = max(0, dot(normal, normalizeLightPosition));
      float cosine = dot(normal, normalize(upPosition));
      float temp1 = 1.0 - abs(sqrt(1 - cosine * cosine));
      temp1 = temp1 * temp1;
      temp1 = temp1 * temp1;
      float factor = temp1 * temp1;
      float realWaterDis = mix(waterDis, absDis, isEyeInWater);
      #if WATER_FOG == 1 || WATER_FOG == 3
        finalColor = mix(finalColor, finalColor * WATER_FOG_TYPE1_COLOR, WATER_FOG_TYPE1_START + min(min(realWaterDis, 1) * WATER_FOG_TYPE1_STRENGTH_NEAR + realWaterDis * WATER_FOG_TYPE1_STRENGTH_FAR, WATER_FOG_TYPE1_MAX));
      #endif
      #if WATER_FOG == 2 || WATER_FOG == 3
        finalColor = mix(finalColor, WATER_FOG_TYPE2_COLOR, clamp(realWaterDis * WATER_FOG_TYPE2_STRENGTH + WATER_FOG_TYPE2_START, 0, WATER_FOG_TYPE2_MAX));
      #endif
    }
  #endif

  #if defined WATER_SKY_REFLECTION || defined WATER_REFLECTION
    #ifdef WATER_REFLECTION
      vec3 reflectCoord = vec3(0);
    #endif
    if (atWater) {
      vec3 ref = reflect(positionInViewCoord.xyz, normal);
      #if !defined WATER_REFLECTION && defined WATER_SKY_REFLECTION
        float cosine = dot(normalize(positionInViewCoord.xyz), normal);
        float factor = sqrt(1 - cosine * cosine);
        factor = factor * factor;
        factor = factor * factor;
        factor = factor * factor;
        factor = factor * factor;
        factor = factor * factor;
        factor = factor * factor;
        finalColor = mix(finalColor, mag_skyColor, (factor * WATER_SKY_REFLECTION_OPACITY + float(cosine < 0) * WATER_SKY_REFLECTION_START));
      #endif
      #ifdef WATER_REFLECTION
        reflectCoord = reflectionRaytrace(depth, positionInViewCoord.xyz, ref);
        #ifdef WATER_SKY_REFLECTION
          if (reflectCoord.z == 0) {
            float cosine = dot(normalize(positionInViewCoord.xyz), normal);
            float factor = sqrt(1 - cosine * cosine);
            factor = factor * factor;
            factor = factor * factor;
            factor = factor * factor;
            factor = factor * factor;
            factor = factor * factor;
            factor = factor * factor;
            finalColor = mix(finalColor, mag_skyColor, (factor * WATER_SKY_REFLECTION_OPACITY + float(cosine < 0) * WATER_SKY_REFLECTION_START));
          }
        #endif
      #endif
    }
    #ifdef WATER_REFLECTION
      gl_FragData[3] = vec4(reflectCoord, 1);
    #endif
  #endif

  #ifdef FOG
    vec4 fogPosData = mix(mix(vec4(absPos, absDis), vec4(waterAbsPos, waterAbsDis),
      #if PARTICLE_FOG_FIX == 2
        float(comp.g > 0 && comp.g < 1 && waterDis > 0 && (particleDis == 0 || realabsdis < particleDis))
      #else
        float(comp.g > 0 && comp.g < 1 && waterDis > 0)
      #endif
    ), float(waterDis > 0) * vec4(waterAbsPos, waterAbsDis - absDis), isEyeInWater);
    float fogDisMul = fogPosData.a / far;
    if (fogDisMul > 1.4) {
      #ifdef WATER_REFLECTION
        gl_FragData[0] = vec4(finalColor, 1.0f);
        gl_FragData[4] = vec4(mag_fogColor, 1);
      #endif
      finalColor = mag_fogColor;
    }
    else {
      float current = min(min(fogPosData.a, 0.8f * far) * 0.012f * mag_fogStrength, 1);
      float factor = mix(clamp(pow(fogDisMul - 0.5, 1.5f) * mag_fogFarMul, 0, 1), 1, current);
      #ifdef WATER_REFLECTION
        gl_FragData[0] = vec4(finalColor, 1.0f);
        gl_FragData[4] = vec4(mag_fogColor, factor);
      #endif
      finalColor = mix(finalColor, mag_fogColor, factor);
    }
  #endif

  #if !defined FOG || !defined WATER_REFLECTION
    gl_FragData[0] = vec4(finalColor, 1.0f);
  #endif

  #ifdef BLOOM
    float bloomstrength = 0.07f;
    if (emissionChannel > 0.07f && emissionChannel < 0.7f) {
      if (type > 0.85f)
      	bloomstrength = 0.07f;
      else if (type > 0.15f && type < 0.85f) {
        float brightness = dot(color, vec3(0.299f, 0.587f, 0.114f));
        bloomstrength = step(0, brightness - 0.5f) * (brightness - 0.5f) * EMISSIVETORCH_BLOOM_FACTOR;
      }
      else if (type > 0)
        bloomstrength = EMISSIVEBLOCK_BLOOM_FACTOR;
    }
    gl_FragData[1] = vec4(bloomstrength * finalColor, 1);
  #endif

  #ifdef DOF
    float focus = centerDepthSmooth;
    float dofDis = max(0, (abs(depth - focus) - 0.003f) * DOF_STRENGTH);
    dofDis = dofDis / sqrt(0.1f + dofDis * dofDis);
  #endif
  #ifdef MOTION_BLUR
    vec4 previousPosition = vec4(absPos, 1);
    previousPosition.xyz -= previousCameraPosition;
    previousPosition = gbufferPreviousModelView * previousPosition;
    previousPosition = gbufferPreviousProjection * previousPosition;
    previousPosition /= previousPosition.w;
    vec2 velocity = (positionInNdcCoord - previousPosition).st;
    velocity = velocity / (1.0f + length(velocity)) * MOTION_BLUR_STRENGTH / frameTimeCounter;
    #ifdef DOF
      gl_FragData[5] = vec4(velocity, dofDis, !isHand);
    #else
      gl_FragData[5] = vec4(velocity, 0, !isHand);
    #endif
  #elif defined DOF
    gl_FragData[5] = vec4(0, 0, dofDis, !isHand);
  #endif

}
