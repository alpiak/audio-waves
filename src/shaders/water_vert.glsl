varying vec3 vLightFront;

#ifdef DOUBLE_SIDED

    varying vec3 vLightBack;

#endif

#include <common>
#include <uv_pars_vertex>
#include <uv2_pars_vertex>
#include <envmap_pars_vertex>
#include <bsdfs>
#include <lights_pars_begin>
#include <color_pars_vertex>
#include <fog_pars_vertex>
#include <morphtarget_pars_vertex>
#include <skinning_pars_vertex>
#include <shadowmap_pars_vertex>
#include <logdepthbuf_pars_vertex>
#include <clipping_planes_pars_vertex>

void main() {

    #include <uv_vertex>
    #include <uv2_vertex>
    #include <color_vertex>

    float absPositionX = position.x > 0.0 ? position.x : - position.x;
    float offsetY = absPositionX - float(int(absPositionX / 20.0) * 20);

    vec3 objectNormal = vec3(offsetY > 0.0 ? 1 : -1 , normal.yz);

    #include <morphnormal_vertex>
    #include <skinbase_vertex>
    #include <skinnormal_vertex>
    #include <defaultnormal_vertex>

    vec3 transformed = vec3(position.x, position.y + offsetY, position.z);

    #include <morphtarget_vertex>
    #include <skinning_vertex>
    #include <project_vertex>
    #include <logdepthbuf_vertex>
    #include <clipping_planes_vertex>

    #include <worldpos_vertex>
    #include <envmap_vertex>
    #include <lights_lambert_vertex>
    #include <shadowmap_vertex>
    #include <fog_vertex>
}
