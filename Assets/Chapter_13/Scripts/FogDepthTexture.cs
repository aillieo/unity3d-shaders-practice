using UnityEngine;
using System.Collections;

public class FogDepthTexture : OnRenderImageBase
{
    Camera m_cam;
    Camera cam
    {
        get
        {
            if (m_cam == null)
            {
                m_cam = GetComponent<Camera>();
            }
            return m_cam;
        }
    }
    Transform cameraTransform
    {
        get 
        {
            return transform;
        }
    }

	[Range(0.0f, 3.0f)]
	public float fogDensity = 1.0f;

	public Color fogColor = Color.white;

	public float fogStart = 0.0f;
	public float fogEnd = 2.0f;

	void OnEnable() {
		cam.depthTextureMode |= DepthTextureMode.Depth;
	}

    protected override void ProcessMat(Material mat)
    {
        Matrix4x4 frustumCorners = Matrix4x4.identity;

        float fov = cam.fieldOfView;
        float near = cam.nearClipPlane;
        float aspect = cam.aspect;

        float halfHeight = near * Mathf.Tan(fov * 0.5f * Mathf.Deg2Rad);
        Vector3 toRight = cameraTransform.right * halfHeight * aspect;
        Vector3 toTop = cameraTransform.up * halfHeight;

        Vector3 topLeft = cameraTransform.forward * near + toTop - toRight;
        float scale = topLeft.magnitude / near;

        topLeft.Normalize();
        topLeft *= scale;

        Vector3 topRight = cameraTransform.forward * near + toRight + toTop;
        topRight.Normalize();
        topRight *= scale;

        Vector3 bottomLeft = cameraTransform.forward * near - toTop - toRight;
        bottomLeft.Normalize();
        bottomLeft *= scale;

        Vector3 bottomRight = cameraTransform.forward * near + toRight - toTop;
        bottomRight.Normalize();
        bottomRight *= scale;

        frustumCorners.SetRow(0, bottomLeft);
        frustumCorners.SetRow(1, bottomRight);
        frustumCorners.SetRow(2, topRight);
        frustumCorners.SetRow(3, topLeft);

        mat.SetMatrix("_FrustumCornersRay", frustumCorners);

        mat.SetFloat("_FogDensity", fogDensity);
        mat.SetColor("_FogColor", fogColor);
        mat.SetFloat("_FogStart", fogStart);
        mat.SetFloat("_FogEnd", fogEnd);
    }

}
