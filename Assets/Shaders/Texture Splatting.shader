Shader "Custom/Texture Splatting"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" 
        [NoScaleOffset] _Texture1 ("Texture1", 2D) = "white"
        [NoScaleOffset] _Texture2 ("Texture2", 2D) = "white"
        [NoScaleOffset] _Texture3 ("Texture1", 2D) = "white"
        [NoScaleOffset] _Texture4 ("Texture2", 2D) = "white"
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

			sampler2D _MainTex;
			float4 _MainTex_ST;

            //No need for _ST component coz we arent gonna use it's offset
            sampler2D _Texture1, _Texture2, _Texture3, _Texture4;

			//typical structure, notice the semicolon at the end.
			struct Interpolators
			{
				float4 position : SV_POSITION;
				float2 uv: TEXCOORD0;
                float2 uvSplat: TEXCOORD1;
			};

			struct VertexData
			{
				float4 position : POSITION;
				float2 uv : TEXCOORD0;
			};


			Interpolators MyVertexProgram(VertexData v)
			{
				Interpolators i;
				i.position = UnityObjectToClipPos(v.position);
				i.uv = v.uv * _MainTex_ST.xy + _MainTex_ST.zw;
                i.uvSplat = v.uv;

				return i;
			}

			float4 MyFragmentProgram(Interpolators i) : SV_TARGET
			{
                float4 splat = tex2D(_MainTex, i.uvSplat);
				return 
                    tex2D(_Texture1, i.uv) * splat.r +
                    tex2D(_Texture2, i.uv) * splat.g +
                    tex2D(_Texture3, i.uv) * splat.b +
                    tex2D(_Texture4, i.uv) * (1 - splat.r - splat.g - splat.b);
			}



			ENDCG
		}
	}
}

