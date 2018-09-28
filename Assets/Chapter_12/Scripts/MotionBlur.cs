using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MotionBlur : OnRenderImageBase
{

    
    protected override void ProcessMat(Material mat)
    {

    }

    [Range(0.0f, 0.9f)]
    public float blurAmount = 0.5f;
    RenderTexture accumulationTexture;

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat != null)
        {
            // Create the accumulation texture
            if (accumulationTexture == null || accumulationTexture.width != src.width || accumulationTexture.height != src.height)
            {
                DestroyImmediate(accumulationTexture);
                accumulationTexture = new RenderTexture(src.width, src.height, 0);
                accumulationTexture.hideFlags = HideFlags.HideAndDontSave;
                Graphics.Blit(src, accumulationTexture);
            }

            // We are accumulating motion over frames without clear/discard
            // by design, so silence any performance warnings from Unity
            accumulationTexture.MarkRestoreExpected();

            mat.SetFloat("_BlurAmount", 1.0f - blurAmount);

            Graphics.Blit(src, accumulationTexture, mat);
            Graphics.Blit(accumulationTexture, dest);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }

    void OnDisable()
    {
        DestroyImmediate(accumulationTexture);
    }

}
