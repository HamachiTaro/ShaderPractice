using UnityEngine;

/// <summary>
/// OnGUIを用いてScreenにTextureを描く。
/// </summary>
public class DrawOnScreen : MonoBehaviour
{
    [SerializeField] private ComputeShader _computeShader;

    private RenderTexture _renderTexture;

    void Start()
    {
        _renderTexture = new RenderTexture(Screen.width, Screen.height, 0, RenderTextureFormat.ARGB32);
        _renderTexture.enableRandomWrite = true;
        _renderTexture.Create();

        var kernelIndex = _computeShader.FindKernel("CSMain");
        _computeShader.SetTexture(kernelIndex, "ResultBuffer", _renderTexture);
        _computeShader.SetVector("ScreenSize", new Vector2(Screen.width, Screen.height));

        _computeShader.GetKernelThreadGroupSizes(kernelIndex, out var sizeX, out var sizeY, out var sizeZ);

        _computeShader.Dispatch(kernelIndex, (int) (Screen.width / sizeX) + 1, (int) (Screen.height / sizeY) + 1, 1);
    }

    private void OnGUI()
    {
        GUI.DrawTexture(new Rect(0, 0, Screen.width, Screen.height), _renderTexture);
    }
}