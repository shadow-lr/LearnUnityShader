Shader "Unlit/WaterWave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        // 振幅（控制波浪顶端和底端的高度）
        _Amplitude ("Amplitude", Float) = 1
        // 角速度（控制波浪的周期）
        _AngularVelocity ("AngularVelocity", Float) = 1
        // 频率（控制波浪移动的速度）
        _Frequency ("Frequency", Float) = 1
        // 偏距（设为 0.5 使得波浪垂直居中于屏幕）
        _Offset ("Offset", Float) = 1
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
            float _Amplitude;
            float _AngularVelocity;
            float _Frequency;
            float _Offset;

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

            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);

                // y = A * sin(w * x ± Φ * t) + k
                // 代入正弦曲线公式计算 y 值
                // _Offset 属于 0~1
                float y = _Amplitude * sin(_AngularVelocity * i.uv.x + _Frequency * _Time.y) + (sin(_Time.y) + 1) * 0.5;
                // float y = _Amplitude * sin(_AngularVelocity * i.uv.x + _Frequency * _Time.y) + _Offset;

                // 区分上下部分
                if (i.uv.y >= y)
                {
                    col *= 0.5f;
                }
                return col;
            }
            ENDCG
        }
    }
}