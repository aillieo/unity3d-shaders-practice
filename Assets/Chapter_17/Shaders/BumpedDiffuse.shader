Shader "Custom/Chapter_17/BumpedDiffuse" {
	Properties {
		_Color ("Main Color", Color) = (1,1,1,1)
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_BumpMap ("Normalmap", 2D) = "bump" {}
	}
	SubShader {
		Tags { "RenderType"="Opaque" }
		LOD 300
		
		CGPROGRAM
		#pragma surface surf Lambert
		// 使用surf作为表面着色器函数 使用Lambert光照模型 也可以自定义光照模型（函数）
		// 其它的一些可选参数为：
		// vertext:VertexFunction   finalcolor:ColorFunction 使用自定义的顶点修改函数 和 颜色修改函数
		// addshadow fullforwardshadows noshadow   控制阴影计算的pass
		// alpha/alphatest 控制透明度混合或透明度测试 可以使用 alphatest:VariableName 控制使用那个变量来剔除不满足条件的片段
		// 光照相关 noambient novertexlights noforwardadd 等
		// 光照烘焙或雾 nolightmap nofog 等
		// exclude_path 剔除的渲染路径

		#pragma target 3.0

		sampler2D _MainTex;
		sampler2D _BumpMap;
		fixed4 _Color;


		// 使用 uv_纹理名称 来作为对应的uv
		struct Input {
			float2 uv_MainTex;
			float2 uv_BumpMap;
		};


		// 除了SurfaceOutput之外 可选的还有SurfaceOutputStandard SurfaceOutputStandardSpecular 这两个是PBR使用的
		void surf (Input IN, inout SurfaceOutput o) {
			fixed4 tex = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = tex.rgb * _Color.rgb;
			o.Alpha = tex.a * _Color.a;
			o.Normal = UnpackNormal(tex2D(_BumpMap, IN.uv_BumpMap));
			// 还有 Emission  Specular  Gloss 等
		}
		
		ENDCG
	} 
	
	FallBack "Legacy Shaders/Diffuse"
}