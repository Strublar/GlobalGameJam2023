// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

Shader "Unlit/BlendAdd"
{
	Properties
	{
		[Header(Main Map)]
		_MainTex ("Texture", 2D) = "white" {}
		_Color1 ("Start Color", Color) = (1,1,1,1)
		_Color2 ("End Color", Color) = (1,1,1,1)
		[MaterialToggle] _UseAlphaChannel ("Use Alpha Channel as Blending map", Float) = 0
		[MaterialToggle] _isAdditiveOnly ("Is Additive Only ?", Float) = 0
		[MaterialToggle] _isBlendedOnly ("Is Alpha Blended Only ?", Float) = 0
		[MaterialToggle] _isPremultiplied ("Premultiply Alpha", Float) = 0
		_Glow ("Glow", Float) = 1
		_U_Speed ("U speed", Range(-10,10)) = 0
		_V_Speed ("V speed", Range(-10,10)) = 0
		[MaterialToggle] _MainmapUseCustomVertexStreams ("Use Custom Vertex Streams", Float) = 0


		[Space(20)]
		[Header(Secondary Map)]
		[MaterialToggle] _HasSecondaryMap("Activate Effect", Float) = 0
		_SecondaryColor1("Start Color", Color) = (1,1,1,1)
		_SecondaryColor2("End Color", Color) = (1,1,1,1)
		_SecondaryTex("Secondary Texture", 2D) = "white"{}
		_U_Speed2 ("U speed", Range(-10,10)) = 0
		_V_Speed2 ("V speed", Range(-10,10)) = 0
		[MaterialToggle] _SmapUseCustomVertexStreams ("Use Custom Vertex Streams", Float) = 0
		[MaterialToggle] _IsEmissive("Emissive ?", Float) = 0
		_NoisePower ("Power", Range(0,2)) = 1

		[Space(20)]
		[Header(Masking Map)]
		[MaterialToggle] _HasAlphaMask("Activate Effect", Float) = 0
		_MaskTex("Mask Texture", 2D) = "white"{}
		_MaskPower("Power", Range(0,10)) = 1


		[Space(20)]
		[Header(Erosion Effect)]
		[MaterialToggle] _HasAlphaErosion ("Activate Effect", Float) = 0
		[MaterialToggle] _ErosionUseCustomVertexStreams ("Use Custom Vertex Streams", Float) = 0
		_ErosionTex ("Erosion Map", 2D) = "white" {}
		_ErosionSpeed ("Erosion Speed", Range(0,2)) = 0
		_ErosionSubColor1 ("Start Erosion Color", Color) = (1,1,1,1)
		_ErosionSubColor2 ("End Erosion Color", Color) = (1,1,1,1)
		_ErosionSmoothness ("Smoothness", Range(0,10)) = 1
		//_ErosionThickness ("Line Thickness", Range(0,1)) = 0.03
		//[MaterialToggle] _ErosionReverse ("Reverse", Float) = 0
		[MaterialToggle] _Debug ("Debug Erosion", Float) = 0

		[Space(20)]
		[Header(Depth)]
		_Depth ("Depth", Range(0,5)) = 0
	}
	SubShader
	{
		Tags { "RenderType"="Transparent" "Queue"="Transparent" }

		Blend One OneMinusSrcAlpha

		ZWrite Off
		Lighting Off
		LOD 100


		Pass
		{
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag		
			#include "UnityCG.cginc"



			//vert infos
			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float4 scrollinguvs : TEXCOORD1;
				float4 color : COLOR;

				float3 normal : NORMAL;
			};

			//frag infos
			struct v2f
			{
				float2 uv1 : TEXCOORD0;	
				float2 uv2 : TEXCOORD1;	
				float2 uv3 : TEXCOORD2;
				float2 uv4 : TEXCOORD4;
				float4 vertex : SV_POSITION;
				float4 v_color : COLOR;
				float alphaerosion : FLOAT;
				float4 screenPos : TEXCOORD5;

				//float3 worldNormal : TEXCOORD3;
				//float4 worldPos : TEXCOORD6;
			};


			//Variables//

			/* Main */
			sampler2D _MainTex;
			float4 _MainTex_ST;
			fixed4 _Color1;
			fixed4 _Color2;
			fixed _UseAlphaChannel;
			fixed _isAdditiveOnly;
			fixed _isBlendedOnly;
			fixed _isPremultiplied;
			fixed _Glow;
			fixed _U_Speed;
			fixed _V_Speed;
			fixed _MainmapUseCustomVertexStreams;

			/* Secondary Map */
			fixed _HasSecondaryMap;
			fixed _SmapUseCustomVertexStreams;
			sampler2D _SecondaryTex;
			fixed4 _SecondaryTex_ST;
			fixed4 _SecondaryColor1;
			fixed4 _SecondaryColor2;
			fixed _U_Speed2;
			fixed _V_Speed2;
			fixed _IsEmissive;
			fixed _NoisePower;

			/* Alpha Mask */
			fixed _HasAlphaMask;
			sampler2D _MaskTex;
			fixed4 _MaskTex_ST;
			fixed  _MaskPower;


			/* Alpha Erosion */
			fixed _HasAlphaErosion;
			fixed _ErosionUseCustomVertexStreams;
			sampler2D _ErosionTex;
			fixed4 _ErosionTex_ST;
			fixed4 _ErosionSubColor1;
			fixed4 _ErosionSubColor2;
			fixed _ErosionPower;
			fixed _ErosionSpeed;
			fixed _ErosionSmoothness;
			//fixed _ErosionThickness;
			//fixed _ErosionReverse;
			fixed _Debug;

			/*Depth effect*/
			sampler2D _CameraDepthTexture; //Unity default
			fixed _Depth;


			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);

				//main UVs
				o.uv1 = TRANSFORM_TEX((v.uv.xy   +  (v.scrollinguvs.xy * _MainmapUseCustomVertexStreams)),_MainTex);

				o.uv1 += (fixed2(_U_Speed,_V_Speed) * _Time.y) * (1-_MainmapUseCustomVertexStreams);

				//Secondary tex
				o.uv2 = TRANSFORM_TEX(v.uv.xy,_SecondaryTex);
				o.uv2 += (fixed2(_U_Speed2,_V_Speed2) * _Time.y) * (1-_SmapUseCustomVertexStreams);
				o.uv2 += v.scrollinguvs.zw * _SmapUseCustomVertexStreams;

				//Mask
				o.uv3.xy = TRANSFORM_TEX(v.uv.xy,_MaskTex);

				//vert color
				o.v_color = v.color;

				//alpha erosion passed through v.streams.
				o.alphaerosion = v.uv.z;			
				o.uv4 = TRANSFORM_TEX(v.uv.xy,_ErosionTex);

				//depth Effect
				o.screenPos = ComputeScreenPos(o.vertex);
				COMPUTE_EYEDEPTH(o.screenPos.z);

				//o.worldPos = mul(unity_ObjectToWorld, o.vertex);
				//o.worldNormal = UnityObjectToWorldNormal(v.normal);

				return o;
			}
			


			fixed4 frag (v2f i) : SV_Target
			{
				// sample the textures
				fixed4 col;
				fixed4 Tex = tex2D(_MainTex, i.uv1);
				fixed4 SecondaryTex = tex2D(_SecondaryTex, i.uv2);

				/* MAIN TEXTURE */
				//Assign col RGBs
				col.rgb = Tex.rgb * lerp(_Color2,_Color1,Tex.rgb) * i.v_color.rgb * _Glow;

				//Assign alpha
				col.a = ((step(0.001,Tex.r) * (1-col.r)) * _isBlendedOnly) + ((i.v_color.a * lerp(_Color2.a,_Color1.a,Tex.a)) * (Tex.r * (1-_UseAlphaChannel) + Tex.a * _UseAlphaChannel)) *  (1-_isAdditiveOnly) * (1-_isBlendedOnly);

				//Premultiply alpha
				col.rgb *= ((1-_isPremultiplied) + (col.a * _isPremultiplied));

				/* SECONDARY MAP */
				col.rgb += Tex.rgb * (_HasSecondaryMap * _IsEmissive * SecondaryTex.rgb * lerp(_SecondaryColor2,_SecondaryColor1,SecondaryTex.rgb)) * _NoisePower;
				col.rgb *= (1-_HasSecondaryMap) + (_HasSecondaryMap * (1-_IsEmissive) * SecondaryTex.rgb * lerp(_SecondaryColor2,_SecondaryColor1,SecondaryTex.rgb))  * _NoisePower + (1-_NoisePower)*_HasSecondaryMap*(1-_IsEmissive) + (_IsEmissive * _HasSecondaryMap);
				col.a *= (1-_HasSecondaryMap) + (_HasSecondaryMap * SecondaryTex.r) * (1-_IsEmissive)  * _NoisePower + (1-_NoisePower)*_HasSecondaryMap*(1-_IsEmissive) + (_IsEmissive * _HasSecondaryMap);

				/* ALPHA MASK */
				fixed4 MaskTex = tex2D(_MaskTex,i.uv3.xy);
				col.rgb *= (1-_HasAlphaMask) + pow((_HasAlphaMask * MaskTex.rgb),_MaskPower);
				col.a *= (1-_HasAlphaMask) + pow((_HasAlphaMask * MaskTex.rgb),_MaskPower);

				/* ALPHA EROSION */
				fixed4 ErosionTex = tex2D(_ErosionTex,i.uv4.xy);
				_ErosionPower = _ErosionUseCustomVertexStreams * i.alphaerosion + (1-_ErosionUseCustomVertexStreams) * (_ErosionPower + saturate(_SinTime.w * _ErosionSpeed));
				_ErosionPower *= _HasAlphaErosion;
				
				//col.rgb = lerp(col.rgb * ErosionTex.r,(1-step( ErosionTex.r,_ErosionPower)) * lerp(col.rgb * _ErosionSubColor1,col.rgb * _ErosionSubColor2, ErosionTex.r),_ErosionSmoothness);
				//col.a = lerp(col.a * ErosionTex.r,(1-step(ErosionTex.r,_ErosionPower)) * col.a,_ErosionSmoothness);
				//col.rgb = (1-step(ErosionTex.r,(_ErosionPower + _ErosionSmoothness))) * lerp(col.rgb * )
				col.rgb = (1-step(ErosionTex.r,_ErosionPower)) * lerp(col.rgb * _ErosionSubColor1,col.rgb * _ErosionSubColor2, ErosionTex.r);
				col.a = (1-step(ErosionTex.r,_ErosionPower)) * col.a;

				//col.rgb = (1-step(ErosionTex.r,_ErosionPower)) * lerp(lerp(col.rgb * _ErosionSubColor1,col.rgb * _ErosionSubColor2, ErosionTex.r),0,saturate(abs(_ErosionPower - ErosionTex.r)*10*_ErosionSmoothness));
				//col.a = (1-step(ErosionTex.r,_ErosionPower)) * lerp(col.a,0,saturate(abs(_ErosionPower - ErosionTex.r)* 10 *_ErosionSmoothness));
				
				col.rgb = (_Debug * (1-step( ErosionTex.r,_ErosionPower)))  + (1-_Debug) * col.rgb; //debug


				/*DEPTH EFFECT*/
				float sceneZ = max(0,LinearEyeDepth (UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture, UNITY_PROJ_COORD(i.screenPos)))) - _ProjectionParams.y);
                float partZ = max(0,i.screenPos.z - _ProjectionParams.y);
				float factor = saturate((sceneZ-partZ)/_Depth);
				col *= factor;
				

				//half3 viewDir = normalize(UnityWorldSpaceViewDir(i.worldPos)).xyz;
				//col.rgb += dot(viewDir,i.worldNormal);

				return col;
			}
			ENDCG
		}
	}
}
