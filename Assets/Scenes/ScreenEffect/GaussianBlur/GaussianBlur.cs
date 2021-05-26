using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.Timeline;

public class GaussianBlur : PostEffectsBase
{
    public Shader gaussianBlurShader;
    private Material gaussianBlurMaterial = null;

    public Material material
    {
        get
        {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial(gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }

    [Header("降采样")] [Range(0, 5)] public int downSample = 1;
    [Header("模糊半径")] [Range(0, 5)] public int graussianRadius = 1;
    [Header("迭代")] [Range(0, 5)] public int iteration = 1;


    void Start()
    {
    }

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            RenderTexture rt1 = RenderTexture.GetTemporary(source.width >> downSample, source.height >> downSample, 0,
                source.format);

            RenderTexture rt2 = RenderTexture.GetTemporary(source.width >> downSample, source.height >> downSample, 0,
                source.format);

            Graphics.Blit(source, rt1);
            for (int i = 0; i < iteration; ++i)
            {
                material.SetVector("_Offsets", new Vector4(graussianRadius, 0, 0, 0));
                Graphics.Blit(rt1, rt2, material);
                material.SetVector("_Offsets", new Vector4(0, graussianRadius, 0, 0));
                Graphics.Blit(rt2, rt1, material);
            }

            Graphics.Blit(rt1, destination);
            RenderTexture.ReleaseTemporary(rt1);
            RenderTexture.ReleaseTemporary(rt2);
        }
    }
}