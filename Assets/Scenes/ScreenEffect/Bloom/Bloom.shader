Shader "Unlit/Bloom"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Bloom ("Bloom (RGB)", 2D) = "black" {}
        _LuminanceThreshold ("Luminance Threshold", float) = 0.5
        [Tex]_BlurSize ("Blur Size", Float) = 1.0 
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Pass
        {
            ZTest Always
            Cull Off
            ZWrite Off
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

			sampler2D _MainTex;
            float4 _MainTex_TexelSize;

            sampler2D _Bloom;
            float _LuminanceThreshold;
            float _BlurSize;

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

            fixed luminance(fixed4 color)
            {
                return 0.2125 * color.r + 0.7154 * color.g + 0.0721 * color.b;
            }

            v2f vert (appdata_img v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv.xy = v.texcoord;
                o.uv.zw = v.texcoord;

                #if UNITY_UV_STARTS_AT_TOP
                if (_MainTex_TexelSize.y < 0.0)
                    o.uv.w = 1.0 - o.uv.w;
                #endif

                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
        
//        UsePass "Assets/Scenes/ScreenEffect/GaussianBlur/GAUSSIANBLUR_VERTICAL"
//        UsePass "Assets/Scenes/ScreenEffect/GaussianBlur/GAUSSIANBLUR_HORIZONTAL"
        UsePass "Unlit/GaussianBlur/MYPASS_VERTICAL"
        UsePass "Unlit/GaussianBlur/MYPASS_HORIZONTAL"
        
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            ENDCG
       }   
        
    }
    Fallback Off
}
