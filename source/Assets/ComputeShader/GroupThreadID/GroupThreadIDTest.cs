using System.Runtime.InteropServices;
using UnityEngine;

/// <summary>
/// https://docs.microsoft.com/en-us/windows/win32/direct3dhlsl/sv-groupthreadid
/// </summary>
public class GroupThreadIDTest : MonoBehaviour
{
    [SerializeField] private ComputeShader _computeShader = default;

    private void Start()
    {
        var kernelIndex = _computeShader.FindKernel("CSMain");

        // バッファを作成してComputeShaderにセットする。
        // ComputeBuffer側で[numthreads(8,8,1)]とスレッド数を8 x 8 x 1 = 64個に指定しているのでcountは64となる。
        // Vector3型64個分のバッファを確保している。
        var buffer = new ComputeBuffer(64, Marshal.SizeOf(typeof(Vector3)));
        // ComputeBuffer側に宣言してあるResultBufferとバッファを結び付ける。
        _computeShader.SetBuffer(kernelIndex, "ResultBuffer", buffer);

        // ComputeShaderを実行する。スレッドグループ数は1 x 1 x 1 = 1
        _computeShader.Dispatch(kernelIndex, 1, 1, 1);

        // ComputeShaderの結果を取得するための配列。
        var result = new Vector3[64];
        // 結果はGetDataで取得
        buffer.GetData(result);

        foreach (var x in result)
        {
            Debug.Log(x);
        }
        // 使い終わったバッファは解放
        buffer.Release();
    }
}