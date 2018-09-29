using UnityEngine;
using System.Collections;

public class DisplayDepth : OnRenderImageBase
{

	void OnEnable() {
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.Depth;
	}


    protected override void ProcessMat(Material mat)
    {

    }

	void OnRenderImage (RenderTexture src, RenderTexture dest) {
		if (mat != null) {
			Graphics.Blit(src, dest, mat);
		} else {
			Graphics.Blit(src, dest);
		}
	}
}
