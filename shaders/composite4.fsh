#version 120

const int RGBA = 0;
const int RGBA16 = 1;
const int gcolorFormat = RGBA16;

/* DRAWBUFFERS:0 */

uniform sampler2D gcolor;
varying vec2 texcoord;

uniform sampler2D gaux2;
uniform float viewHeight;

void main() {

  vec3 color = texture2D(gcolor, texcoord).rgb;

  vec4 velocity = texture2D(gaux2, texcoord);
  float dofDis =  velocity.b;
  vec3 dcolor = vec3(0);
  for (int i = -5; i < 6; i++)
    dcolor += texture2D(gcolor, texcoord + vec2(0, i / viewHeight)).rgb;
  color = mix(color, dcolor / 11, velocity.a * dofDis);
  gl_FragData[0] = vec4(color, 1);
}
