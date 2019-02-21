#define USE_MAP

uniform vec3 diffuse;
uniform vec3 emissive;
uniform float opacity;
uniform vec3 waterColor;

varying vec3 vLightFront;

#ifdef DOUBLE_SIDED

	varying vec3 vLightBack;

#endif

varying float fresnelFactor;

#include <common>
#include <packing>
#include <dithering_pars_fragment>
#include <color_pars_fragment>
//#include <uv_pars_fragment>

#if defined( USE_MAP ) || defined( USE_BUMPMAP ) || defined( USE_NORMALMAP ) || defined( USE_SPECULARMAP ) || defined( USE_ALPHAMAP ) || defined( USE_EMISSIVEMAP ) || defined( USE_ROUGHNESSMAP ) || defined( USE_METALNESSMAP )

	varying vec4 vUv;

#endif

#include <uv2_pars_fragment>
#include <map_pars_fragment>
#include <alphamap_pars_fragment>
#include <aomap_pars_fragment>
#include <lightmap_pars_fragment>
#include <emissivemap_pars_fragment>
#include <envmap_pars_fragment>
#include <bsdfs>
#include <lights_pars_begin>
#include <fog_pars_fragment>
#include <shadowmap_pars_fragment>
#include <shadowmask_pars_fragment>
#include <specularmap_pars_fragment>
#include <logdepthbuf_pars_fragment>
#include <clipping_planes_pars_fragment>

const float reflectRate = 0.98;

void main() {
	#include <clipping_planes_fragment>

	vec4 diffuseColor = vec4(diffuse, opacity);
	ReflectedLight reflectedLight = ReflectedLight(vec3(0.0), vec3(0.0), vec3(0.0), vec3(0.0));
	vec3 totalEmissiveRadiance = emissive;

	#include <logdepthbuf_fragment>
//	#include <map_fragment>

    #ifdef USE_MAP

    	vec4 texelColor = texture2DProj(map, vUv) * fresnelFactor + vec4(waterColor, 1.0) * (1.0 - fresnelFactor);

    	texelColor = mapTexelToLinear(texelColor);

    #endif

	#include <color_fragment>
	#include <alphamap_fragment>
	#include <alphatest_fragment>
	#include <specularmap_fragment>
	#include <emissivemap_fragment>

	// accumulation
	reflectedLight.indirectDiffuse = getAmbientLightIrradiance(ambientLightColor);

	#include <lightmap_fragment>

	reflectedLight.indirectDiffuse *= BRDF_Diffuse_Lambert(diffuseColor.rgb);

	#ifdef DOUBLE_SIDED

		reflectedLight.directDiffuse = (gl_FrontFacing) ? vLightFront : vLightBack;

	#else

		reflectedLight.directDiffuse = vLightFront;

	#endif

	reflectedLight.directDiffuse *= BRDF_Diffuse_Lambert( diffuseColor.rgb ) * getShadowMask();

	// modulation
	#include <aomap_fragment>

	vec3 outgoingLight = reflectedLight.directDiffuse + reflectedLight.indirectDiffuse + totalEmissiveRadiance;

	#include <envmap_fragment>

	gl_FragColor = vec4(outgoingLight * (1.0 - reflectRate) + texelColor.rgb * reflectRate, diffuseColor.a);

	#include <tonemapping_fragment>
	#include <encodings_fragment>
	#include <fog_fragment>
	#include <premultiplied_alpha_fragment>
	#include <dithering_fragment>
}
