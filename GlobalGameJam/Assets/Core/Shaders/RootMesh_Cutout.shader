Shader "FXs/RootCutoutMesh"
{
    Properties
    {
        [Toggle(_PARTICLE_MODE)] _ParticleMode("Particle Mode (Use Custom Vertex Streams)", Int) = 0

        [Space()]
        [Header(______________________________________________________________________)]
        [Space()]

        _Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _OutlineColor ("Outline Color", Color) = (1.0, 1.0, 1.0, 1.0)

        _GradientColor1 ("Gradient Color 1", Color) = (0.0, 0.0, 0.0, 0.0)
        _GradientColor2 ("Gradient Color 2", Color) = (0.0, 0.0, 0.0, 0.0)
        _GradientColor3 ("Gradient Color 3", Color) = (0.0, 0.0, 0.0, 0.0)
        _GradientStep ("Gradient Step : XY = Position; ZW = Smoothing", Vector) = (0.25, 0.5, 0.25, 0.25)

        [Space()]
        [Header(______________________________________________________________________)]
        [Space()]

        _FakeLightColor ("Fake Light Color", Color) = (0.0, 0.0, 0.0, 0.0)
        _FresnelColor ("Fresnel Color", Color) = (0.0, 0.0, 0.0, 0.0)
        _LightDirection ("XYZ = Ligth Direction", Vector) = (0.0, -1.0, 0.0, 1.0)
        _LigthStep ("Ligth Smoothtep Step : XY = Light; ZW = Fresnel", Vector) = (0.0, 1.0, 0.0, 1.0)
        [KeywordEnum(NONE, BASIC)] _LightingMode ("Lighting Mode", Float) = 0

        [Space()]
        [Header(______________________________________________________________________)]
        [Space()]

        [NoScaleOffset] _NoiseTex ("Noise Texture", 2D) = "white" {}
        _NoiseTiling ("Noise Tiling", Vector) = (1.0, 1.0, 1.0, 1.0)
        _NoiseSpeed ("Noise Speed", Vector) = (0.0, 0.0, 0.0, 0.0)
        _Cutout ("Cutout", Range(0.0, 1.0)) = 0.0
        [Toggle(_NOISE_ADD)] _NoiseAdd("Noise Add", Int) = 0
        _NoiseAddColor ("Noise Add Color", Color) = (1.0, 1.0, 1.0, 1.0)

        [Space()]
        [Header(______________________________________________________________________)]
        [Space()]

        [Toggle(_NOISE_DEFORMATION)] _NoiseDeformation("Noise Deformation", Int) = 0
        [NoScaleOffset] _NoiseDeformationTex ("Noise Deformation Texture", 2D) = "white" {}
        _NoiseDeformationTexParams ("XY = Tiling; ZW = Speed", Vector) = (1.0, 1.0, 1.0, 1.0)
        _NoiseDeformationAmount ("XY = Amount (UV Y)", Vector) = (1.0, 1.0, 1.0, 1.0)
        _Deformation("Noise Deformation",Range(0.0,1.0)) = 0.0


        [Space()]
        [Header(______________________________________________________________________)]
        [Space()]
        _RootMask ("Root Mask : X = Start; Y = End ; Z = PointyAmount ; W =", Vector) = (0, 1, 1, 0)

        _BaseTex("Base Texture", 2D) = "white" {}
        _TexTiling("XY = Tiling; ZW = Speed", Vector) = (1.0, 1.0, 1.0, 1.0)



    }
    SubShader
    {
        Tags { "Queue"="AlphaTest" }

        Cull Off
        ZTest Lequal

        Pass
        {
            Tags{"LightMode"="ForwardBase"}

            ZWrite On

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityLightingCommon.cginc"
            #include "UnityCG.cginc"

            #pragma shader_feature_local _ _PARTICLE_MODE
            #pragma shader_feature_local _ _NOISE_DEFORMATION
            #pragma shader_feature_local _ _NOISE_ADD
            #pragma shader_feature_local _ _LIGHTINGMODE_NONE _LIGHTINGMODE_BASIC

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                half4 color : COLOR;

                #ifdef _PARTICLE_MODE
                    #ifdef _NOISE_DEFORMATION
                        float4 uv : TEXCOORD0; //Z = Cutout; W = Noise Deformation
                    #else
                        float3 uv : TEXCOORD0; //Z = Cutout
                    #endif
                #else
                    float2 uv : TEXCOORD0;
                #endif
                    float2 uv2 : TEXCOORD1;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
                float4 noiseCoords : TEXCOORD1;
                float3 viewDirection : TEXCOORD2;
                float3 worldNormal : NORMAL;
                half4 color : COLOR;

                #ifdef _PARTICLE_MODE
                    float3 uv : TEXCOORD0; //Z = Cutout
                #else
                    float2 uv : TEXCOORD0;
                #endif
                    float2 uv2 : TEXCOORD3;
            };

            half4 _Color;
            half4 _GradientColor1;
            half4 _GradientColor2;
            half4 _GradientColor3;
            half4 _GradientStep;
            half4 _OutlineColor;
            half4 _FakeLightColor;
            half4 _FresnelColor;
            half4 _LightDirection;
            half4 _LigthStep;
            half4 _NoiseAddColor;

            float4 _NoiseTiling;
            float4 _NoiseSpeed;

            half _Cutout;

            sampler2D _NoiseTex;
            sampler2D _BaseTex;

            #ifdef _NOISE_DEFORMATION
            sampler2D _NoiseDeformationTex;
            float4 _NoiseDeformationTexParams;
            float4 _NoiseDeformationAmount;
            float _Deformation;
            #endif

            float4 _RootMask;
            half4 _TexTiling;


            v2f vert (appdata v)
            {
                v2f o;

                //vertex deformation PointyAmount
                v.vertex.xyz -= (v.normal.xyz * _RootMask.z*0.1) * smoothstep(_RootMask.y-_RootMask.w,_RootMask.y,v.uv.y);

                float4 worldPos = mul(unity_ObjectToWorld, v.vertex);

                #ifdef _NOISE_DEFORMATION
                    float4 noiseDeformationCoords = 0.0;
                    noiseDeformationCoords.xy = worldPos.xy;
                    noiseDeformationCoords.xy += _NoiseDeformationTexParams.zw * _Time.yyyy;
                    noiseDeformationCoords.xy /= _NoiseDeformationTexParams.xy;
                    float3 noiseDeformation = tex2Dlod(_NoiseDeformationTex, noiseDeformationCoords).xyz - 0.5;
                    noiseDeformation *= lerp(_NoiseDeformationAmount.x, _NoiseDeformationAmount.y, v.uv.y) * _Deformation;
                    #ifdef _PARTICLE_MODE
                        noiseDeformation *= v.uv.w;
                    #endif
                    worldPos.xyz += noiseDeformation;
                #endif


                o.vertex = mul(UNITY_MATRIX_VP, worldPos);

                o.viewDirection = normalize(_WorldSpaceCameraPos - worldPos);
                o.worldNormal = UnityObjectToWorldNormal(v.normal.xyz);

                o.noiseCoords = worldPos.xyxy;
                o.noiseCoords += _NoiseSpeed * _Time.yyyy;
                o.noiseCoords /= _NoiseTiling;

                #ifdef _PARTICLE_MODE
                    o.uv.xyz = v.uv.xyz;
                #else
                    o.uv.xy = v.uv.xy;
                #endif

                    o.uv2.xy = v.uv2.xy;

                o.color = v.color * _Color * 2.0;

                return o;
            }

            half4 frag (v2f i) : SV_Target
            {
                
		        half2 transition = smoothstep(_GradientStep.xy, _GradientStep.xy + _GradientStep.zw, i.uv.y);
		        half4 result = lerp(_GradientColor1, _GradientColor2, transition.x);
		        half4 gradient = lerp(result, _GradientColor3, transition.y);

                half2 light;
                light.x = dot(i.worldNormal, normalize(_LightDirection));
                light.y = dot(i.worldNormal, i.viewDirection);
                light = smoothstep(_LigthStep.xz, _LigthStep.yw, light);

                half4 color = gradient;
                color += light.x * _FakeLightColor + light.y * _FresnelColor;
                color = lerp(color, _OutlineColor, i.uv.x);

                half noise1 = tex2D(_NoiseTex, i.noiseCoords.xy).x;
                half noise2 = tex2D(_NoiseTex, i.noiseCoords.zw).x;
                half noise = (noise1 + noise2) * 0.5;

                color *= i.color;
                color.a *= noise;

                color *= tex2D(_BaseTex, i.uv2.xy * _TexTiling.xy);

                #ifdef _PARTICLE_MODE
                    _Cutout += i.uv.z;
                #endif

                #ifdef _NOISE_ADD
                    color.rgb += (1.0 - noise) * _NoiseAddColor * i.color;
                #endif

                #ifdef _LIGHTINGMODE_BASIC
                    color.xyz *= UNITY_LIGHTMODEL_AMBIENT + _LightColor0;
                #endif

                clip(color.a - _Cutout);

                float progression = ((step(_RootMask.y,i.uv.y) + step(i.uv.y,_RootMask.x)));
                clip(color.a- progression);
                //return progression;
                //return tex2D(_BaseTex, i.uv2.xy * _TexTiling.xy);
                return color;
            }
            ENDCG
        }
    }
}
