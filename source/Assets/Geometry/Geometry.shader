Shader "Unlit/Geometry"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            // ジオメトリシェーダーを使いますよ。関数名はgeomですよ。
            #pragma geometry geom
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };
            
            // 頂点シェーダーからジオメトリシェーダーに渡す情報
            struct v2g
            {
                float4 vertex : SV_POSITION;
                float4 worldPos : TEXCOORD0;
            };

            // ジオメトリシェーダーからフラグメントシェーダーに渡す情報
            struct g2f
            {
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD0;
            };

            // 返り値の型がv2gに変更
            v2g vert (appdata v)
            {
                // ここもv2gになってる 
                v2g o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex);
                return o;
            }
            
            // 
            [maxvertexcount(3)]
            // v2gの入力を受け取って、g2fの情報をinoutを利用して渡す
			void geom (triangle v2g input[3], inout TriangleStream<g2f> stream)
			{
			    // 各頂点のワールド座標を取得
			    float3 wp1 = input[0].worldPos.xyz;
			    float3 wp2 = input[1].worldPos.xyz;
			    float3 wp3 = input[2].worldPos.xyz;
			    // wp1からwp2へのベクトル
			    float3 edge1 = wp2 - wp1;
			    // wp1からwp3へのベクトル
			    float3 edge2 = wp3 - wp1;
			    // 二つのベクトルから法線を取得
			    float3 normal = normalize(cross(edge1, edge2));
			    
			    normal += _SinTime.w * 0.5 + 0.5;
			    
			    // 頂点が３つなので、３回ループを回す
			    for(int i = 0; i < 3; i++)
			    {
			        g2f o;
			        o.vertex = input[i].vertex;
			        o.normal = normal;
			        stream.Append(o);
			    }
			    // ひとつのポリゴンに対する入力が終わったらこれを呼ぶ。
			    // stream.RestartStrip();
			}
            
            // ジオメトリシェーダーから入力を受け取るので、g2f
            fixed4 frag (g2f i) : SV_Target
            {
                float3 normal = i.normal;
                return fixed4(normal, 1);
            }
            ENDCG
        }
    }
}
