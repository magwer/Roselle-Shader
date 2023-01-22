#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;
const int gdepthFormat = RGBA;
const int gnormalFormat = RGBA16;

/* DRAWBUFFERS:012 */

uniform sampler2D texture;
varying vec2 texcoord;
varying vec4 lmcoord;
uniform vec4 entityColor;

varying vec3 mag_normal;
varying vec4 mag_color;

void main() {

  if (lmcoord.s > 255)
    return;

  float magAlpha = mag_color.a;
  bool tag1 = magAlpha > 0.125f && magAlpha < 0.1255f;
  bool tag2 = magAlpha > 0.247f && magAlpha < 0.248f;
  if (tag1 || tag2) {
    gl_FragData[0] = vec4(0, 0, 0, mix(0, 0.2f, float(tag2)));
    gl_FragData[1] = vec4(0, 0, 0, 1);
  }
  else {
    vec4 texColor = texture2D(texture, texcoord.st);
		vec4 finalColor = mix(texColor * mag_color, vec4(entityColor.rgb, entityColor.a), entityColor.a);
    gl_FragData[0] = finalColor;
    gl_FragData[1] = vec4(lmcoord.st / 240.0f, 0.5, 1);
  }
  gl_FragData[2] = vec4(mag_normal * 0.5f + 0.5f, 1);
}
