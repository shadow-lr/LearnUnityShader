using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Mask : PostEffectsBase
{
    // shader
    public Shader myShader;

    // 遮罩大小
    [Range(0.01f, 10f), Tooltip("遮罩大小")] public float size = 5.0f;

    // 边缘模糊程度
    [Range(0.0001f, 0.1f), Tooltip("边缘模糊程度")]
    public float edgeBlurLength = 0.05f;

    // 遮罩中心位置
    public Vector2 pos = new Vector2(0.5f, 0.5f);

    // 半径
    [Range(0, 1.0f), Tooltip("半径")] public float radius = 0.2f;

    // 材质
    private Material mat = null;

    private Material material
    {
        get
        {
            mat = CheckShaderAndCreateMaterial(myShader, mat);
            return mat;
        }
    }

    private void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (material)
        {
            // 把鼠标坐标传递给shader
            // material.SetVector("_Pos", pos);
            material.SetVector("_Pos", pos);
            material.SetFloat("_Radius", radius);
            material.SetFloat("_EdgeBlurLength", edgeBlurLength);
            Graphics.Blit(source, destination, material);
        }
        else
        {
            Graphics.Blit(source, destination);
        }
    }

    private void Update()
    {
        if (Input.GetMouseButton(0))
        {
            Vector2 mousePos = Input.mousePosition;
            pos = new Vector2(mousePos.x / Screen.width, mousePos.y / Screen.height);
        }
    }
}