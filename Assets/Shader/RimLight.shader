Shader "Custom/RimLight"
{
	Properties
	{
		_TintColor ("Tint Color", Color) = (0,0,0,1)
		_RimColor ("Rim Color", Color) = (1,1,1,1)
		_RimPower ("Rim Power", Range(0.0001, 3.0)) = 0.1
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

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
			};

			struct v2f
			{
				float4 vertex : SV_POSITION;
				float3 worldNormal : TEXCOORD0;
				float3 worldViewDir : TEXCOORD1;
			};

			fixed4 _RimColor;
			fixed4 _TintColor;
			float _RimPower;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = mul(UNITY_MATRIX_MVP, v.vertex);
				o.worldNormal = mul(v.normal, (float3x3)_World2Object);
				float3 worldPos = mul(_Object2World, v.vertex).xyz;
				o.worldViewDir = _WorldSpaceCameraPos.xyz - worldPos;
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				fixed4 col;
				float3 worldViewDir = normalize(i.worldViewDir);
				float3 worldNormal = normalize(i.worldNormal);
				float rim = 1 - max(0, dot(worldViewDir, worldNormal));
				fixed3 rimColor = _RimColor * pow(rim, 1/_RimPower);
				col.rgb = _TintColor + rimColor;
				return col;
			}
			ENDCG
		}
	}
}
