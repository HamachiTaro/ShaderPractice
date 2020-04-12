Shader "MyShader/CellularNoise"
{
    Properties
    {
        _GridNum ("GridNum", int) = 10
        [MaterialToggle] _ShowGrid ("ShowGrid", int) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
            
            int _GridNum;
            int _ShowGrid;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }
            
            // 呼び出す度に異なる値を返す訳ではなく、pで受け取る値が同じなら必ず同じ値を返す
            float2 random2( float2 p ) {
                return frac(sin(float2(dot(p,float2(127.1,311.7)),dot(p,float2(269.5,183.3))))*43758.5453);
            }

            fixed4 frag (v2f i) : SV_Target
            {
                const int gridNum = _GridNum;
                // 分割
                float2 st = i.uv * gridNum;
                // 少数部分
                float2 f_st = frac(st);
                // 整数部分
                float2 i_st = floor(st);
                
                fixed3 color = fixed3(0,0,0);
                
                float min_dist = 100;
                for(int x = -1; x <= 1; x++)
                {
                    for(int y = -1; y <= 1; y++)
                    {
                        // ご近所のグリッドの起点
                        float2 origin = i_st + float2(x, y);
                        // ご近所の点p
                        float2 p = random2(origin);
                        // アニメーションさせる
                        p = origin + 0.5 + 0.5 * sin(_Time.y + 6.2831 * p);
                        
                        // ご近所の点pとの距離
                        float dist = distance(st, p);
                        // 点stの色は最も近い点pの影響を受ける
                        min_dist = min(min_dist, dist);
                    }
                }
                
                color += min_dist;
                // pを白く描画
                color += step(min_dist, 0.02);
                //
                color.r += (step(0.98, f_st.x) + step(0.98, f_st.y)) * _ShowGrid;
                
                return fixed4(color, 1);
            }

            ENDCG
        }
    }
}
