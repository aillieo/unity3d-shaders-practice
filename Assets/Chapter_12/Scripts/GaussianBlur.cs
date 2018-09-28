using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : OnRenderImageBase
{


    [Range(0, 4)]
    public int iterations = 3;
    [Range(0.2f, 3.0f)]
    public float blurSpread = 0.6f;
    [Range(1, 8)]
    public int downSample = 2;
    
    protected override void ProcessMat(Material mat)
    {
        
    }


    // 这里是必须要blit两次了
    // shader里边 两个pass 如果顺序走下来 其实是后边的会覆盖掉前边的
    // 因为第二个pass 其实是拿原始的顶点和像素来绘制的
    // 因此 必须把第一个pass（vertical）走下来之后 保存到buffer中
    // 再拿第一个pass绘制的结果 blit一次 使用第二个pass（horizontal）
    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat != null)
        {
            int rtW = src.width / downSample;
            int rtH = src.height / downSample;

            RenderTexture buffer0 = RenderTexture.GetTemporary(rtW, rtH, 0);
            buffer0.filterMode = FilterMode.Bilinear;

            Graphics.Blit(src, buffer0);

            for (int i = 0; i < iterations; i++)
            {
                mat.SetFloat("_BlurSize", 1.0f + i * blurSpread);

                RenderTexture buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                // Render the vertical pass
                Graphics.Blit(buffer0, buffer1, mat, 0);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
                buffer1 = RenderTexture.GetTemporary(rtW, rtH, 0);

                // Render the horizontal pass
                Graphics.Blit(buffer0, buffer1, mat, 1);

                RenderTexture.ReleaseTemporary(buffer0);
                buffer0 = buffer1;
            }

            Graphics.Blit(buffer0, dest);
            RenderTexture.ReleaseTemporary(buffer0);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

}
