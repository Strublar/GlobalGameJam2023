// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Unlit/Main"
{
	Properties
	{
		[Enum(UnityEngine.Rendering.BlendMode)]_SrcBlendMode("SrcBlendMode", Float) = 1
		[Enum(UnityEngine.Rendering.BlendMode)]_DstBlendMode("DstBlendMode", Float) = 10
		[Enum(UnityEngine.Rendering.CullMode)]_CullMode("CullMode", Float) = 2
		[Header(Main Texture)]_MainTexture("Main Texture", 2D) = "white" {}
		_MainColor("Main Color", Color) = (1,1,1,1)
		_SecondaryColor("Secondary Color", Color) = (0,0,0,0)
		_Glow("Glow", Float) = 1
		[Toggle]_IsPanning("Is Panning ?", Float) = 1
		_UVPanningSPEED("UV Panning SPEED", Vector) = (1,0,0,0)
		[Toggle]_UseGreenChannelasErosion("Use Green Channel as Erosion", Float) = 0
		[Toggle]_UseBlueChannelasMask("Use Blue Channel as Mask", Float) = 0
		[Toggle]_UseCustomVertexStreams2("Use Custom Vertex Streams (2.ZW)", Float) = 0
		[Toggle][Header(Mask Texture)]_ActivateEffect("ActivateEffect", Float) = 0
		_MaskCoefficient("Mask Coefficient", Range( 0 , 1)) = 1
		_MaskTexture("MaskTexture", 2D) = "white" {}
		[Toggle]_IsPanning3("Is Panning ?", Float) = 1
		_PannerSpeed2("Panner Speed 2", Vector) = (1,0,0,0)
		[Toggle]_UseCustomVertexStreams3("Use Custom Vertex Streams (3.XY)", Float) = 0
		[Toggle]_IsEmissive("IsEmissive", Float) = 0
		_EmissiveGlow("EmissiveGlow", Range( 0 , 5)) = 1
		[Toggle][Header(Distortion Texture)]_ActivateEffect3("Activate Effect", Float) = 0
		_DistortionTexture("Distortion Texture", 2D) = "white" {}
		[Toggle]_IsPanning4("Is Panning ?", Float) = 1
		_XYSpeedZWClampAlpha("X/Y Speed Z/W Clamp Alpha", Vector) = (0,0,0,1)
		_Flow("Flow", Range( 0 , 1)) = 0
		[Toggle][Header(Erosion Effect)]_ActivateEffect2("Activate Effect", Float) = 0
		_ErosionMap("Erosion Map", 2D) = "white" {}
		_Erosion("Erosion", Range( 0 , 1)) = 0
		_Smoothness("Smoothness", Range( 0 , 1)) = 0
		[Toggle]_UseCustomVertexStreams1X("Use Custom Vertex Streams (1.X)", Float) = 0
		[Toggle][Header(Mask along UVs)]_MaskAlongUVs("MaskAlongUVs", Float) = 0
		_UVMasking("U.V Masking", Vector) = (1,0,0,0)
		[Toggle]_Invert("Invert", Float) = 0
		[Header(Fake Fog)]_FakeFogColor("Fake Fog Color", Color) = (1,1,1,1)
		_AlphaCoefficient("Alpha Coefficient", Float) = 1
		[Header(Soft Particle)]_Depth("Depth", Float) = 0
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord3( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord2( "", 2D ) = "white" {}
		[HideInInspector] _tex4coord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Transparent"  "Queue" = "Transparent+0" "IgnoreProjector" = "True" "IsEmissive" = "true"  }
		Cull [_CullMode]
		ZWrite Off
		Blend [_SrcBlendMode] [_DstBlendMode] , [_SrcBlendMode] [_DstBlendMode]
		
		CGINCLUDE
		#include "UnityShaderVariables.cginc"
		#include "UnityCG.cginc"
		#include "UnityPBSLighting.cginc"
		#include "Lighting.cginc"
		#pragma target 4.0
		#undef TRANSFORM_TEX
		#define TRANSFORM_TEX(tex,name) float4(tex.xy * name##_ST.xy + name##_ST.zw, tex.z, tex.w)
		struct Input
		{
			float3 worldPos;
			float4 uv3_tex4coord3;
			float2 uv_texcoord;
			float4 uv2_tex4coord2;
			float4 vertexColor : COLOR;
			float4 uv_tex4coord;
			float4 screenPosition52;
		};

		uniform float _CullMode;
		uniform float _DstBlendMode;
		uniform float _SrcBlendMode;
		uniform float4 _FakeFogColor;
		uniform float4 _SecondaryColor;
		uniform float4 _MainColor;
		uniform sampler2D _MainTexture;
		SamplerState sampler_MainTexture;
		uniform float _IsPanning;
		uniform float _UseCustomVertexStreams2;
		uniform float2 _UVPanningSPEED;
		uniform float _Flow;
		uniform sampler2D _DistortionTexture;
		SamplerState sampler_DistortionTexture;
		uniform float _IsPanning4;
		uniform float4 _XYSpeedZWClampAlpha;
		uniform float4 _DistortionTexture_ST;
		uniform float _ActivateEffect3;
		uniform float4 _MainTexture_ST;
		uniform float _Glow;
		uniform float _UseBlueChannelasMask;
		uniform sampler2D _MaskTexture;
		SamplerState sampler_MaskTexture;
		uniform float _IsPanning3;
		uniform float _UseCustomVertexStreams3;
		uniform float2 _PannerSpeed2;
		uniform float4 _MaskTexture_ST;
		uniform float _IsEmissive;
		uniform float _MaskCoefficient;
		uniform float _ActivateEffect;
		uniform float2 _UVMasking;
		uniform float _MaskAlongUVs;
		uniform float _Invert;
		uniform float _EmissiveGlow;
		uniform float _Erosion;
		uniform float _UseCustomVertexStreams1X;
		uniform float _Smoothness;
		uniform float _UseGreenChannelasErosion;
		uniform sampler2D _ErosionMap;
		uniform float4 _ErosionMap_ST;
		uniform float _ActivateEffect2;
		UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
		uniform float4 _CameraDepthTexture_TexelSize;
		uniform float _Depth;
		uniform float _AlphaCoefficient;

		void vertexDataFunc( inout appdata_full v, out Input o )
		{
			UNITY_INITIALIZE_OUTPUT( Input, o );
			float3 ase_vertex3Pos = v.vertex.xyz;
			float3 vertexPos52 = ase_vertex3Pos;
			float4 ase_screenPos52 = ComputeScreenPos( UnityObjectToClipPos( vertexPos52 ) );
			o.screenPosition52 = ase_screenPos52;
		}

		inline half4 LightingUnlit( SurfaceOutput s, half3 lightDir, half atten )
		{
			return half4 ( 0, 0, 0, s.Alpha );
		}

		void surf( Input i , inout SurfaceOutput o )
		{
			float3 ase_vertex3Pos = mul( unity_WorldToObject, float4( i.worldPos , 1 ) );
			float4 transform65 = mul(unity_ObjectToWorld,float4( ase_vertex3Pos , 0.0 ));
			float temp_output_7_0 = step( 0.9 , _UseCustomVertexStreams2 );
			float2 appendResult114 = (float2(_XYSpeedZWClampAlpha.x , _XYSpeedZWClampAlpha.y));
			float2 appendResult76 = (float2(i.uv3_tex4coord3.z , i.uv3_tex4coord3.w));
			float2 uv_TexCoord79 = i.uv_texcoord * _DistortionTexture_ST.xy + appendResult76;
			float2 panner81 = ( ( _Time.y * _IsPanning4 ) * appendResult114 + uv_TexCoord79);
			float4 tex2DNode82 = tex2D( _DistortionTexture, panner81 );
			float2 appendResult83 = (float2(tex2DNode82.g , tex2DNode82.b));
			float2 temp_cast_2 = (_XYSpeedZWClampAlpha.z).xx;
			float2 temp_cast_3 = (_XYSpeedZWClampAlpha.w).xx;
			float2 clampResult86 = clamp( ( ( appendResult83 + -0.5 ) * 2.0 ) , temp_cast_2 , temp_cast_3 );
			float2 flowedUV73 = ( _Flow * clampResult86 * step( 0.5 , _ActivateEffect3 ) );
			float2 appendResult8 = (float2(i.uv2_tex4coord2.z , i.uv2_tex4coord2.w));
			float2 uv_TexCoord26 = i.uv_texcoord * _MainTexture_ST.xy + ( _MainTexture_ST.zw + ( appendResult8 * temp_output_7_0 ) );
			float2 panner35 = ( ( _Time.y * _IsPanning * ( 1.0 - temp_output_7_0 ) ) * _UVPanningSPEED + ( flowedUV73 + uv_TexCoord26 ));
			float4 tex2DNode44 = tex2D( _MainTexture, panner35 );
			float4 lerpResult55 = lerp( _SecondaryColor , _MainColor , tex2DNode44.r);
			float mainBlueChannel129 = tex2DNode44.b;
			float temp_output_6_0 = step( 0.9 , _UseCustomVertexStreams3 );
			float2 appendResult5 = (float2(i.uv3_tex4coord3.x , i.uv3_tex4coord3.y));
			float2 uv_TexCoord19 = i.uv_texcoord * _MaskTexture_ST.xy + ( _MaskTexture_ST.zw + ( appendResult5 * temp_output_6_0 ) );
			float2 panner32 = ( ( _Time.y * _IsPanning3 * ( 1.0 - temp_output_6_0 ) ) * _PannerSpeed2 + uv_TexCoord19);
			float temp_output_143_0 = ( ( mainBlueChannel129 * step( 0.5 , _UseBlueChannelasMask ) ) + ( step( _UseBlueChannelasMask , 0.0 ) * tex2D( _MaskTexture, panner32 ).r ) );
			float temp_output_165_0 = step( 0.5 , _IsEmissive );
			float lerpResult104 = lerp( 1.0 , temp_output_143_0 , ( ( 1.0 - temp_output_165_0 ) * saturate( ( _MaskCoefficient * step( 0.5 , _ActivateEffect ) ) ) ));
			float2 break151 = ( uv_TexCoord19 * _UVMasking );
			float lerpResult149 = lerp( 1.0 , ( break151.x + break151.y ) , step( 0.5 , _MaskAlongUVs ));
			float temp_output_156_0 = ( ( ( 1.0 - lerpResult149 ) * _Invert ) + ( ( 1.0 - _Invert ) * lerpResult149 ) );
			float clampResult36 = clamp( ( _UseCustomVertexStreams1X * i.uv_tex4coord.z ) , 0.0 , 1.0 );
			float temp_output_43_0 = ( ( _Erosion * ( 1.0 - _UseCustomVertexStreams1X ) ) + clampResult36 );
			float4 temp_cast_4 = (temp_output_43_0).xxxx;
			float4 temp_cast_5 = (( temp_output_43_0 + ( temp_output_43_0 * _Smoothness ) )).xxxx;
			float mainGreenChannel128 = tex2DNode44.g;
			float2 uv_ErosionMap = i.uv_texcoord * _ErosionMap_ST.xy + _ErosionMap_ST.zw;
			float4 smoothstepResult61 = smoothstep( temp_cast_4 , temp_cast_5 , ( ( mainGreenChannel128 * step( 0.5 , _UseGreenChannelasErosion ) ) + ( step( _UseGreenChannelasErosion , 0.0 ) * tex2D( _ErosionMap, uv_ErosionMap ) ) ));
			float4 temp_output_89_0 = saturate( ( ( smoothstepResult61 * _ActivateEffect2 ) + step( 0.5 , ( 1.0 - _ActivateEffect2 ) ) ) );
			float4 ase_screenPos52 = i.screenPosition52;
			float4 ase_screenPosNorm52 = ase_screenPos52 / ase_screenPos52.w;
			ase_screenPosNorm52.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm52.z : ase_screenPosNorm52.z * 0.5 + 0.5;
			float screenDepth52 = LinearEyeDepth(SAMPLE_DEPTH_TEXTURE( _CameraDepthTexture, ase_screenPosNorm52.xy ));
			float distanceDepth52 = saturate( abs( ( screenDepth52 - LinearEyeDepth( ase_screenPosNorm52.z ) ) / ( _Depth ) ) );
			o.Emission = ( ( saturate( distance( transform65 , float4( _WorldSpaceCameraPos , 0.0 ) ) ) * _FakeFogColor ) * ( ( lerpResult55 * _Glow * i.vertexColor * lerpResult104 * tex2DNode44.r * temp_output_156_0 * i.vertexColor.a ) + ( i.vertexColor * ( _EmissiveGlow * ( temp_output_165_0 * temp_output_143_0 ) ) ) ) * temp_output_89_0 * distanceDepth52 ).rgb;
			float temp_output_53_0 = ( ( tex2DNode44.r * lerpResult104 * _AlphaCoefficient * i.vertexColor.a * temp_output_156_0 ) * distanceDepth52 );
			float clampResult59 = clamp( temp_output_53_0 , temp_output_53_0 , 1.0 );
			o.Alpha = ( clampResult59 * temp_output_89_0 ).r;
		}

		ENDCG
		CGPROGRAM
		#pragma surface surf Unlit keepalpha fullforwardshadows nofog vertex:vertexDataFunc 

		ENDCG
		Pass
		{
			Name "ShadowCaster"
			Tags{ "LightMode" = "ShadowCaster" }
			ZWrite On
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			#pragma target 4.0
			#pragma multi_compile_shadowcaster
			#pragma multi_compile UNITY_PASS_SHADOWCASTER
			#pragma skip_variants FOG_LINEAR FOG_EXP FOG_EXP2
			#include "HLSLSupport.cginc"
			#if ( SHADER_API_D3D11 || SHADER_API_GLCORE || SHADER_API_GLES || SHADER_API_GLES3 || SHADER_API_METAL || SHADER_API_VULKAN )
				#define CAN_SKIP_VPOS
			#endif
			#include "UnityCG.cginc"
			#include "Lighting.cginc"
			#include "UnityPBSLighting.cginc"
			sampler3D _DitherMaskLOD;
			struct v2f
			{
				V2F_SHADOW_CASTER;
				float4 customPack1 : TEXCOORD1;
				float2 customPack2 : TEXCOORD2;
				float4 customPack3 : TEXCOORD3;
				float4 customPack4 : TEXCOORD4;
				float4 customPack5 : TEXCOORD5;
				float3 worldPos : TEXCOORD6;
				half4 color : COLOR0;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				UNITY_VERTEX_OUTPUT_STEREO
			};
			v2f vert( appdata_full v )
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID( v );
				UNITY_INITIALIZE_OUTPUT( v2f, o );
				UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO( o );
				UNITY_TRANSFER_INSTANCE_ID( v, o );
				Input customInputData;
				vertexDataFunc( v, customInputData );
				float3 worldPos = mul( unity_ObjectToWorld, v.vertex ).xyz;
				half3 worldNormal = UnityObjectToWorldNormal( v.normal );
				o.customPack1.xyzw = customInputData.uv3_tex4coord3;
				o.customPack1.xyzw = v.texcoord2;
				o.customPack2.xy = customInputData.uv_texcoord;
				o.customPack2.xy = v.texcoord;
				o.customPack3.xyzw = customInputData.uv2_tex4coord2;
				o.customPack3.xyzw = v.texcoord1;
				o.customPack4.xyzw = customInputData.uv_tex4coord;
				o.customPack4.xyzw = v.texcoord;
				o.customPack5.xyzw = customInputData.screenPosition52;
				o.worldPos = worldPos;
				TRANSFER_SHADOW_CASTER_NORMALOFFSET( o )
				o.color = v.color;
				return o;
			}
			half4 frag( v2f IN
			#if !defined( CAN_SKIP_VPOS )
			, UNITY_VPOS_TYPE vpos : VPOS
			#endif
			) : SV_Target
			{
				UNITY_SETUP_INSTANCE_ID( IN );
				Input surfIN;
				UNITY_INITIALIZE_OUTPUT( Input, surfIN );
				surfIN.uv3_tex4coord3 = IN.customPack1.xyzw;
				surfIN.uv_texcoord = IN.customPack2.xy;
				surfIN.uv2_tex4coord2 = IN.customPack3.xyzw;
				surfIN.uv_tex4coord = IN.customPack4.xyzw;
				surfIN.screenPosition52 = IN.customPack5.xyzw;
				float3 worldPos = IN.worldPos;
				half3 worldViewDir = normalize( UnityWorldSpaceViewDir( worldPos ) );
				surfIN.worldPos = worldPos;
				surfIN.vertexColor = IN.color;
				SurfaceOutput o;
				UNITY_INITIALIZE_OUTPUT( SurfaceOutput, o )
				surf( surfIN, o );
				#if defined( CAN_SKIP_VPOS )
				float2 vpos = IN.pos;
				#endif
				half alphaRef = tex3D( _DitherMaskLOD, float3( vpos.xy * 0.25, o.Alpha * 0.9375 ) ).a;
				clip( alphaRef - 0.01 );
				SHADOW_CASTER_FRAGMENT( IN )
			}
			ENDCG
		}
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=18400
264;464;1370;699;797.071;393.6791;1.195571;True;False
Node;AmplifyShaderEditor.CommentaryNode;96;-3957.913,2365.848;Inherit;False;2251.152;809.438;Flow;21;72;74;77;76;75;79;80;81;82;83;84;87;86;88;73;111;112;113;114;116;117;Distortion effect;0.7373281,0.3349057,1,1;0;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;72;-3907.913,2627.185;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;74;-3305.735,2862.44;Float;False;Property;_IsPanning4;Is Panning ?;23;1;[Toggle];Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.Vector4Node;113;-3756.862,2926.031;Inherit;False;Property;_XYSpeedZWClampAlpha;X/Y Speed Z/W Clamp Alpha;24;0;Create;True;0;0;False;0;False;0,0,0,1;-1,0.5,0,1;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.TextureTransformNode;77;-3540.4,2494.614;Inherit;False;82;False;1;0;SAMPLER2D;_Sampler077;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.DynamicAppendNode;76;-3676.184,2700.752;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;75;-3302.013,2782.224;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;114;-3268.073,2642.083;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;80;-3057.639,2796.464;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;79;-3274.36,2486.381;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;81;-2987.728,2578.09;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SamplerNode;82;-2802.37,2473.296;Inherit;True;Property;_DistortionTexture;Distortion Texture;22;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.CommentaryNode;125;-3681.808,-970.0246;Inherit;False;2408.891;1133.6;Comment;22;129;128;55;48;50;44;35;31;29;30;25;23;20;22;26;17;11;12;8;7;4;3;Main Texture;0.25178,0.4339623,0.3680638,1;0;0
Node;AmplifyShaderEditor.DynamicAppendNode;83;-2652.487,2720.546;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;3;-3631.808,-697.0638;Inherit;False;1;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.FunctionNode;84;-2652.841,2842.258;Inherit;False;ConstantBiasScale;-1;;1;63208df05c83e8e49a48ffbdce2e43a0;0;3;3;FLOAT2;0,0;False;1;FLOAT;-0.5;False;2;FLOAT;2;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;4;-3629.219,-377.3701;Inherit;False;Property;_UseCustomVertexStreams2;Use Custom Vertex Streams (2.ZW);12;1;[Toggle];Create;False;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;117;-2446.893,3007.834;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;116;-2412.248,3053.469;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;111;-2278.998,2878.308;Inherit;False;Property;_ActivateEffect3;Activate Effect;21;1;[Toggle];Create;False;0;0;False;1;Header(Distortion Texture);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;7;-3278.03,-395.3349;Inherit;True;2;0;FLOAT;0.9;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.DynamicAppendNode;8;-3352.16,-639.8743;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;87;-2371.349,2415.848;Inherit;False;Property;_Flow;Flow;25;0;Create;True;0;0;False;0;False;0;0.2;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;86;-2288.691,2673.787;Inherit;False;3;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;2;FLOAT2;1,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;112;-2052.93,2940.961;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;160;-3789.358,286.2303;Inherit;False;2725.86;1182.65;Secondary texture to mask out the main texture;35;162;165;168;169;104;167;163;166;105;143;142;110;141;103;37;138;140;108;139;93;32;137;27;21;15;13;14;19;16;10;9;6;5;2;1;Mask Texture;0.3962264,0.3756675,0.3756675,1;0;0
Node;AmplifyShaderEditor.RangedFloatNode;1;-3739.358,1196.933;Inherit;False;Property;_UseCustomVertexStreams3;Use Custom Vertex Streams (3.XY);18;1;[Toggle];Create;False;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;12;-3220.308,-853.5518;Inherit;False;44;False;1;0;SAMPLER2D;_Sampler012;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;88;-2130.745,2572.489;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;11;-3130.457,-685.5678;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TexCoordVertexDataNode;2;-3712.746,728.355;Inherit;False;2;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.DynamicAppendNode;5;-3464.404,776.8578;Inherit;False;FLOAT2;4;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;6;-3385.633,1178.969;Inherit;True;2;0;FLOAT;0.9;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;17;-2948.042,-696.7573;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;73;-1930.758,2644.608;Inherit;False;flowedUV;-1;True;1;0;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;23;-2949.797,-409.4673;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;25;-2815.796,-920.0246;Inherit;False;73;flowedUV;1;0;OBJECT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;26;-2803.486,-788.463;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;20;-2941.823,-187.448;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;9;-3211.395,739.8511;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT;0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;22;-2944.179,-325.4395;Float;False;Property;_IsPanning;Is Panning ?;8;1;[Toggle];Create;True;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.TextureTransformNode;10;-3339.343,592.1852;Inherit;False;37;False;1;0;SAMPLER2D;_Sampler010;False;2;FLOAT2;0;FLOAT2;1
Node;AmplifyShaderEditor.Vector2Node;30;-2949.437,-548.1766;Float;False;Property;_UVPanningSPEED;UV Panning SPEED;9;0;Create;True;0;0;False;0;False;1,0;0,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.CommentaryNode;161;-3346.923,1567.635;Inherit;False;1814.08;509.317;Additional Masking option to hide specific UV parts;14;153;151;152;149;146;147;155;156;158;157;154;159;145;144;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;29;-2688.179,-389.4399;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;16;-3045.3,732.7361;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.CommentaryNode;101;-1424.784,2049.432;Inherit;False;2341.106;1240.034;Comment;27;89;122;119;120;121;61;58;118;57;51;98;40;43;38;36;33;28;34;18;24;132;133;130;127;135;136;134;Erosion;1,0.5058824,0.5920227,1;0;0
Node;AmplifyShaderEditor.SimpleAddOpNode;31;-2513.208,-805.2326;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.RangedFloatNode;18;-1384.068,2885.639;Inherit;False;Property;_UseCustomVertexStreams1X;Use Custom Vertex Streams (1.X);30;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;13;-3030.071,1186.855;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TextureCoordinatesNode;19;-2886.244,667.4332;Inherit;False;0;-1;2;3;2;SAMPLER2D;;False;0;FLOAT2;0.5,0.5;False;1;FLOAT2;0,0;False;5;FLOAT2;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PannerNode;35;-2342.749,-509.7229;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleTimeNode;15;-3038.045,964.8351;Inherit;False;1;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;144;-3296.923,1876.558;Inherit;False;Property;_UVMasking;U.V Masking;32;0;Create;True;0;0;False;0;False;1,0;1,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.TexCoordVertexDataNode;24;-1270.725,3010.634;Inherit;False;0;4;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;14;-3032.427,1048.863;Float;False;Property;_IsPanning3;Is Panning ?;16;1;[Toggle];Create;False;0;0;False;0;False;1;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;44;-1988.642,-205.389;Inherit;True;Property;_MainTexture;Main Texture;4;0;Create;True;0;0;False;1;Header(Main Texture);False;-1;None;0000000000000000f000000000000000;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;34;-1001.527,2808.254;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;145;-3056.094,1755.325;Inherit;False;2;2;0;FLOAT2;0,0;False;1;FLOAT2;0,0;False;1;FLOAT2;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;28;-1013.626,2976.317;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;33;-1090.361,2723.513;Inherit;False;Property;_Erosion;Erosion;28;0;Create;True;0;0;False;0;False;0;0;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;27;-2776.427,984.8628;Inherit;False;3;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.Vector2Node;21;-3185.214,862.1887;Float;False;Property;_PannerSpeed2;Panner Speed 2;17;0;Create;True;0;0;False;0;False;1,0;-2,0;0;3;FLOAT2;0;FLOAT;1;FLOAT;2
Node;AmplifyShaderEditor.RangedFloatNode;93;-2579.965,1229.564;Inherit;False;Property;_ActivateEffect;ActivateEffect;13;1;[Toggle];Create;True;0;0;False;1;Header(Mask Texture);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;38;-769.5101,2724.233;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;128;-1653.637,-25.32333;Float;False;mainGreenChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;36;-849.6361,2923.645;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;162;-2057.157,784.0004;Inherit;False;Property;_IsEmissive;IsEmissive;19;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;146;-2883.492,1903.051;Inherit;False;Property;_MaskAlongUVs;MaskAlongUVs;31;1;[Toggle];Create;True;0;0;False;1;Header(Mask along UVs);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;108;-2405.764,1017.641;Float;False;Property;_MaskCoefficient;Mask Coefficient;14;0;Create;True;0;0;False;0;False;1;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;127;-386.3911,2320.11;Inherit;False;Property;_UseGreenChannelasErosion;Use Green Channel as Erosion;10;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;129;-1647.087,51.05122;Float;False;mainBlueChannel;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.BreakToComponentsNode;151;-2904.687,1768.987;Inherit;False;FLOAT2;1;0;FLOAT2;0,0;False;16;FLOAT;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4;FLOAT;5;FLOAT;6;FLOAT;7;FLOAT;8;FLOAT;9;FLOAT;10;FLOAT;11;FLOAT;12;FLOAT;13;FLOAT;14;FLOAT;15
Node;AmplifyShaderEditor.RangedFloatNode;137;-2797.54,490.8693;Inherit;False;Property;_UseBlueChannelasMask;Use Blue Channel as Mask;11;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;103;-2343.816,1214.88;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.PannerNode;32;-2615.226,828.7137;Inherit;False;3;0;FLOAT2;0,0;False;2;FLOAT2;0,0;False;1;FLOAT;1;False;1;FLOAT2;0
Node;AmplifyShaderEditor.StepOpNode;130;-76.38736,2242.442;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;40;-617.0411,2866.425;Inherit;False;Property;_Smoothness;Smoothness;29;0;Create;True;0;0;False;0;False;0;1;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;152;-2681.569,1767.247;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;57;-226.7245,2560.517;Inherit;True;Property;_ErosionMap;Erosion Map;27;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;43;-531.3547,2679.281;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;133;-262.6262,2139.471;Inherit;False;128;mainGreenChannel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;135;-78.62607,2368.472;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;139;-2489.775,539.2314;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;110;-2095.28,1129.103;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;138;-2715.89,346.107;Inherit;False;129;mainBlueChannel;1;0;OBJECT;;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;147;-2685.884,1880.557;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.StepOpNode;140;-2487.536,413.2014;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;37;-2369.862,697.6234;Inherit;True;Property;_MaskTexture;MaskTexture;15;0;Create;True;0;0;False;0;False;-1;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;8;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;6;FLOAT;0;False;7;SAMPLERSTATE;;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.StepOpNode;165;-1926.834,681.9995;Inherit;False;2;0;FLOAT;0.5;False;1;FLOAT;0.9;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;132;131.7189,2165.471;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;98;-211.6843,2768.663;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;141;-2279.43,336.2303;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;51;-335.1526,2774.071;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;149;-2520.264,1736.55;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;105;-1951.814,1100.803;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;136;59.37396,2411.472;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;154;-2305.353,1750.374;Inherit;False;Property;_Invert;Invert;33;1;[Toggle];Create;True;0;0;False;0;False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;169;-1797.581,818.7891;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;142;-2351.775,582.2314;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;134;234.374,2300.472;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;168;-1640.171,932.2808;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;118;-26.01353,3049.849;Inherit;False;Property;_ActivateEffect2;Activate Effect;26;1;[Toggle];Create;False;0;0;False;1;Header(Erosion Effect);False;0;0;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;158;-2133.68,1850.297;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;153;-2281.559,1617.635;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;143;-2126.241,490.7935;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;97;-1056.662,-1561.03;Inherit;False;991.6815;587.8083;Comment;7;64;66;65;67;68;71;69;Fake fog;0.4622642,0.3292542,0.3292542,1;0;0
Node;AmplifyShaderEditor.WireNode;159;-2294.924,1964.589;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;58;-130.9281,2806.754;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0.1;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;102;-496.2893,686.1247;Inherit;False;700.0386;236.5992;Soft Particle;3;41;52;46;;1,1,1,1;0;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;155;-2116.799,1682.923;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;94;-640.2153,138.9301;Inherit;False;1229.412;410.1256;Comment;6;47;42;63;59;53;49;Alpha Calculations;1,0.08018869,0.08018869,1;0;0
Node;AmplifyShaderEditor.PosVertexDataNode;64;-1006.662,-1511.03;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;104;-1537.423,695.3126;Inherit;False;3;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;157;-1949.034,1941.952;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.OneMinusNode;121;264.908,3077.036;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SmoothstepOpNode;61;129.5511,2720.088;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;1,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;48;-2000.205,-560.2864;Float;False;Property;_MainColor;Main Color;5;0;Create;True;0;0;False;0;False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.RangedFloatNode;163;-1454.4,431.3057;Inherit;False;Property;_EmissiveGlow;EmissiveGlow;20;0;Create;True;0;0;False;0;False;1;1;0;5;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;42;-590.793,263.8287;Float;False;Property;_AlphaCoefficient;Alpha Coefficient;35;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;50;-1983.324,-726.2662;Float;False;Property;_SecondaryColor;Secondary Color;6;0;Create;True;0;0;False;0;False;0,0,0,0;0.4901961,0.4901961,0.4901961,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;166;-1353.895,581.5851;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.CommentaryNode;100;-477.4383,-385.1637;Inherit;False;971.92;401.9838;Comment;6;56;54;62;60;164;172;Emissive Calculations;0.1503288,0.9622642,0,1;0;0
Node;AmplifyShaderEditor.WireNode;170;-1080.766,740.2755;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;120;405.1655,2754.891;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;46;-246.5754,806.7234;Float;False;Property;_Depth;Depth;36;0;Create;True;0;0;False;1;Header(Soft Particle);False;0;0.5;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.PosVertexDataNode;41;-446.2893,736.1245;Inherit;False;0;0;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleAddOpNode;156;-1767.844,1714.93;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.WorldSpaceCameraPos;66;-805.6336,-1297.472;Inherit;False;0;4;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3
Node;AmplifyShaderEditor.StepOpNode;119;457.7251,3013.809;Inherit;True;2;0;FLOAT;0.5;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ObjectToWorldTransfNode;65;-755.6506,-1478.283;Inherit;False;1;0;FLOAT4;0,0,0,1;False;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.VertexColorNode;47;-608.414,352.955;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;167;-1180.159,522.7495;Inherit;True;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;54;-405.3097,-267.3083;Float;False;Property;_Glow;Glow;7;0;Create;True;0;0;False;0;False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.WireNode;171;-1062.131,796.6245;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;55;-1569.118,-537.1486;Inherit;True;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.VertexColorNode;56;-414.0217,-173.8637;Inherit;False;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;-342.58,188.9301;Inherit;True;5;5;0;FLOAT;1;False;1;FLOAT;0;False;2;FLOAT;0;False;3;FLOAT;0;False;4;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DistanceOpNode;67;-500.4624,-1429.777;Inherit;True;2;0;FLOAT4;0,0,0,0;False;1;FLOAT3;0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.DepthFade;52;-64.25092,738.5437;Inherit;False;True;True;True;2;1;FLOAT3;0,0,0;False;0;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;122;574.5152,2789.544;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;53;-65.93159,208.7684;Inherit;False;2;2;0;FLOAT;0;False;1;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SaturateNode;71;-229.981,-1363.702;Inherit;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;172;60.23334,-159.4141;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;60;-150.6694,-328.7426;Inherit;True;7;7;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SaturateNode;89;745.1734,2769.115;Inherit;True;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ColorNode;68;-502.6606,-1185.221;Float;False;Property;_FakeFogColor;Fake Fog Color;34;0;Create;True;0;0;False;1;Header(Fake Fog);False;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;69;-232.7724,-1265.464;Inherit;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.ClampOpNode;59;77.59753,201.6248;Inherit;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;164;163.4812,-308.9923;Inherit;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.WireNode;99;199.6466,45.92113;Inherit;False;1;0;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;62;393.5727,-331.7436;Inherit;True;4;4;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;COLOR;0,0,0,0;False;3;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.RangedFloatNode;123;1095.75,-331.0996;Inherit;False;Property;_SrcBlendMode;SrcBlendMode;0;0;Create;True;0;0;True;1;Enum(UnityEngine.Rendering.BlendMode);False;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;126;1098.77,-415.2508;Inherit;False;Property;_CullMode;CullMode;2;0;Create;True;0;0;True;1;Enum(UnityEngine.Rendering.CullMode);False;2;2;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;124;1093.876,-247.187;Inherit;False;Property;_DstBlendMode;DstBlendMode;1;0;Create;True;0;0;True;1;Enum(UnityEngine.Rendering.BlendMode);False;10;10;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;63;294.5184,178.2997;Inherit;True;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;1049.348,-144.2285;Float;False;True;-1;4;ASEMaterialInspector;0;0;Unlit;Unlit/Main;False;False;False;False;False;False;False;False;False;True;False;False;False;False;True;False;False;False;False;False;False;Back;2;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Custom;0.5;True;True;0;True;Transparent;;Transparent;All;14;all;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;3;1;True;123;10;True;124;3;1;True;123;10;True;124;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;3;-1;-1;-1;0;False;0;0;True;126;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;False;15;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT;0;False;4;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;76;0;72;3
WireConnection;76;1;72;4
WireConnection;114;0;113;1
WireConnection;114;1;113;2
WireConnection;80;0;75;0
WireConnection;80;1;74;0
WireConnection;79;0;77;0
WireConnection;79;1;76;0
WireConnection;81;0;79;0
WireConnection;81;2;114;0
WireConnection;81;1;80;0
WireConnection;82;1;81;0
WireConnection;83;0;82;2
WireConnection;83;1;82;3
WireConnection;84;3;83;0
WireConnection;117;0;113;3
WireConnection;116;0;113;4
WireConnection;7;1;4;0
WireConnection;8;0;3;3
WireConnection;8;1;3;4
WireConnection;86;0;84;0
WireConnection;86;1;117;0
WireConnection;86;2;116;0
WireConnection;112;1;111;0
WireConnection;88;0;87;0
WireConnection;88;1;86;0
WireConnection;88;2;112;0
WireConnection;11;0;8;0
WireConnection;11;1;7;0
WireConnection;5;0;2;1
WireConnection;5;1;2;2
WireConnection;6;1;1;0
WireConnection;17;0;12;1
WireConnection;17;1;11;0
WireConnection;73;0;88;0
WireConnection;26;0;12;0
WireConnection;26;1;17;0
WireConnection;20;0;7;0
WireConnection;9;0;5;0
WireConnection;9;1;6;0
WireConnection;29;0;23;0
WireConnection;29;1;22;0
WireConnection;29;2;20;0
WireConnection;16;0;10;1
WireConnection;16;1;9;0
WireConnection;31;0;25;0
WireConnection;31;1;26;0
WireConnection;13;0;6;0
WireConnection;19;0;10;0
WireConnection;19;1;16;0
WireConnection;35;0;31;0
WireConnection;35;2;30;0
WireConnection;35;1;29;0
WireConnection;44;1;35;0
WireConnection;34;0;18;0
WireConnection;145;0;19;0
WireConnection;145;1;144;0
WireConnection;28;0;18;0
WireConnection;28;1;24;3
WireConnection;27;0;15;0
WireConnection;27;1;14;0
WireConnection;27;2;13;0
WireConnection;38;0;33;0
WireConnection;38;1;34;0
WireConnection;128;0;44;2
WireConnection;36;0;28;0
WireConnection;129;0;44;3
WireConnection;151;0;145;0
WireConnection;103;1;93;0
WireConnection;32;0;19;0
WireConnection;32;2;21;0
WireConnection;32;1;27;0
WireConnection;130;1;127;0
WireConnection;152;0;151;0
WireConnection;152;1;151;1
WireConnection;43;0;38;0
WireConnection;43;1;36;0
WireConnection;135;0;127;0
WireConnection;139;0;137;0
WireConnection;110;0;108;0
WireConnection;110;1;103;0
WireConnection;147;1;146;0
WireConnection;140;1;137;0
WireConnection;37;1;32;0
WireConnection;165;1;162;0
WireConnection;132;0;133;0
WireConnection;132;1;130;0
WireConnection;98;0;43;0
WireConnection;141;0;138;0
WireConnection;141;1;140;0
WireConnection;51;0;43;0
WireConnection;51;1;40;0
WireConnection;149;1;152;0
WireConnection;149;2;147;0
WireConnection;105;0;110;0
WireConnection;136;0;135;0
WireConnection;136;1;57;0
WireConnection;169;0;165;0
WireConnection;142;0;139;0
WireConnection;142;1;37;1
WireConnection;134;0;132;0
WireConnection;134;1;136;0
WireConnection;168;0;169;0
WireConnection;168;1;105;0
WireConnection;158;0;154;0
WireConnection;153;0;149;0
WireConnection;143;0;141;0
WireConnection;143;1;142;0
WireConnection;159;0;149;0
WireConnection;58;0;98;0
WireConnection;58;1;51;0
WireConnection;155;0;153;0
WireConnection;155;1;154;0
WireConnection;104;1;143;0
WireConnection;104;2;168;0
WireConnection;157;0;158;0
WireConnection;157;1;159;0
WireConnection;121;0;118;0
WireConnection;61;0;134;0
WireConnection;61;1;43;0
WireConnection;61;2;58;0
WireConnection;166;0;165;0
WireConnection;166;1;143;0
WireConnection;170;0;104;0
WireConnection;120;0;61;0
WireConnection;120;1;118;0
WireConnection;156;0;155;0
WireConnection;156;1;157;0
WireConnection;119;1;121;0
WireConnection;65;0;64;0
WireConnection;167;0;163;0
WireConnection;167;1;166;0
WireConnection;171;0;104;0
WireConnection;55;0;50;0
WireConnection;55;1;48;0
WireConnection;55;2;44;1
WireConnection;49;0;44;1
WireConnection;49;1;170;0
WireConnection;49;2;42;0
WireConnection;49;3;47;4
WireConnection;49;4;156;0
WireConnection;67;0;65;0
WireConnection;67;1;66;0
WireConnection;52;1;41;0
WireConnection;52;0;46;0
WireConnection;122;0;120;0
WireConnection;122;1;119;0
WireConnection;53;0;49;0
WireConnection;53;1;52;0
WireConnection;71;0;67;0
WireConnection;172;0;56;0
WireConnection;172;1;167;0
WireConnection;60;0;55;0
WireConnection;60;1;54;0
WireConnection;60;2;56;0
WireConnection;60;3;171;0
WireConnection;60;4;44;1
WireConnection;60;5;156;0
WireConnection;60;6;56;4
WireConnection;89;0;122;0
WireConnection;69;0;71;0
WireConnection;69;1;68;0
WireConnection;59;0;53;0
WireConnection;59;1;53;0
WireConnection;164;0;60;0
WireConnection;164;1;172;0
WireConnection;99;0;89;0
WireConnection;62;0;69;0
WireConnection;62;1;164;0
WireConnection;62;2;99;0
WireConnection;62;3;52;0
WireConnection;63;0;59;0
WireConnection;63;1;89;0
WireConnection;0;2;62;0
WireConnection;0;9;63;0
ASEEND*/
//CHKSM=EC2D02CB26C4A6BBFC9FC33B6823AF5DEB1A13D3