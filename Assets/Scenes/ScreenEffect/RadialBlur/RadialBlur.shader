Shader "Unlit/RadialBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            // 定义采样次数
            #define SAMPLE_COUNT 6

			sampler2D _MainTex;
            float4 _MainTex_ST;

            // 模糊强度
            float _BlurFactor;
            // 模糊半径
            float4 _BlurCenter;
            
            // 模糊强度
            float _SampleDist;

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
                float2 dir = i.uv - _BlurCenter.xy;
                float4 outColor = 0;

                // 采样SAMPLE_COUNT次
                for (int j = 0 ; j < SAMPLE_COUNT; ++j)
                {
                    // 计算采样uv值: 正常uv值+从中间向边缘逐渐增加的采样距离
                    float2 uv = i.uv - _BlurFactor * dir * j;
                    outColor += tex2D(_MainTex, uv);
                }

                // 取平均值
                outColor /= SAMPLE_COUNT;
                return outColor;
            }
            ENDCG
        }
    }
}
