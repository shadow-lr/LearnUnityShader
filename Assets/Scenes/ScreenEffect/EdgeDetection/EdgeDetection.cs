using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class EdgeDetection : PostEffectsBase
{
    public Shader edgeDetectionShader;
    public Material edgeDetectionMaterial = null;

    public Material material
    {
        get
        {
            edgeDetectionMaterial = CheckShaderAndCreateMaterial(edgeDetectionShader, edgeDetectionMaterial);
            return edgeDetectionMaterial;
        }
    }

    [Header("边缘线强度")] [Range(0.0f, 1.0f)] public float edgesOnly = 0.0f;
    [Header("描边颜色")] public Color edgeColor = Color.black;
    [Header("背景颜色")] public Color backgroundColor = Color.white;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetFloat("_EdgeOnly", edgesOnly);
            material.SetColor("_EdgeColor", edgeColor);
            material.SetColor("_BackgroundColor", backgroundColor);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}