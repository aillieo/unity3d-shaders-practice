using UnityEngine;
using System.Collections;

public class EdgeDetectNormalsAndDepth : OnRenderImageBase
{

	[Range(0.0f, 1.0f)]
	public float edgesOnly = 0.0f;

	public Color edgeColor = Color.black;

	public Color backgroundColor = Color.white;

	public float sampleDistance = 1.0f;

	public float sensitivityDepth = 1.0f;

	public float sensitivityNormals = 1.0f;
	
	void OnEnable() {
		GetComponent<Camera>().depthTextureMode |= DepthTextureMode.DepthNormals;
	}

	[ImageEffectOpaque]
	void OnRenderImage (RenderTexture src, RenderTexture dest) {
		if (mat != null) {
            ProcessMat(mat);
			Graphics.Blit(src, dest, mat);
		} else {
			Graphics.Blit(src, dest);
		}
	}

    protected override void ProcessMat(Material mat)
    {
        mat.SetFloat("_EdgeOnly", edgesOnly);
        mat.SetColor("_EdgeColor", edgeColor);
        mat.SetColor("_BackgroundColor", backgroundColor);
        mat.SetFloat("_SampleDistance", sampleDistance);
        mat.SetVector("_Sensitivity", new Vector4(sensitivityNormals, sensitivityDepth, 0.0f, 0.0f));

    }
}
