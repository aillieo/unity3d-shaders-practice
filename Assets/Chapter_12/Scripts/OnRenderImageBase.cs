using System.Collections;
using System.Collections.Generic;
using UnityEngine;


[ExecuteInEditMode]
[RequireComponent(typeof(Camera))]
public abstract class OnRenderImageBase : MonoBehaviour
{

	void Start () {
        enabled = SystemInfo.supportsImageEffects;
	}


    public Shader shader;

    Material cachedMat = null;
    protected Material mat
    {
        get
        {
            if (null == cachedMat)
            {
                cachedMat = CreateMat();
            }
            return cachedMat;
        }
    }


    virtual protected Material CreateMat()
    {
        return CreateMatWithShader(shader);
    }

    protected Material CreateMatWithShader(Shader s)
    {
        if (null != s)
        {
            if (s.isSupported)
            {
                Material mat = new Material(s);
                mat.hideFlags = HideFlags.DontSave;
                return mat;
            }
            else
            {
                Debug.LogError("Shader " + s.name + "is NOT supported");
            }
        }
        return null;
    }


    abstract protected void ProcessMat(Material mat);

    void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        if (mat != null)
        {
            ProcessMat(mat);
            Graphics.Blit(src, dest, mat);
        }
        else
        {
            Graphics.Blit(src, dest);
        }
    }
}
