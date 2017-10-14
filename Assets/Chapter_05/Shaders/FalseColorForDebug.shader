﻿Shader "Custom/Chapter_05/FalseColorForDebug" {
SubShader {
		Pass {
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			#include "UnityCG.cginc"
			
			struct v2f {
				float4 pos : SV_POSITION;
				fixed4 color : COLOR0;
			};
			
			v2f vert(appdata_full v) {
				v2f o;
				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				
				// case 1 : Visualize normal
				o.color = fixed4(v.normal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				
				// case 2 : Visualize tangent
				o.color = fixed4(v.tangent.xyz * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				
				// case 3 : Visualize binormal
				fixed3 binormal = cross(v.normal, v.tangent.xyz) * v.tangent.w;
				o.color = fixed4(binormal * 0.5 + fixed3(0.5, 0.5, 0.5), 1.0);
				
				// case 4 : Visualize the first set texcoord
				o.color = fixed4(v.texcoord.xy, 0.0, 1.0);
				
				// case 5 : Visualize the second set texcoord
				o.color = fixed4(v.texcoord1.xy, 0.0, 1.0);
				
				// case 6 : Visualize fractional part of the first set texcoord
				o.color = frac(v.texcoord);
				if (any(saturate(v.texcoord) - v.texcoord)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;
				
				// case 7 : Visualize fractional part of the second set texcoord
				o.color = frac(v.texcoord1);
				if (any(saturate(v.texcoord1) - v.texcoord1)) {
					o.color.b = 0.5;
				}
				o.color.a = 1.0;
				
				// case 8 : Visualize vertex color
				//o.color = v.color;
				
				return o;
			}
			
			fixed4 frag(v2f i) : SV_Target {
				return i.color;
			}
			
			ENDCG
		}
	}
}