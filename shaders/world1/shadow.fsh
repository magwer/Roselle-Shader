#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;

/* DRAWBUFFERS:0 */

const float shadowDistance = 90; // [32 64 90 128 192 256 384 512]
const float shadowDistanceRenderMul = 1.0f;
const bool 	shadowHardwareFiltering0 = true;
const bool 	shadowHardwareFiltering1 = true;

varying vec3 texcoord;
uniform sampler2D texture;
uniform int blockEntityId;

#define ENTITY_BEAM 10089


void main() {
	gl_FragData[0] = mix(texture2D(texture, texcoord.xy) * texcoord.z, vec4(0), float(blockEntityId == ENTITY_BEAM));
}
