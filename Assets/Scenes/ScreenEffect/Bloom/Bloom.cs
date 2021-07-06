using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

/*
 * 根据一个阈值提取出图像中的较亮区域，把它们存储在一张渲染纹理中，再利用高斯模糊对这张渲染纹理进行模糊处理，模拟光线扩散的效果，最后再将其和原图像进行混合，得到最终效果
 */
public class Bloom : PostEffectsBase
{
    public Shader bloomShader;
    public Material bloomMaterial = null;

    public Material material
    {
        get
        {
            bloomMaterial = CheckShaderAndCreateMaterial(bloomShader, bloomMaterial);
            return bloomMaterial;
        }
    }

    [Header("迭代次数")] [Range(0, 4)] public int iterations = 3;
    [Header("曝光强度")] [Range(0.2f, 3.0f)] public float blurSpread = 0.6f;

    [Header("采样数")] [Range(1, 8)] public int downSample = 2;

    [Header("像素的亮度值")] [Range(0.0f, 4.0f)] public float luminanceThreshold = 0.6f;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            // material.SetFloat("_EdgeOnly", edgesOnly);
            // material.SetColor("_EdgeColor", edgeColor);
            // material.SetColor("_BackgroundColor", backgroundColor);

            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }
}