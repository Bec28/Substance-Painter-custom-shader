# SS\_SubstancePainter\_CustomShader

# Version: 1.0

# Task content

Make a custom shader to better adapt the customization workflow.

# **Idea**

I used Adobe Substance Painter’s [shader library and shader API](https://helpx.adobe.com/substance-3d-painter/scripting-and-development/api-reference/shader-api.html) as my guide, wrote the shader with GLSL with some special functions, and a GDC talk inspired my idea: [The art and technology behind creating characters for Baldur's Gate 3](https://youtu.be/CVa4HJzHb_o?t=845). Inside the talk, Alena Dubrovina showed their approach to a customization system. This technique is useful in the texture production pipeline for some of our character clothes, props, and environments. 

**The custom shader allows 3d artists to visualize the final result and make changes at the same time without having to export maps into Unity back and forth, which saves hell lots of time and improves the performance.**

**Process**: I started not knowing anything about shading language, with not a lot of tutorials about creating SP shader the only resource is its own shader, I used the structure of its default PBR shader and added my code within it.   
The hardest process is to figure out the logic behind it, and how the shader compares the color of two different textures — I eventually found that creating a function: splitting both textures into separate RGB (red, green, blue) channels and making it a float from 0-1, then comparing it then add three results together.  
The second hardest is using SP’s syntax, they are different from ordinary GLSL and it can be confusing sometimes.

# **Usage guideline:** 

* ## How to assign a colour mask?

  * Go to your **texture set setting**, under channels make sure your **user0** is set to ColourMask, if not double-click to change the name.  
  * Under Layers ![][image1] change Base Color to ColourMask (click on the left-most arrow)  
  * Create a fill layer, disable every channel except ColourMask (colour)   
  * ![][image2]![][image3]  
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
  * ![][image4]

* ## What should the base color look like?

  * When using this technique, the base color will look very light, it only needs a little bit of color with black and white  
  * ![][image5]![][image6]  
    

# Result

Custom color picker and slider  
![][image7]

# Links

[https://helpx.adobe.com/substance-3d-painter/scripting-and-development/api-reference/shader-api/parameters-shader-api/all-custom-params-shader-api.html](https://helpx.adobe.com/substance-3d-painter/scripting-and-development/api-reference/shader-api/parameters-shader-api/all-custom-params-shader-api.html)  

