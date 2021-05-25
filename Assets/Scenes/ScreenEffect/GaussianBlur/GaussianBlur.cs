using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class GaussianBlur : PostEffectsBase
{
    public Shader gaussianBlurShader;
    private Material gaussianBlurMaterial = null;

    public Material material {
        get {
            gaussianBlurMaterial = CheckShaderAndCreateMaterial (gaussianBlurShader, gaussianBlurMaterial);
            return gaussianBlurMaterial;
        }
    }

    // 降采样
    [Header("降采样")]
    [Range(1, 5)]
    public int downSample = 2;

    // 模糊半价
    [Header ("模糊半价")]
    [Range (0.2f, 3.0f)]
    public float BlurRadius = 1.0f;

    [Header ("迭代次数")]
    [Range (0, 4)]
    public int iteration = 1;

    void Start()
    {
        
    }
    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material){
            RenderTexture rt1 = RenderTexture.GetTemporary (source.width >> downSample, source.height >> downSample, 0, source.format);
            RenderTexture rt2 = RenderTexture.GetTemporary (source.width >> downSample, source.height >> downSample, 0, source.format);
            
            // 直接将原图拷贝到降分辨率的RT上
            Graphics.Blit(source, rt1);

            for (int i = 0 ; i < iteration; i ++)
            {
                material.SetVector("_Offsets", new Vector4(0, BlurRadius, 0, 0));
                Graphics.Blit(rt1, rt2, material);
                material.SetVector("_Offsets", new Vector4(BlurRadius, 0, 0, 0));
                Graphics.Blit(rt2, rt1, material);
            }

            Graphics.Blit(rt1, destination);

            //释放申请的RenderBuffer
            RenderTexture.ReleaseTemporary (rt1);
            RenderTexture.ReleaseTemporary (rt2);
        }
    }
}
