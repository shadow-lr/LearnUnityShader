Shader "Unlit/OutLine2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _OutLine ("OutLine", Range(0, 10.0)) = 2.5
        _OutLineColor ("OutLineColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        // 天空盒的渲染顺序位于geometry之后，Transparent之前
        Tags { "RenderType"="Oqeue" }
        
        // 描边 先渲染外轮廓 后须在正常渲染
        Pass
        {
            Cull Front
            ZWrite Off

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			
			sampler2D _MainTex;
            float _OutLine;
            float4 _MainTex_ST;
            fixed4 _OutLineColor;

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            // 视角空间法线外拓
            // v2f vert (appdata v)
            // {
            //     v2f o;
            //     o.vertex = UnityObjectToClipPos(v.vertex);
            //     // 把法线转换成视图空间
            //     float3 vnormal = mul((float3x3)UNITY_MATRIX_IT_MV, v.normal);
            //     // 把法线转换成投影空间
            //     float2 pnormal_xy = mul((float2x2)UNITY_MATRIX_P, vnormal.xy);
            //     o.vertex.xy = o.vertex + pnormal_xy * _OutLine;
            //     return o;
            // }

            // 物体空间法线外括 性能最好
            // v2f vert(appdata_base v)
            // {
            //     // 物体顶点法线外扩
            //     v.vertex.xyz += normalize(v.normal) * _OutLine / 10;
            //     v2f o;
            //     o.vertex = UnityObjectToClipPos(v.vertex);
            //     return o;
            // }

            //裁剪空间法线外拓
            v2f vert(appdata_base v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                float3 normal = normalize(mul((float3x3)UNITY_MATRIX_IT_MV, v.normal));

                // 把一个视口坐标转换成屏幕像素坐标
                float2 viewNoraml = TransformViewToProjection(normal.xy);
				o.vertex.xy += viewNoraml * _OutLine;
				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _OutLineColor;
            }
            ENDCG
        }

        // 正常阶段
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			
			sampler2D _MainTex;
            float4 _MainTex_ST;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
