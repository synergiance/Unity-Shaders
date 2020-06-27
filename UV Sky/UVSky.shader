Shader "Synergiance/Skybox/UV Sky"
{
    Properties {
        [NoScaleOffset] _MainTex ("Texture", 2D) = "default" {}
        _Rotation ("Rotation (Degrees)", Range(-180, 180)) = 0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            #define ONE_OVER_PI 0.31830988618

            #if defined(USING_STEREO_MATRICES)
                #define _ActualWorldSpaceCameraPos unity_StereoWorldSpaceCameraPos[unity_StereoEyeIndex]
            #else
                #define _ActualWorldSpaceCameraPos _WorldSpaceCameraPos
            #endif

            struct appdata {
                float4 vertex : POSITION;
            };

            struct v2f {
                float4 vertex : SV_POSITION;
                float3 worldPos : TEXCOORD0;
            };

            sampler2D _MainTex;
            float _Rotation;

            v2f vert (appdata v) {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target {
                float3 viewDir = i.worldPos.xyz - _ActualWorldSpaceCameraPos.xyz;
                float longitude = atan2(viewDir.x, viewDir.z);
                float latitude = atan2(length(viewDir.xz), viewDir.y);
                float2 uv = float2(longitude * 0.5, latitude) * ONE_OVER_PI;
                uv.x += _Rotation / 360;
                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
