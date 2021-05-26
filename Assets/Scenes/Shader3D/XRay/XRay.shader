Shader "Unlit/XRay"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _XRayColor("XRay Color", Color) = (1,1,1,1)
    }
    SubShader
    {
        Tags
        {
            "Queue" = "Geometry"
            "RenderType"="Opaque"
        }
        //        LOD 100

        //渲染X光效果的Pass
        Pass
        {
            Blend SrcAlpha One

            ZWrite Off
            ZTest Greater

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            #include "Lighting.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            fixed4 _XRayColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : normal;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : normal;
                float3 viewDir : TEXCOORD1;
            };

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                // o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                // o.viewDir = normalize(_WorldSpaceCameraPos.xyz - mul(unity_ObjectToWorld, v.vertex).xyz);
                o.viewDir = ObjSpaceViewDir(v.vertex);
                o.normal = v.normal;
                return o;
            }

            half4 frag(v2f i) : SV_Target
            {
                // half4 col = tex2D(_MainTex, i.uv);
                float3 normal = normalize(i.normal);
                float3 viewDir = normalize(i.viewDir);
                float rim = 1 - dot(normal, viewDir);
                return _XRayColor * rim;
            }
            ENDCG
        }

        //正常渲染的Pass
        Pass
        {
            ZWrite On
            CGPROGRAM
            #include "Lighting.cginc"
            sampler2D _MainTex;
            float4 _MainTex_ST;

            struct v2f
            {
                float4 pos : SV_POSITION;
                float2 uv : TEXCOORD0;
            };

            v2f vert(appdata_base v)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.texcoord, _MainTex);
                return o;
            }

            fixed4 frag(v2f i) : SV_Target
            {
                return tex2D(_MainTex, i.uv);
            }

            #pragma vertex vert
            #pragma fragment frag
            ENDCG
        }

    }
    FallBack "Diffuse"
}