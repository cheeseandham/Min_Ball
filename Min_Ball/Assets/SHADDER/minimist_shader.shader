// Upgrade NOTE: replaced '_Object2World' with 'unity_ObjectToWorld'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Unlit/minimist_shader"
{
	Properties
	{
		_colour ("New_Colour", Color) = (1,1,1,1)
		_texture ("Main_Tex", 2d) = "white"
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

			struct appdata
			{
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 texcoord : TEXCOORD0;
			};

			fixed4 _colour;
			sampler2D _mainTex;

			v2f vert (appdata IN)
			{
				v2f OUT;
				OUT.pos = UnityObjectToClipPos(IN.vertex);
				OUT.normal = mul(float4(IN.normal,0.0), unity_ObjectToWorld).xyz;
				OUT.texcoord = IN.texcoord;
				return OUT;
			}

			fixed4 frag (v2f IN) : Color
			{
				fixed4 _texColour = tex2D(_mainTex, IN.texcoord);

				float3 normalDir = normalize(IN.normal);
				float3 lightDir = normalize(_WorldSpaceLightPos0.xyz);
				float3 diff = unity_LightColor0.rgb * max(0.0,dot(normalDir,lightDir));

				return _colour * _texColour * float4(diff, 0);

				//return _texColour;
			}

			ENDCG
		}
	}
}
