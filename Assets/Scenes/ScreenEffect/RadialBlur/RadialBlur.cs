using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RadialBlur : PostEffectsBase
{
    public Shader radialBlurShader;
    private Material radialBlurMaterial = null;

    public Material material
    {
        get
        {
            radialBlurMaterial = CheckShaderAndCreateMaterial(radialBlurShader, radialBlurMaterial);
            return radialBlurMaterial;
        }
    }

    // [Header("降采样")] [Range(0, 5)] public int downSample = 1;
    [Header("模糊程度")] [Range(0, 0.05f)] public float radialRadius = 1;

    [Header("模糊中心")] public Vector2 blurCenter = new Vector2(0.5f, 0.5f);
    // [Header("迭代")] [Range(0, 5)] public int iteration = 1;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            material.SetVector("_BlurCenter", new Vector4(blurCenter.x, blurCenter.y, 0, 0));
            material.SetFloat("_BlurFactor", radialRadius);
            Graphics.Blit(source, destination, material);

            // RenderTexture rt1 = RenderTexture.GetTemporary(source.width >> downSample, source.height >> downSample, 0,
            //     source.format);
            // RenderTexture rt2 = RenderTexture.GetTemporary(source.width >> downSample, source.height >> downSample, 0,
            //     source.format);
            //
            // Graphics.Blit(source, rt1);
            // for (int i = 0; i < iteration; ++i)
            // {
            //     material.SetVector("_Offsets", new Vector4(graussianRadius, 0, 0, 0));
            //     Graphics.Blit(rt1, rt2);
            //     material.SetVector("_Offsets", new Vector4(0, graussianRadius, 0, 0));
            //     Graphics.Blit(rt2, rt1);
            // }

            // Graphics.Blit(rt1, destination);
            // RenderTexture.ReleaseTemporary(rt1);
            // RenderTexture.ReleaseTemporary(rt2);
        }
    }
}