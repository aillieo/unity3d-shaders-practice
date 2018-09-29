// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter_13/DisplayDepth" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		CGINCLUDE
		
		#include "UnityCG.cginc"
		
		sampler2D _MainTex;
		sampler2D _CameraDepthTexture;
		
		struct v2f {
			float4 pos : SV_POSITION;
			half2 uv: TEXCOORD0;
		};
		  
		v2f vert(appdata_img v) {
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			
			o.uv = v.texcoord;
			
			return o;
		}
		
		fixed4 frag(v2f i) : SV_Target {
			//fixed4 c = tex2D(_MainTex, i.uv);
			
			float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, i.uv);
			float linearDepth = Linear01Depth(depth);
			return fixed4(linearDepth,linearDepth,linearDepth,1.0);
		}

		ENDCG
		
		Pass { 
			ZTest Always Cull Off ZWrite Off
			
			CGPROGRAM      
			
			#pragma vertex vert  
			#pragma fragment frag
			
			ENDCG  
		}
	} 
	FallBack Off
}
