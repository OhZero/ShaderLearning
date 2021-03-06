﻿Shader "Custom/Lambert"{

	Properties{	//属性设置
		_EmissiveColor("Emissive Color", Color) = (1,1,1,1)
		_AmbientColor("Ambient Color", Color) = (1,1,1,1)
		_PowValue("Pow Value", Range(0, 5)) = 1.0
	}

	SubShader{
		Tags{"RenderType"="Opaque"}
		LOD 200

		CGPROGRAM
		#pragma surface surf CustomLambert

		float4 _EmissiveColor;
		float4 _AmbientColor;
		float _PowValue;

		struct Input {
			float2 uv_MainTex;
		};

		//Lambert光照实现
		inline float4 LightingCustomLambert(SurfaceOutput s, fixed3 lightDir, fixed atten)
		{
			float diffuseLight = max(0, dot(s.Normal, lightDir));
			float4 color;

			color.rgb = s.Albedo * _LightColor0.rgb * (diffuseLight * atten * 2);//atten衰减系数
			color.a = s.Alpha;
			return color;
		}

		void surf(Input IN, inout SurfaceOutput o)
		{
			float4 c;
			c = pow((_EmissiveColor + _AmbientColor), _PowValue);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
	ENDCG
	}
	FallBack "Diffuse"
}