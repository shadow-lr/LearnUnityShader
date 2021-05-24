Shader "Custom/Dissolve_Sphere"
{
    Properties
    {
		_Color ("Color", Color) = (1,1,1,1)
		[HDR]_Emission ("Emission", Color) = (0,0,0,0)
		_MainTex ("Albedo", 2D) = "white" {}
		[HDR]_EdgeColor1 ("Edge Color", Color) = (1,1,1,1)
		_Noise ("Noise", 2D) = "white" {}
		[Toggle] _Use_Gradient ("Use Gradient?", Float) = 1
		_Gradient ("Gradient", 2D) = "white" {}
		_Glossiness ("Smoothness", Range(0,1)) = 0.5
		_Metallic ("Metallic", Range(0,1)) = 0.0
		[PerRendererData]_Cutoff ("Cutoff", Range(0,1)) = 0.0
		_EdgeSize ("EdgeSize", Range(0,1)) = 0.2
		_cutoff ("cutoff", Range(0,1)) = 0.0
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

        Cull Off
        LOD 200

        CGPROGRAM

		// Physically based Standard lighting model, and enable shadows on all light types
		#pragma surface surf Standard fullforwardshadows vertex:vert addshadow 

		// Use shader model 3.0 target, to get nicer looking lighting
		#pragma target 3.0
		#pragma multi_compile __ _USE_GRADIENT_ON

		sampler2D _MainTex;
		sampler2D _Noise;
		sampler2D _Gradient;

		struct Input {
			float2 uv_Noise;
			float2 uv_MainTex;
			fixed4 color : COLOR0;
			float3 worldPos;
		};

		half _Glossiness, _Metallic, _Cutoff, _EdgeSize;
		half _cutoff;
		half4 _Color, _EdgeColor1, _Emission;

        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void vert (inout appdata_full v, out Input o) {
        	UNITY_INITIALIZE_OUTPUT(Input, o);
        	float3 pos = mul((float3x3)unity_ObjectToWorld, v.vertex.xyz);
        	//pos.x += _cutoff*5;
        	float4 tex = tex2Dlod(_Noise, float4(pos, 0) * 0.5);
    
        	float4 Gradient = tex2Dlod (_Gradient, float4(v.texcoord.xy, 0, 0));
        	float mask = smoothstep(_Cutoff, _Cutoff - 0.3, 1 - Gradient);
    	  }

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
			half3 Noise = tex2D (_Noise, IN.uv_Noise);
			Noise.r = saturate(Noise.r);
			_cutoff  = lerp(0, _cutoff + _EdgeSize, _cutoff);

			//smoothstep(x) =  x * x (3 - 2 * x)
			half Edge = smoothstep(_cutoff + _EdgeSize, _cutoff, clamp(Noise.r, _EdgeSize, 1));

			fixed4 c = tex2D (_MainTex, IN.uv_MainTex);
			fixed3 EmissiveCol = c.a * _Emission;

			o.Albedo = _Color;
			o.Emission = EmissiveCol + _EdgeColor1 * Edge;
			clip(Noise - _cutoff);
        }
        ENDCG
    }
    FallBack "Diffuse"
}
