Shader "Unlit/Dissolve4"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("Texture", 2D) = "white" {}
        _Threshold ("Threshold", Range(0.0, 1.0)) = 0.5
        _EdgeLength ("EgdeLength", Range(0.0, 0.2)) = 0.1
        [HDR] _EdgeColor ("EdgeColor", Color) = (1, 1, 1, 1)
        [HDR] _EdgeColor1 ("EdgeColor", Color) = (1, 1, 1, 1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Cull Off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			
			sampler2D _MainTex;
            sampler2D _NoiseTex;

            float4 _MainTex_ST;
            float4 _NoiseTex_ST;

            float _Threshold;
            fixed _EdgeLength;
            fixed4 _EdgeColor;
            fixed4 _EdgeColor1;

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 noiseUV : TEXCOORD1;
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.noiseUV = TRANSFORM_TEX(v.uv, _NoiseTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed cutout = tex2D(_NoiseTex, i.noiseUV).r;
                clip(cutout - _Threshold);

                float degree = saturate((cutout - _Threshold) / _EdgeLength);
                fixed4 edgeColor =  lerp(_EdgeColor, _EdgeColor1, degree);

                fixed4 col = tex2D(_MainTex, i.uv);

                fixed4 finalColor = lerp(edgeColor, col, degree);
                return finalColor;
            }
            ENDCG
        }
    }
}
