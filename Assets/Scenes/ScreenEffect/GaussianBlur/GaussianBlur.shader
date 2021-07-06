Shader "Unlit/GaussianBlur"
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
            Name "MyPass"
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			
			sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _MainTex_TexelSize;

            float4 _Offsets;

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
                float4 uv45 : TEXCOORD3;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);

                //计算一个偏移值
                // offset（1，0，0，0）代表水平方向
                // offset（0，1，0，0）表示垂直方向  
                _Offsets *= _MainTex_TexelSize.xyxy;

                o.uv01 = o.uv.xyxy + _Offsets.xyxy * float4(1, 1, -1, -1);
                o.uv23 = o.uv.xyxy + _Offsets.xyxy * float4(1, 1, -1, -1) * 2.0;
                o.uv45 = o.uv.xyxy + _Offsets.xyxy * float4(1, 1, -1, -1) * 3.0;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 color = fixed4(0, 0, 0, 0);

                color += 0.4 * tex2D(_MainTex, i.uv);
                color += 0.15 * tex2D(_MainTex, i.uv01.xy);
                color += 0.15 * tex2D(_MainTex, i.uv01.zw);
                color += 0.10 * tex2D(_MainTex, i.uv23.xy);
                color += 0.10 * tex2D(_MainTex, i.uv23.zw);
                color += 0.05 * tex2D(_MainTex, i.uv45.xy);
                color += 0.05 * tex2D(_MainTex, i.uv45.zw);
                return color;
            }
            ENDCG
        }
    }
}
