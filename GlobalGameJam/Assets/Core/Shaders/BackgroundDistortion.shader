Shader "FXs/Particle/Background Distortion"
{
	Properties
	{
		[HideInInspector][PerRendererData] _Color ("Color", Color) = (1,1,1,1)
		[HideInInspector][NoScaleOffset] _MainTex("Distortion Texture", 2D) = "white" {}
		[Toggle(_DEBUG)] _Debug ("Debug Texture Visualization", Float) = 0.0
	}

	Category
	{
        Tags 
        { 
			"RenderType" = "Transparent"
			"Queue" = "Transparent+100"
			"IgnoreProjector" = "True"
        }

		SubShader
		{
			Blend SrcAlpha OneMinusSrcAlpha
            Cull Off
			ZWrite Off
			ZTest Always
			Lighting Off

			GrabPass
        	{
            	"_CameraColorTexture"
        	}

			Pass
			{
				HLSLPROGRAM
				#pragma shader_feature_local _ _DEBUG

				#include "UnityCG.cginc"

				#pragma vertex vert
				#pragma fragment frag

				struct ParticleVertexInput
				{
					float4 vertex : POSITION;
					half4 color : COLOR;
					float2 texcoord : TEXCOORD0;
				};

				struct ParticleVertexOutput
				{
					float4 pos : SV_POSITION;
					float4 texcoord : TEXCOORD0;
					half4 color : COLOR;
				};
				
				
				half4 _Color;
				
				ParticleVertexOutput vert(ParticleVertexInput v)
				{
					ParticleVertexOutput o = (ParticleVertexOutput)0;

					o.pos = UnityObjectToClipPos(v.vertex.xyz);
					o.texcoord.xy = v.texcoord.xy;

					half4 screenPos = ComputeScreenPos(o.pos);
                    screenPos.xy/=screenPos.w;

					o.texcoord.zw = screenPos.xy;
					o.color = v.color * _Color;
					o.color.xy = o.color.xy - 0.5;
					o.color.xy *= 0.5;
					o.color.xy *= v.color.z;

					return o;
				}
				

				sampler2D _MainTex;
				sampler2D _CameraColorTexture;

				half4 frag(ParticleVertexOutput i) : SV_Target
				{
					
					half4 distortionTex = tex2D(_MainTex, i.texcoord.xy);

					half4 col = 1.0;
					col.a = distortionTex.a * i.color.a;

					float3 distortion = distortionTex.xyz * 2.0 - 1.0;
					distortion.xy *= i.color.xy;

                    half4 refracted = tex2D(_CameraColorTexture,i.texcoord.zw + distortion.xy);//SAMPLE_TEXTURE2D(_CameraColorTexture, _CameraColorTexture, i.texcoord.zw + distortion.xy);
                    col.xyz = refracted.xyz;

					#ifdef _DEBUG
						col.xyz = distortionTex.xyz;
					#endif
					
					return col;

				}

				ENDHLSL
			}


		}
	}
}
