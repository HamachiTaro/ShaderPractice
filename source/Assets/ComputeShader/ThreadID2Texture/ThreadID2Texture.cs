using UnityEngine;

public class ThreadID2Texture : MonoBehaviour
{

    [SerializeField] private ComputeShader _computeShader;

    [SerializeField] private GameObject _target;
    
    void Start()
    {
        var renderTexture = new RenderTexture(512,512,0, RenderTextureFormat.ARGB32);
        renderTexture.enableRandomWrite = true;
        renderTexture.Create();
        
        var kernelIndex = _computeShader.FindKernel("CSMain");
        _computeShader.SetTexture(kernelIndex, "ResultBuffer", renderTexture);
        _computeShader.Dispatch(kernelIndex, 64, 64 ,1);
        
        _target.GetComponent<Renderer>().material.mainTexture = renderTexture;
    }
    
}
