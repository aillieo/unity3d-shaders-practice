using UnityEngine;
using System.Collections;

public class Bloom : OnRenderImageBase
{

    [Range(0, 4)]
    public int iterations = 3;
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;
    [Range(1, 8)]
    public int downSample = 2;
    [Range(0.0f, 4.0f)]
    public float luminanceThreshold = 0.6f;


    protected override void ProcessMat(Material mat)
    {

    }


    public Shader gaussianBlurShader;
    Material cachedGaussianBlurMat = null;
    Material gaussianBlurMat
    {
        get
        {
            if (null == cachedGaussianBlurMat)
            {
                cachedGaussianBlurMat = CreateMatWithShader(gaussianBlurShader);
            }
            return cachedGaussianBlurMat;
        }
    }

	void OnRenderImage (RenderTexture src, RenderTexture dest) 
    {
        if (mat != null && gaussianBlurMat != null)
        {

            // 主要有以下步骤
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;


            // 1.提取高亮区域 放入buffer
            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;
            mat.SetFloat("_LuminanceThreshold", luminanceThreshold);
            Graphics.Blit(src, buffer0, mat, 0);


            // 2.图像高斯模糊
            for (int i = 0; i < iterations; i++)
            {
                gaussianBlurMat.SetFloat("_BlurSize", 1.0f + i * blurSpread);

                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                // Render the vertical pass
                Graphics.Blit(buffer0, buffer1, gaussianBlurMat, 0);
                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);
                // Render the horizontal pass
                Graphics.Blit(buffer0, buffer1, gaussianBlurMat, 1);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }

            // 3.混合
            mat.SetTexture("_Bloom", buffer0);
            Graphics.Blit(src, dest, mat, 1);

            RenderTexture.ReleaseTemporary(buffer0);

        }
        else
        {
            Graphics.Blit(src, dest);
        }
	}
}
