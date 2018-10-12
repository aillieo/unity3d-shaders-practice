// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/Chapter_13/DisplayNormals" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
	}
	SubShader {
		CGINCLUDE
		
		#include "UnityCG.cginc"
		
		sampler2D _MainTex;
		sampler2D _CameraDepthNormalsTexture;
		
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
			
			fixed3 normal = DecodeViewNormalStereo(tex2D(_CameraDepthNormalsTexture, i.uv));
			return fixed4(normal * 0.5 + 0.5 ,1.0);
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
