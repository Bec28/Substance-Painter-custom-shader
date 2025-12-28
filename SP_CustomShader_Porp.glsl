//- ==================================================
//- SpiritSalvation_CustomShader_Porps
//- ==================================================
//-
//- Import from libraries.

import lib-vectors.glsl
import lib-pbr.glsl
import lib-bent-normal.glsl
import lib-emissive.glsl
import lib-pom.glsl
import lib-sss.glsl
import lib-utils.glsl
import lib-alpha.glsl


//- Declare the iray mdl material to use with this shader.
//: metadata {
//:   "mdl":"mdl::alg::materials::skin_metallic_roughness::skin_metallic_roughness"
//: }

//: state cull_face off

//: state blend over

//- Channels needed for metal/rough workflow are bound here.
//: param auto channel_basecolor
uniform SamplerSparse basecolor_tex;
//: param auto channel_roughness
uniform SamplerSparse roughness_tex;
//: param auto channel_metallic
uniform SamplerSparse metallic_tex;
//: param auto channel_specularlevel
uniform SamplerSparse specularlevel_tex;
//: param auto channel_user0
uniform SamplerSparse ColorMSK_tex;
//: param auto channel_user1
uniform SamplerSparse MRA_tex; //Metallic Roughness Alpha
//: param auto channel_user2
uniform SamplerSparse targetColor_tex;


//-------- Color Selection ----------------------------------------------------//
//: param custom { "default": [1.0,0.503,0.0], "label": "Fabric_Primary", "widget":"color"}
uniform vec3 Fabric_Primary;

//: param custom { "default": [1.0, 0.0, 0.0], "label": "Fabric_Secondary", "widget":"color"}
uniform vec3 Fabric_Secondary;

//: param custom { "default": [1.0,0.503,0.503], "label": "Fabric_Teriary", "widget":"color"}
uniform vec3 Fabric_Tertiary;

//: param custom { "default": [0.503,0.0,1.0], "label": "Wood_Primary", "widget":"color"}
uniform vec3 Wood_Primary;

//: param custom { "default": [0.0,0.0,1.0], "label": "Wood_Secondary", "widget":"color"}
uniform vec3 Wood_Secondary;

//: param custom { "default": [0.503,0.503,1.0], "label": "Wood_Tertiary", "widget":"color"}
uniform vec3 Wood_Tertiary;

//: param custom { "default": [0.0,1.0,0.503], "label": "Metal_Primary", "widget":"color"}
uniform vec3 Metal_Primary;

//: param custom { "default": [0.0,1.0,0.0], "label": "Metal_Secondary", "widget":"color"}
uniform vec3 Metal_Secondary;

//: param custom { "default": [0.503,1.0,0.503], "label": "Metal_Teriary", "widget":"color"}
uniform vec3 Metal_Tertiary;

//: param custom { "default": [0.0,0.503,1.0], "label": "Custom_1", "widget":"color"}
uniform vec3 Custom_1;

//: param custom { "default": [0.3333, 0.333, 0.0], "label": "Custom_2", "widget":"color"}
uniform vec3 Custom_2;


//-------- Tolerance ----------------------------------------------------//
//: param custom {
//:   "default": 0.350,
//:   "min": 0.0,
//:   "max": 1.0,
//:   "label": "Tolerance"
//: }
uniform float Tolerance;



//Target Colour
vec3 Fabric_Primary_TG = vec3(1,0.503,0);
vec3 Fabric_Secondary_TG = vec3(1.0, 0.0, 0.0);
vec3 Fabric_Tertiary_TG = vec3 (1,0.503,0.503);
vec3 Wood_Primary_TG = vec3 (0.503,0,1);
vec3 Wood_Secondary_TG = vec3 (0,0,1);
vec3 Wood_Tertiary_TG = vec3 (0.503,0.503,1);
vec3 Metal_Primary_TG = vec3 (0,1,0.503);
vec3 Metal_Secondary_TG = vec3 (0,1,0);
vec3 Metal_Tertiary_TG = vec3 (0.503,1,0.503);
vec3 Custom_1_TG = vec3 (0,0.503,1);
vec3 Custom_2_TG = vec3(0.3333, 0.333, 0);

// Function to compare each channel of a target color with the corresponding ColourMask channel
float compareColors(vec3 targetColor, vec3 ColourMaskF, float tolerance_Default) 
{

    //Exreact RGB channels from the target color
   float R_target = targetColor.r;
    float G_target = targetColor.g;
    float B_target = targetColor.b;

   // Extract the channels from the ColourMask
   float R_ColourMask = ColourMaskF.r;
    float G_ColourMask = ColourMaskF.g;
    float B_ColourMask = ColourMaskF.b;

   //Set the tolerance
    tolerance_Default *= 1;

   //Compare each channel with the corresponding ColourMask channel
   //If the target equal or smaller than the tolerance return 1 else 0
   float R_compare = abs(R_target - R_ColourMask) <= tolerance_Default ? 1.0 : 0.0;
    float G_compare = abs(G_target - G_ColourMask) <= tolerance_Default ? 1.0 : 0.0;
    float B_compare = abs(B_target - B_ColourMask) <= tolerance_Default ? 1.0 : 0.0;

   //Sum the results
   float result = R_compare + G_compare + B_compare;

   // Return 1 if the result is greater than 2.980, else return 0}
   return result > 2.980 ? 1.0 : 0.0;
}

//- Shader entry point
void shade(V2F inputs)
{

  vec3 ColourMask = textureSparse(ColorMSK_tex, inputs.sparse_coord).rgb; //generate a rgb texture from colormask channel
  vec3 targetColor = textureSparse(targetColor_tex, inputs.sparse_coord).rgb;

  // Apply parallax occlusion mapping if possible
  vec3 viewTS = worldSpaceToTangentSpace(getEyeVec(inputs.position), inputs);
  applyParallaxOffset(inputs, viewTS);

    // Perform the comparison for each target color
  float Fabric_Primary_Match = compareColors(Fabric_Primary_TG, ColourMask, Tolerance);
  float Fabric_Secondary_Match = compareColors(Fabric_Secondary_TG, ColourMask, Tolerance);
  float Fabric_Tertiary_Match = compareColors(Fabric_Tertiary_TG, ColourMask, Tolerance);
  float Wood_Primary_Match = compareColors(Wood_Primary_TG, ColourMask, Tolerance);
  float Wood_Secondary_Match = compareColors(Wood_Secondary_TG, ColourMask, Tolerance);
  float Wood_Tertiary_Match = compareColors(Wood_Tertiary_TG, ColourMask, Tolerance);
  float Metal_Primary_Match = compareColors(Metal_Primary_TG, ColourMask, Tolerance);
  float Metal_Secondary_Match = compareColors(Metal_Secondary_TG, ColourMask, Tolerance);
  float Metal_Tertiary_Match = compareColors(Metal_Tertiary_TG, ColourMask, Tolerance);
  float Custom_1_Match = compareColors(Custom_1_TG, ColourMask, Tolerance);
  float Custom_2_Match = compareColors(Custom_2_TG, ColourMask, Tolerance);

  // Start with white color
  vec3 mixedColor = mix(vec3(1.0, 1.0, 1.0), Fabric_Primary, Fabric_Primary_Match);

  // Sequentially mix each subsequent color using its match factor
  mixedColor = mix(mixedColor, Fabric_Secondary, Fabric_Secondary_Match);
  mixedColor = mix(mixedColor, Fabric_Tertiary, Fabric_Tertiary_Match);
  mixedColor = mix(mixedColor, Wood_Primary, Wood_Primary_Match);
  mixedColor = mix(mixedColor, Wood_Secondary, Wood_Secondary_Match);
  mixedColor = mix(mixedColor, Wood_Tertiary, Wood_Tertiary_Match);
  mixedColor = mix(mixedColor, Metal_Primary, Metal_Primary_Match);
  mixedColor = mix(mixedColor, Metal_Secondary, Metal_Secondary_Match);
  mixedColor = mix(mixedColor, Metal_Tertiary, Metal_Tertiary_Match);
  mixedColor = mix(mixedColor, Custom_1, Custom_1_Match);
  mixedColor = mix(mixedColor, Custom_2, Custom_2_Match);

  // Fetch material parameters, and conversion to the specular/roughness model
  float roughness = getRoughness(roughness_tex, inputs.sparse_coord);
  vec3 baseColor = getBaseColor(basecolor_tex, inputs.sparse_coord);
  float metallic = getMetallic(metallic_tex, inputs.sparse_coord);
  float specularLevel = getSpecularLevel(specularlevel_tex, inputs.sparse_coord);
  vec3 diffColor = generateDiffuseColor((mixedColor * baseColor), metallic); //basecolor multiply by colormask's color
  vec3 specColor = generateSpecularColor(specularLevel, (mixedColor * baseColor), metallic);


  // Get detail (ambient occlusion) and global (shadow) occlusion factors
  // separately in order to blend the bent normals properly
  float shadowFactor = getShadowFactor();
  float occlusion = getAO(inputs.sparse_coord, true, use_bent_normal);
  float specOcclusion = specularOcclusionCorrection(
    use_bent_normal ? shadowFactor : occlusion * shadowFactor,
    metallic,
    roughness);

  LocalVectors vectors = computeLocalFrame(inputs);
  computeBentNormal(vectors,inputs);

  //vec3 debug = vec3(Metal_Primary_Match, Custom_2_Match, 0.0); //used for debug

    // Discard current fragment on the basis of the opacity channel
  // and a user defined threshold
  alphaKill(inputs.sparse_coord);

  // Feed parameters for a physically based BRDF integration
  alphaOutput(getOpacity(opacity_tex, inputs.sparse_coord));
  emissiveColorOutput(pbrComputeEmissive(emissive_tex, inputs.sparse_coord));
  albedoOutput(diffColor); //basecolor multiply by colormask's color
  diffuseShadingOutput(occlusion * shadowFactor * envIrradiance(getDiffuseBentNormal(vectors)));
  specularShadingOutput(specOcclusion * pbrComputeSpecular(vectors, specColor, roughness, occlusion, getBentNormalSpecularAmount()));
  sssCoefficientsOutput(getSSSCoefficients(inputs.sparse_coord));
  sssColorOutput(getSSSColor(inputs.sparse_coord));
}