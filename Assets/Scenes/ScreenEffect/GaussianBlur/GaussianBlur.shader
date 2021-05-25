Shader "Unlit/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags
        {
            "RenderType"="Opaque"
        }
        
        ZWrite Off
        Cull Off
        ZTest Always
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float4 uv01 : TEXCOORD1;
                float4 uv23 : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            //纹理中的单像素尺寸
            float4 _MainTex_TexelSize;
            //给一个offset，这个offset可以在外面设置，是我们设置横向和竖向blur的关键参数
            float4 _Offsets;

            v2f vert (appdata_img v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.texcoord.xy;

                _Offsets *= _MainTex_TexelSize;

                o.uv01 = v.texcoord.xyxy + _Offsets.xyxy * float4(1, 1, -1, -1);
                o.uv23 = v.texcoord.xyxy + _Offsets.xyxy * float4(1, 1, -1, -1) * 2.0;

                return o;
            }

            // 计算高斯权重
            float computerBluGauss(float x,float sigma) {
                return 0.39894 * exp(-0.5 * x * x / (0.20 * sigma)) / sigma * sigma;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = fixed4(0, 0, 0, 0);

                float w0 = computerBluGauss(0, 8);
                float w1 = computerBluGauss(1, 8);
                float w2 = computerBluGauss(2, 8);
                float sum = w0 + w1 * 2 + w2 * 2;

                color += w0 / sum * tex2D(_MainTex, i.uv);
                color += w1 / sum * tex2D(_MainTex, i.uv01.xy);
                color += w1 / sum * tex2D(_MainTex, i.uv01.zw);
                color += w2 / sum * tex2D(_MainTex, i.uv23.xy);
                color += w2 / sum * tex2D(_MainTex, i.uv23.zw);

                return color;
            }
            ENDCG
        }
    }
}
