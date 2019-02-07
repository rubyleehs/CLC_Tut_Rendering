// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Textured With Detail"
{
	Properties
	{
		_Tint ("Tint", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" 

        //Grayscale detail textures will adjust the original color strictly by brightening and darkening it. alpha = 0.5
        _DetailTex ("Detail Texture", 2D) = "gray" {}
	}


	SubShader
	{
		Pass
		{
			CGPROGRAM

			//pragma tell it which programs to use
			#pragma vertex MyVertexProgram
			#pragma fragment MyFragmentProgram

			//add files from(similar to inherit from)
			#include "UnityCG.cginc"

			float4 _Tint;
			sampler2D _MainTex, _DetailTex;

			//ST stand for scale and translation. now unity uses Tiling and Offset but coz backwards compatibility it stays the same
			//adding [textureName]_ST will make the tiling/offset info to be passed to that var. It has to be a f4;
			float4 _MainTex_ST, _DetailTex_ST;


			//typical structure, notice the semicolon at the end.
			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv: TEXCOORD0;
                float2 uvDetail: TEXCOORD1;
			};

			struct VertexData
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};

			//f4 because 4x4 matrix
			//:SV_POSITION is a semantic that tells it what to do with the returned results
			//imagine semantics just like another class that have the sme data format as a similar f/bool/stirng; 
		    //SV stans for system value, SV_POSITION for the final vertex position in shader
			//POSITION is the object space of the object as homogeneous coords in the form of a f4 (x,y,z,1)
			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;

				//mul = matrix multiplication
				//UNITY_MATRIX_MVP is a matrix that combines the object's transform hierarchy with the camera transformation and projection
				i.position = UnityObjectToClipPos(v.position);


				//Same as i.uv = TRANSFORM_TEX(v.uv, _MainTex);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                i.uvDetail = v.uv * _DetailTex_ST.xy + _DetailTex_ST.zw;

				return i;
			}

			//f4 because frag program is supposed to output an RGBA value for 1 pixel
			//takes in a position from SV_POSITION and out put the required pixel color
			//TEXCOORD0 is actually a generic semantic for everything that's interpolated, in this case interpolating between vertices
			//notice how position and local position is being passed to by MyVertexProgram();
			//the vertex output should match the fragment input 
			float4 MyFragmentProgram(Interpolators i) : SV_TARGET
			{
				float4 color =  tex2D(_MainTex, i.uv) * _Tint;
                
                //unity_ColorSpaceDouble is = 2 if rendering in gamma space colors and = ~4.59 is rendering in linear space colors. Google pls
				color *= tex2D(_MainTex, i.uvDetail) * unity_ColorSpaceDouble; 
				return color;
			}



			ENDCG
		}
	}
}