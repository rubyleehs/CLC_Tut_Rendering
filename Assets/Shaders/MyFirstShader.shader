// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/MyFirstShader"
{

	//Similar to a class where you store all the variables
	Properties
	{
		//_Tint is the var name, it could be anything. naming convention is like dat coz nothing else uses it/no confusion
		//followed by string, which is used to label the properth in the material inspector
		//and Color, the type
		// = (value) is default value similar to how we can do = something when declaring public vars
		//
		_Tint ("Tint", Color) = (1,1,1,1)
		_MainTex ("Texture", 2D) = "white" 


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
			sampler2D _MainTex;

			//ST stand for scale and translation. now unity uses Tiling and Offset but coz backwards compatibility it satys the same
			//adding [textureName]_ST will make the tiling/offset info to be passed to that var. It has to be a f4;
			float4 _MainTex_ST;


			//typical structure, notice the semicolon at the end.
			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv: TEXCOORD0;
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


				//Same as i.uv = TRANSFORM_TEX(v.uv, _MaiTex);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

				return i;
			}

			//f4 because frag program is supposed to output an RGBA value for 1 pixel
			//takes in a position from SV_POSITION and out put the required pixel color
			//TEXCOORD0 is actually a generic semantic for everything that's interpolated, in this case interpolating between vertices
			//notice how position and local position is being passed to by MyVertexProgram();
			//the vertex output should match the fragment input 
			float4 MyFragmentProgram(Interpolators i) : SV_TARGET
			{
				return tex2D(_MainTex, i.uv) * _Tint;
			}



			ENDCG
		}
	}
}
