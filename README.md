# SS\_SubstancePainter\_CustomShader

# Version: 1.0

## Custom Shader for Character Customization

To improve our character customization and texture-production workflow, I developed a custom GLSL shader for Adobe Substance 3D Painter. The goal was to allow artists to **preview and adjust customizable materials directly inside Substance Painter**, without repeatedly exporting textures to Unity, testing the result, and going back to make corrections.

The idea was inspired by Alena Dubrovina’s GDC talk, *The Art and Technology Behind Creating Characters for Baldur’s Gate 3*, where she presented Larian Studios’ approach to character customization. I adapted the concept to fit our own production pipeline, where a similar technique could be applied to character clothing, props, and environments.

I used Adobe Substance 3D Painter’s shader library and Shader API as references. Since there is relatively little documentation and few tutorials on developing custom Substance Painter shaders, I started by studying the structure of Painter’s default PBR shader and built my own functionality into it.

One of the main technical challenges was developing a system that could identify and replace specific colors within a texture. I created a custom function that separates the source and target colors into their individual RGB channels, converts each channel into a 0–1 range, and compares the values to determine how closely the colors match. The resulting values are then combined to generate a mask that controls the material customization.

Another challenge was adapting to Substance Painter’s shader-specific syntax, which differs from standard GLSL and required me to learn how Painter handles shader inputs, functions, and material data.

The final shader allows artists to **visualize the customized material while working on the textures**, eliminating the need to constantly export maps to Unity and iterate between the two applications. This makes the workflow faster, reduces repetitive testing, and gives artists more immediate visual feedback when creating customizable assets.


# **Usage guideline:** 

* ## How to assign a colour mask?

  * Go to your **texture set setting**, under channels make sure your **user0** is set to ColourMask, if not double-click to change the name.  
  * Under Layers, change Base Color to ColourMask (click on the left-most arrow)  
  * Create a fill layer, disable every channel except ColourMask (colour)   
  *<img width="368" height="317" alt="R1_1" src="https://github.com/user-attachments/assets/c4117bd2-6a67-4bb1-bd7a-ef9b91e064f2" />
  *<img width="363" height="493" alt="R1_2" src="https://github.com/user-attachments/assets/68d7cc9b-d758-48bc-9d4c-2f99fba31697" />
  * Choose a color from the shader setting (make sure the color is the default color, if not click restore default) or use this table

| Fabric\_Primary  FFBC00 |
| :---: |
| Fabric\_Secondary FF0000 |
| Fabric\_Teriary FFBCBC |
| Leather\_Primary BC00FF |
| Leather\_Secondary 0000FF |
| Leather\_Teriary BCBCFF |
| Metal\_Primary 00FFBC |
| Metal\_Secondary 00FF00 |
| Matal\_Teriary BCFFBC |
| Custom\_1 00BCFF |
| Custom\_2 9C9C00 |

  * Use a mask to assign the color to your model  
  * Reminder:   
    * Make sure the color is **100% solid** and as precise as possible\! Lighter or smoothing colours don’t work with the shader. You will not be able to control the corresponding color using the shader(another color takes control over it). If this still happens, try increasing or decreasing the Tolerance a little bit using the slider.

* ## How to install custom shader?

  * Put the shader file to Documents\\Adobe\\Adobe Substance 3D Painter\\assets\\shaders  
  * Restart SP  
  * Under shader settings select custom shader  
  * <img width="376" height="147" alt="R2_1" src="https://github.com/user-attachments/assets/5e537f7c-baab-4fe8-b98e-d5c6d3fed7f0" />


* ## What should the base color look like?

  * When using this technique, the base color will look very light, it only needs a little bit of color with black and white  
  * <img width="1307" height="720" alt="R3_1" src="https://github.com/user-attachments/assets/b5cfad00-960e-499a-b9d8-b0e347d4c614" />
  * <img width="1304" height="713" alt="R3_2" src="https://github.com/user-attachments/assets/0d1f155d-6aa3-4a98-afa6-8e804cb50a53" />

    

# Result

Custom color picker and slider  
<img width="1485" height="1002" alt="Result" src="https://github.com/user-attachments/assets/1d04e016-51a4-4d9a-9c90-29eb188b4b44" />


# Links

[https://helpx.adobe.com/substance-3d-painter/scripting-and-development/api-reference/shader-api/parameters-shader-api/all-custom-params-shader-api.html](https://helpx.adobe.com/substance-3d-painter/scripting-and-development/api-reference/shader-api/parameters-shader-api/all-custom-params-shader-api.html)  

