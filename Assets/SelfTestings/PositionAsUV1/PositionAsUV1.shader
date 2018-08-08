Shader "Custom/ShaderPosAsUV1"     
{     
    Properties     
    {     
        [PerRendererData] _MainTex ("Sprite Texture", 2D) = "white" {}
        [PerRendererData] _AlphaTex("Sprite Alpha Texture", 2D) = "white" {}
        _ExtraTex ("Extra Texture", 2D) = "white" {}                    /* ! */
        _ExtraTexSize ("Extra Texture Size", Vector) = (100,100,0,0)    /* ! */
        _Color ("Tint", Color) = (1,1,1,1)

        // required for UI.Mask
        _StencilComp ("Stencil Comparison", Float) = 8
        _Stencil ("Stencil ID", Float) = 0
        _StencilOp ("Stencil Operation", Float) = 0
        _StencilWriteMask ("Stencil Write Mask", Float) = 255
        _StencilReadMask ("Stencil Read Mask", Float) = 255
        _ColorMask ("Color Mask", Float) = 15

    }     
     
    SubShader     
    {     
        Tags     
        {      
            "Queue"="Transparent"      
            "IgnoreProjector"="True"      
            "RenderType"="Transparent"      
            "PreviewType"="Plane"     
            "CanUseSpriteAtlas"="True"     
        }     

        Blend SrcAlpha OneMinusSrcAlpha  
        ZWrite Off
        
        // required for UI.Mask
        Stencil
        {
             Ref [_Stencil]
             Comp [_StencilComp]
             Pass [_StencilOp] 
             ReadMask [_StencilReadMask]
             WriteMask [_StencilWriteMask]
        }
        ColorMask [_ColorMask]

        Pass     
        {     
            CGPROGRAM     
            #pragma vertex vert     
            #pragma fragment frag     
            #include "UnityCG.cginc"     
                 
            struct appdata_t     
            {     
                float4 vertex   : POSITION;     
                float4 color    : COLOR;     
                float2 texcoord : TEXCOORD0;     
                float2 texcoord_uv1 : TEXCOORD1;    /* ! */
            };     
     
            struct v2f     
            {     
                float4 vertex   : SV_POSITION;     
                fixed4 color    : COLOR;     
                half2 texcoord  : TEXCOORD0;
                half2 texcoord_uv1  : TEXCOORD1;    /* ! */
            };     
               
            sampler2D _MainTex;
            sampler2D _AlphaTex;
            fixed4 _Color;     
            sampler2D _ExtraTex;    /* ! */
            fixed4 _ExtraTexSize;   /* ! */
                
            v2f vert(appdata_t IN)     
            {
                v2f OUT;     
                OUT.vertex = UnityObjectToClipPos(IN.vertex);     
                OUT.texcoord = IN.texcoord;   
                OUT.texcoord_uv1 = IN.texcoord_uv1;     /* ! */
#ifdef UNITY_HALF_TEXEL_OFFSET     
                OUT.vertex.xy -= (_ScreenParams.zw-1.0);     
#endif     
                OUT.color = IN.color * _Color;     
                return OUT;  
            }  
     
            fixed4 frag(v2f IN) : SV_Target     
            {     
                //fixed4 alphaTex = tex2D(_AlphaTex, IN.texcoord);
                //fixed4 finalTex = tex2D(_MainTex, IN.texcoord);

                IN.texcoord_uv1.x /= _ExtraTexSize.x;   /* ! */
                IN.texcoord_uv1.y /= _ExtraTexSize.y;   /* ! */

                fixed4 extraTex = tex2D(_ExtraTex,IN.texcoord_uv1);     /* ! */

                return extraTex;

            }     
            ENDCG     
        }     
    }     
}