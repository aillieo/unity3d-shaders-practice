using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetectionSobel : OnRenderImageBase
{

    [Range(0.0f, 1.0f)]
    public float edgesOnly = 0.0f;
    public Color edgeColor = Color.black;
    public Color backgroundColor = Color.white;

    protected override void ProcessMat(Material mat)
    {
        mat.SetFloat("_EdgeOnly", edgesOnly);
        mat.SetColor("_EdgeColor", edgeColor);
        mat.SetColor("_BackgroundColor", backgroundColor);
    }
}
