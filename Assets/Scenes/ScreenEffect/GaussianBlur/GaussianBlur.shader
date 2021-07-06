Shader "Unlit/GaussianBlur"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _BlurSize ("Blur Size", Float) = 1.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        
        CGINCLUDE
//
//        Pass
//        {
//
//            
//            CGPROGRAM
//            #pragma vertex vert
//            #pragma fragment frag
//
//            #include "UnityCG.cginc"
//			
//			sampler2D _MainTex;
//            float4 _MainTex_ST;
//            float4 _MainTex_TexelSize;
//
//            float4 _Offsets;
//            float _BlurSize;
//
//            struct appdata
//            {
//                float4 vertex : POSITION;
//                float2 uv : TEXCOORD0;
//            };
//
//            struct v2f
//            {
//                float4 vertex : SV_POSITION;
//                half2 uv[5] : TEXCOORD0;
//            };
//
//            v2f vertBlurVertical (appdata_img v)
//            {
//                v2f o;
//                o.vertex = UnityObjectToClipPos(v.vertex);
//
//                //计算一个偏移值
//                // offset（1，0，0，0）代表水平方向
//                // offset（0，1，0，0）表示垂直方向  
//                half2 uv = v.texcoord;
//                
//                o.uv[0] = uv;
//                o.uv[1] = uv + float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
//                o.uv[2] = uv - float2(0.0, _MainTex_TexelSize.y * 1.0) * _BlurSize;
//                o.uv[3] = uv + float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
//                o.uv[4] = uv - float2(0.0, _MainTex_TexelSize.y * 2.0) * _BlurSize;
//                return o;
//            }
//
//            fixed4 fragBlur(v2f i) : SV_Target{
//                float weight[3] = {0.4026, 0.2442, 0.0545};
//
//                fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];
//
//                for (int it = 1; it < 3 ; ++it)
//                {
//                    sum += tex2D(_MainTex, i.uv[it * 2 - 1]).rgb * weight[it];
//                    sum += tex2D(_MainTex, i.uv[it * 2]).rgb * weight[it];
//                }
//            }
//            ENDCG
//        }
        
        ZTest Always
        Cull Off
        ZWrite Off
        
        fixed4 fragBlur(v2f i) : SV_Target{
                float weight[3] = {0.4026, 0.2442, 0.0545};

                fixed3 sum = tex2D(_MainTex, i.uv[0]).rgb * weight[0];

                for (int it = 1; it < 3 ; ++it)
                {
                    sum += tex2D(_MainTex, i.uv[it * 2 - 1]).rgb * weight[it];
                    sum += tex2D(_MainTex, i.uv[it * 2]).rgb * weight[it];
                }
            }
        
        Pass
        {
            NAME "GAUSSIAN_BLUR_VERTICAL"

            CGPROGRAM
            #pragma vertex vertBlurVertical
            #pragma fragment fragBlur
            ENDCG
        }
        
        Pass
        {
            NAME "GAUSSIAN_BLUR_HORIZONTAL"
            
            CGPROGRAM
            #pragma vertex vertBlurHorizontal
            #pragma fragment fragBlur
            ENDCG
        }
        ENDCG
    }
}
