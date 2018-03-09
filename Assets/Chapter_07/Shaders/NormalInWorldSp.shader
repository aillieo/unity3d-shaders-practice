// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter_07/NormalInWorldSp" {
	Properties {
		_Color ("Color Tint", Color) = (1, 1, 1, 1)
		_MainTex ("Main Tex", 2D) = "white" {}
		_BumpMap ("Normal Map", 2D) = "bump" {}
		_BumpScale ("Bump Scale", Float) = 1.0
		_Specular ("Specular", Color) = (1, 1, 1, 1)
		_Gloss ("Gloss", Range(8.0, 256)) = 20
	}
	SubShader {		
		Pass { 
			Tags { "LightMode"="ForwardBase" }
		
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			#include "Lighting.cginc"
			
			fixed4 _Color;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _BumpMap;
			float4 _BumpMap_ST;
			float _BumpScale;
			fixed4 _Specular;
			float _Gloss;
			
			struct a2v {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
				float4 texcoord : TEXCOORD0;
			};
			
			struct v2f {
				float4 pos : SV_POSITION;
				float4 uv : TEXCOORD0;

				float4 T2W_0 : TEXCOORD1;
				float4 T2W_1 : TEXCOORD2;
				float4 T2W_2 : TEXCOORD3;
			};
			
			v2f vert(a2v v) {
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);

				o.uv.xy = v.texcoord.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				o.uv.zw = v.texcoord.xy * _BumpMap_ST.xy + _BumpMap_ST.zw;

				float3 worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
				float3 worldNormal = UnityObjectToWorldNormal(v.normal);
				float3 worldTangent = UnityObjectToWorldDir(v.tangent.xyz);
				float3 worldBitangent = cross(worldNormal, worldTangent) * v.tangent.w;


				o.T2W_0 = float4(worldTangent.x, worldBitangent.x, worldNormal.x, worldPos.x);
				o.T2W_1 = float4(worldTangent.y, worldBitangent.y, worldNormal.y, worldPos.y);
				o.T2W_2 = float4(worldTangent.z, worldBitangent.z, worldNormal.z, worldPos.z);
								
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {

				float3 worldPos = float3(i.T2W_0.x, i.T2W_1.x, i.T2W_2.x);

				fixed3 lightDir = normalize(UnityWorldSpaceLightDir(worldPos));
				fixed3 viewDir = normalize(UnityWorldSpaceViewDir(worldPos));

				fixed4 packedNormal = tex2D(_BumpMap, i.uv.zw);
				fixed3 tangentNormal = UnpackNormal(packedNormal);
				tangentNormal.xy *= _BumpScale;
				tangentNormal.z = sqrt(1.0 - saturate(dot(tangentNormal.xy, tangentNormal.xy)));

				fixed3 worldNormal = fixed3(
					dot(i.T2W_0.xyz, tangentNormal),
					dot(i.T2W_1.xyz, tangentNormal),
					dot(i.T2W_2.xyz, tangentNormal)
				);
				worldNormal = normalize(worldNormal);
				


				fixed3 albedo = tex2D(_MainTex, i.uv.xy).rgb * _Color.rgb;

				fixed3 ambient = UNITY_LIGHTMODEL_AMBIENT.xyz * albedo;
				
				fixed3 diffuse = _LightColor0.rgb * albedo * max(0, dot(worldNormal, lightDir));
				
				fixed3 halfDir = normalize(lightDir + viewDir);
				fixed3 specular = _LightColor0.rgb * _Specular.rgb * pow(max(0, dot(worldNormal, halfDir)), _Gloss);
				
				return fixed4(ambient + diffuse + specular, 1.0);
			}
			
			ENDCG
		}
	} 
	FallBack "Specular"
}
