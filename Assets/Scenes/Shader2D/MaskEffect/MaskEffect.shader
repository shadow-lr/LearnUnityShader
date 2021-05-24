Shader "Unlit/MaskEffect"
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

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float2 _Pos;
            float _Radius;
            float _EdgeBlurLength;

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

            v2f vert(appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed3 createCircle(float2 pos, float radius, float2 uv)
            {
                //当前像素到中心点的距离
                float dis = distance(pos, uv);
                //  smoothstep 平滑过渡, 这里也可以用 step 代替。

                // dis * dis * (3 - 2 * dis)
                // 0.008
                float col = smoothstep(radius + _EdgeBlurLength, radius, dis);
                return fixed3(col, col, col);
            }

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed3 mask = createCircle(_Pos, _Radius, i.uv);
                return col * fixed4(mask, 1.0);
            }
            ENDCG
        }
    }
}