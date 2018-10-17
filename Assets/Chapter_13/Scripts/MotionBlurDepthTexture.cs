using UnityEngine;
using System.Collections;

public class MotionBlurDepthTexture : OnRenderImageBase
{

	void OnEnable() {
        cam.depthTextureMode |= DepthTextureMode.Depth;
        previousViewProjectionMatrix = cam.projectionMatrix * cam.worldToCameraMatrix;
    }


    protected override void ProcessMat(Material mat)
    {

    }


    Camera m_cam;
    Camera cam { 
        get 
        {
            if(m_cam == null)
            {
                m_cam = GetComponent<Camera>();
            }
            return m_cam; 
        }
    }

    
    [Range(0.0f, 1.0f)]
    public float blurSize = 0.5f;
    private Matrix4x4 previousViewProjectionMatrix;


    [ImageEffectOpaque]
	void OnRenderImage (RenderTexture src, RenderTexture dest) {
		if (mat != null) {
            mat.SetFloat("_BlurSize", blurSize);

            mat.SetMatrix("_PreviousViewProjectionMatrix", previousViewProjectionMatrix);
            Matrix4x4 currentViewProjectionMatrix = cam.projectionMatrix * cam.worldToCameraMatrix;
            Matrix4x4 currentViewProjectionInverseMatrix = currentViewProjectionMatrix.inverse;
            mat.SetMatrix("_CurrentViewProjectionInverseMatrix", currentViewProjectionInverseMatrix);
            previousViewProjectionMatrix = currentViewProjectionMatrix;

            Graphics.Blit(src, dest, mat);
		} else {
			Graphics.Blit(src, dest);
		}
	}


    Vector3 delta = new Vector3(0.05f,0,0);
    void Update()
    {
        if (transform.localPosition.x > 2)
        {
            delta.x = - 0.05f;
        }
        else if (transform.localPosition.x < -2)
        {
            delta.x = 0.05f;
        }
        transform.localPosition += delta;
    }

}
