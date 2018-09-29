using UnityEngine;
using System.Collections;

public class DisplayNormals : OnRenderImageBase
{

	void OnEnable() {
        GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
    }


    protected override void ProcessMat(Material mat)
    {

    }


    [ImageEffectOpaque]
	void OnRenderImage (RenderTexture src, RenderTexture dest) {
		if (mat != null) {
			Graphics.Blit(src, dest, mat);
		} else {
			Graphics.Blit(src, dest);
		}
	}
}
