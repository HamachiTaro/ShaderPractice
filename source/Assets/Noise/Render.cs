using UnityEngine;

public class Render : MonoBehaviour
{
    [SerializeField] private Material mat = default;
    
    private void OnRenderImage(RenderTexture src, RenderTexture dest)
    {
        Graphics.Blit(null, dest, mat);
    }
}
