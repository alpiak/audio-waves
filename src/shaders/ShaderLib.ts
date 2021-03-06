import * as THREE from "three";

import { UniformsLib } from "three/src/renderers/shaders/UniformsLib";
import { UniformsUtils } from "three/src/renderers/shaders/UniformsUtils";

import { background_frag, background_vert, grass_frag, grass_vert, meanfilter_frag, meanfilter_vert, water_frag,
    water_vert, waterbumpmap_frag, waterbumpmap_vert, waternormalmap_frag, waternormalmap_vert } from "./ShaderChunk";

interface IShaderLib {
    uniforms: object;
    vertexShader: string;
    fragmentShader: string;
    [propName: string]: any;
}

const waterShaderLib: IShaderLib = {
    uniforms: UniformsUtils.merge([
        UniformsLib.common,
        UniformsLib.specularmap,
        UniformsLib.envmap,
        UniformsLib.aomap,
        UniformsLib.lightmap,
        UniformsLib.emissivemap,
        UniformsLib.fog,
        UniformsLib.lights,
        {
            emissive: { value: new THREE.Color( 0x000000 ) },
        },
    ]),

    vertexShader: water_vert,

    fragmentShader: water_frag,
};

const waterNormalMapShaderLib: IShaderLib = {
  uniforms: { },

  vertexShader: waternormalmap_vert,

  fragmentShader: waternormalmap_frag,
};

const backgroundShaderLib: IShaderLib = {
    uniforms: UniformsUtils.merge([
        UniformsLib.common,
        UniformsLib.specularmap,
        UniformsLib.envmap,
        UniformsLib.aomap,
        UniformsLib.lightmap,
        UniformsLib.fog,
    ]),

    vertexShader: background_vert,

    fragmentShader: background_frag,
};

const grassShaderLib: IShaderLib = {
    uniforms: UniformsUtils.merge([
        UniformsLib.common,
        UniformsLib.specularmap,
        UniformsLib.envmap,
        UniformsLib.aomap,
        UniformsLib.lightmap,
        UniformsLib.emissivemap,
        UniformsLib.bumpmap,
        UniformsLib.normalmap,
        UniformsLib.displacementmap,
        UniformsLib.gradientmap,
        UniformsLib.fog,
        UniformsLib.lights,
        {
            emissive: { value: new THREE.Color(0x000000) },
            shininess: { value: 30 },
            specular: { value: new THREE.Color(0x111111) },
        },
    ]),

    vertexShader: grass_vert,

    fragmentShader: grass_frag,
};

const waterBumpMapShaderLib: IShaderLib = {
    uniforms: { },

    vertexShader: waterbumpmap_vert,

    fragmentShader: waterbumpmap_frag,
};

const meanFilterShaderLib: IShaderLib = {
    uniforms: {
        tDiffuse: { type: "t", value: null },
    },

    vertexShader: meanfilter_vert,

    fragmentShader: meanfilter_frag,
};

export { backgroundShaderLib, grassShaderLib, meanFilterShaderLib, waterBumpMapShaderLib, waterNormalMapShaderLib,
    waterShaderLib };
