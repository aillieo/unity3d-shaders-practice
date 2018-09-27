using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class BrightnessSaturationContrast : OnRenderImageBase {

    [Range(0.0f, 3.0f)]
    public float brightness = 1.0f;
    [Range(0.0f, 3.0f)]
    public float saturation = 1.0f;
    [Range(0.0f, 3.0f)]
    public float contrast = 1.0f;

    protected override void ProcessMat(Material mat)
    {
        mat.SetFloat("_Brightness", brightness);
        mat.SetFloat("_Saturation", saturation);
        mat.SetFloat("_Contrast", contrast);
    }
}
