Shader "Custom/MyFirstLightingShader"
{

	//Similar to a class where you store all the variables
	Properties
	{
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
                float3 normal : NORMAL;
				float2 uv: TEXCOORD0;
			};

			struct VertexData
			{
				float4 position : POSITION;
                float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
			};

			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;

				i.position = UnityObjectToClipPos(v.position);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;

                //unity_ObjectToWorld is a 4x4 Matrix to do just that
                //1st 3 rows are used for scale and rotation. 4th is translation.
                //no need 4th row in this case coz normals no translation;
                //trasposing a matrix will invert scale but not rotation.
                //i.normal = mul(transpose((float3x3)unity_WorldToObject),v.normal);
                i.normal = UnityObjectToWorldNormal(v.normal);

                //removing effects from scaling
                i.normal = normalize(i.normal);

				return i;
			}

			float4 MyFragmentProgram(Interpolators i) : SV_TARGET
			{
				//return tex2D(_MainTex, i.uv) * _Tint;

                //renormalized coz func will linearlly interpolate between points, so for normals wornt always give a unit length v
                i.normal = normalize(i.normal);
                return float4(i.normal * 0.5 + 0.5, 1);
			}



			ENDCG
		}
	}
}
