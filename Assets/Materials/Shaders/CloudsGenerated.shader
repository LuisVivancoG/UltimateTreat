Shader "Shader Graphs/CloudsGenerated"
{
    Properties
    {
        _Rotate_Projection("Rotate Projection", Vector) = (1, 0, 0, 0)
        _Noise_Scale("Noise Scale", Float) = 3
        _Clouds_Speed("Clouds Speed", Float) = 0.1
        _Displacement_Scale("Displacement Scale", Float) = 1
        _Clouds_Remap("Clouds Remap", Vector) = (0, 1, -1, 1)
        _Color_Valley("Color Valley", Color) = (1, 1, 1, 0)
        _Color_Peaks("Color Peaks", Color) = (0, 0, 0, 0)
        _Noise_Edge_1("Noise Edge 1", Float) = 0
        _Noise_Edge_2("Noise Edge 2", Float) = 1
        _Noise_Power("Noise Power", Float) = 2
        _Base_Scale("Base Scale", Float) = 5
        _Speed_Base("Speed Base", Float) = 1
        _Base_Strenght("Base Strenght", Float) = 1
        _Fade_Depth("Fade Depth", Float) = 100
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Off
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _FORWARD_PLUS
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_InverseLerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4 = _Color_Valley;
            float4 _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4 = _Color_Peaks;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float4 _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4;
            Unity_InverseLerp_float4(_Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4, _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxxx), _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4);
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.BaseColor = (_InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Off
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma multi_compile_fog
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 fogFactorAndVertexLight : INTERP6;
             float3 positionWS : INTERP7;
             float3 normalWS : INTERP8;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_InverseLerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4 = _Color_Valley;
            float4 _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4 = _Color_Peaks;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float4 _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4;
            Unity_InverseLerp_float4(_Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4, _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxxx), _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4);
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.BaseColor = (_InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4.xyz);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/UnityGBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
             float3 normalWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Off
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.NormalTS = IN.TangentSpaceNormal;
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_InverseLerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4 = _Color_Valley;
            float4 _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4 = _Color_Peaks;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float4 _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4;
            Unity_InverseLerp_float4(_Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4, _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxxx), _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4);
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.BaseColor = (_InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_InverseLerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4 = _Color_Valley;
            float4 _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4 = _Color_Peaks;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float4 _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4;
            Unity_InverseLerp_float4(_Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4, _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxxx), _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4);
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.BaseColor = (_InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4.xyz);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Off
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float3 WorldSpacePosition;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS : INTERP0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _Rotate_Projection;
        float _Noise_Scale;
        float _Clouds_Speed;
        float _Displacement_Scale;
        float4 _Clouds_Remap;
        float4 _Color_Peaks;
        float4 _Color_Valley;
        float _Noise_Edge_1;
        float _Noise_Edge_2;
        float _Noise_Power;
        float _Base_Scale;
        float _Speed_Base;
        float _Base_Strenght;
        float _Fade_Depth;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Rotate_About_Axis_Degrees_float(float3 In, float3 Axis, float Rotation, out float3 Out)
        {
            Rotation = radians(Rotation);
        
            float s = sin(Rotation);
            float c = cos(Rotation);
            float one_minus_c = 1.0 - c;
        
            Axis = normalize(Axis);
        
            float3x3 rot_mat = { one_minus_c * Axis.x * Axis.x + c,            one_minus_c * Axis.x * Axis.y - Axis.z * s,     one_minus_c * Axis.z * Axis.x + Axis.y * s,
                                      one_minus_c * Axis.x * Axis.y + Axis.z * s,   one_minus_c * Axis.y * Axis.y + c,              one_minus_c * Axis.y * Axis.z - Axis.x * s,
                                      one_minus_c * Axis.z * Axis.x - Axis.y * s,   one_minus_c * Axis.y * Axis.z + Axis.x * s,     one_minus_c * Axis.z * Axis.z + c
                                    };
        
            Out = mul(rot_mat,  In);
        }
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_TilingAndOffset_float(float2 UV, float2 Tiling, float2 Offset, out float2 Out)
        {
            Out = UV * Tiling + Offset;
        }
        
        float2 Unity_GradientNoise_Deterministic_Dir_float(float2 p)
        {
            float x; Hash_Tchou_2_1_float(p, x);
            return normalize(float2(x - floor(x + 0.5), abs(x) - 0.5));
        }
        
        void Unity_GradientNoise_Deterministic_float (float2 UV, float3 Scale, out float Out)
        {
            float2 p = UV * Scale.xy;
            float2 ip = floor(p);
            float2 fp = frac(p);
            float d00 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip), fp);
            float d01 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(0, 1)), fp - float2(0, 1));
            float d10 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 0)), fp - float2(1, 0));
            float d11 = dot(Unity_GradientNoise_Deterministic_Dir_float(ip + float2(1, 1)), fp - float2(1, 1));
            fp = fp * fp * fp * (fp * (fp * 6 - 15) + 10);
            Out = lerp(lerp(d00, d01, fp.y), lerp(d10, d11, fp.y), fp.x) + 0.5;
        }
        
        void Unity_Add_float(float A, float B, out float Out)
        {
            Out = A + B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_Power_float(float A, float B, out float Out)
        {
            Out = pow(A, B);
        }
        
        void Unity_Combine_float(float R, float G, float B, float A, out float4 RGBA, out float3 RGB, out float2 RG)
        {
            RGBA = float4(R, G, B, A);
            RGB = float3(R, G, B);
            RG = float2(R, G);
        }
        
        void Unity_Remap_float(float In, float2 InMinMax, float2 OutMinMax, out float Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_Absolute_float(float In, out float Out)
        {
            Out = abs(In);
        }
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Multiply_float3_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_InverseLerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = (T - A)/(B - A);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float3 _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3;
            Unity_Multiply_float3_float3(IN.ObjectSpaceNormal, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxx), _Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3);
            float _Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float = _Displacement_Scale;
            float3 _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3;
            Unity_Multiply_float3_float3(_Multiply_ff3ffab137a0472293f4c73f2d0daf15_Out_2_Vector3, (_Property_9def41d2d17c418db8874246dd1409e8_Out_0_Float.xxx), _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3);
            float3 _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Multiply_38cce078d88a4dfaa8cca5e89f041ef0_Out_2_Vector3, _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3);
            description.Position = _Add_d432513b32e1464f8671de92cb2c482e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4 = _Color_Valley;
            float4 _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4 = _Color_Peaks;
            float _Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float = _Noise_Edge_1;
            float _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float = _Noise_Edge_2;
            float4 _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4 = _Rotate_Projection;
            float _Split_93f457ffa5874f5c951121ca64d5369b_R_1_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[0];
            float _Split_93f457ffa5874f5c951121ca64d5369b_G_2_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[1];
            float _Split_93f457ffa5874f5c951121ca64d5369b_B_3_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[2];
            float _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float = _Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4[3];
            float3 _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3;
            Unity_Rotate_About_Axis_Degrees_float(IN.WorldSpacePosition, (_Property_a174fe2b8344451bb458249dcfce0694_Out_0_Vector4.xyz), _Split_93f457ffa5874f5c951121ca64d5369b_A_4_Float, _RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3);
            float _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float = _Clouds_Speed;
            float _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_9502f98321444e309507ef9d7cb046d2_Out_0_Float, _Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float);
            float2 _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_b899e3fef9a3489988eba9184cd107db_Out_2_Float.xx), _TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2);
            float _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float = _Noise_Scale;
            float _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_fcfcbe2c7d7d4ac08a6fed8a692111ab_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float);
            float2 _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), float2 (0, 0), _TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2);
            float _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float;
            Unity_GradientNoise_Deterministic_float(_TilingAndOffset_b9473e7dc4e849a2a892f9844d6a500f_Out_3_Vector2, _Property_63c203f6575e47b5a1f10a52094d83d1_Out_0_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float);
            float _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float;
            Unity_Add_float(_GradientNoise_df453f023cc84608ba2750a3a8cbe87d_Out_2_Float, _GradientNoise_5189d517595c414790c2571547126e4c_Out_2_Float, _Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float);
            float _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float;
            Unity_Divide_float(_Add_4e53b4a3432b45639d2d0a43cefc8fe4_Out_2_Float, float(2), _Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float);
            float _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float;
            Unity_Saturate_float(_Divide_16428c5cecad4744af57d0fe5939ad08_Out_2_Float, _Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float);
            float _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float = _Noise_Power;
            float _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float;
            Unity_Power_float(_Saturate_3bda3472033945fd981ffec7ef6969bd_Out_1_Float, _Property_710f24a4537c4dad98d5f28d7d35cd56_Out_0_Float, _Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float);
            float4 _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4 = _Clouds_Remap;
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[0];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[1];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[2];
            float _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float = _Property_610efd2529aa4d46bc4bf93d1b367b13_Out_0_Vector4[3];
            float4 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4;
            float3 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3;
            float2 _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_R_1_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_G_2_Float, float(0), float(0), _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGBA_4_Vector4, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RGB_5_Vector3, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2);
            float4 _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4;
            float3 _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3;
            float2 _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2;
            Unity_Combine_float(_Split_ff0d7d20f33c47648d43060783e8f0fa_B_3_Float, _Split_ff0d7d20f33c47648d43060783e8f0fa_A_4_Float, float(0), float(0), _Combine_1448c46129674db38df2184aca703027_RGBA_4_Vector4, _Combine_1448c46129674db38df2184aca703027_RGB_5_Vector3, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2);
            float _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float;
            Unity_Remap_float(_Power_1e6f30378e804b5b92b469fec876ee6f_Out_2_Float, _Combine_081f3cf0f4d64e8fbe67ae4d7ed4ec5a_RG_6_Vector2, _Combine_1448c46129674db38df2184aca703027_RG_6_Vector2, _Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float);
            float _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float;
            Unity_Absolute_float(_Remap_0e05e9cd1ffa4fbc9699932d2d30b66d_Out_3_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float);
            float _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float;
            Unity_Smoothstep_float(_Property_c365569f45eb4cc397dca38dedd61dcb_Out_0_Float, _Property_79fa1c9aff5d4c2d968476a75868f765_Out_0_Float, _Absolute_994e05a5dc7c40aa8b84f723ca76b05e_Out_1_Float, _Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float);
            float _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float = _Speed_Base;
            float _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_356b03ef50cc4e60b30ea6747b001e50_Out_0_Float, _Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float);
            float2 _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2;
            Unity_TilingAndOffset_float((_RotateAboutAxis_56a5c4d4353248059d5442a9fbd7b10f_Out_3_Vector3.xy), float2 (1, 1), (_Multiply_3f732bb7982a40119c563352bdc8f89e_Out_2_Float.xx), _TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2);
            float _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float = _Base_Scale;
            float _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_TilingAndOffset_d9aa3854841149449b54c54e8ba1f064_Out_3_Vector2, _Property_f5b8e971366445bc930c4e9ed6418b2a_Out_0_Float, _SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float);
            float _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float = _Base_Strenght;
            float _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float;
            Unity_Multiply_float_float(_SimpleNoise_adc6644462984eb5963cbcc3b970a2ae_Out_2_Float, _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float);
            float _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float;
            Unity_Add_float(_Smoothstep_598ae860e2f1494f9e039ece1d4ffbb9_Out_3_Float, _Multiply_835ed6b509944f0ca6b0746552e38a55_Out_2_Float, _Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float);
            float _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float;
            Unity_Add_float(float(1), _Property_4c1140e0af4443ebbd577c586f3804d5_Out_0_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float);
            float _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float;
            Unity_Divide_float(_Add_9a741c2d02394902be8d12ea6106d13b_Out_2_Float, _Add_1030e73796a046508ea5a25f984f959d_Out_2_Float, _Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float);
            float4 _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4;
            Unity_InverseLerp_float4(_Property_7da98919db8e4581a7c5d41884229e27_Out_0_Vector4, _Property_72ce110fd4b0432cbccf5e7b963c3d93_Out_0_Vector4, (_Divide_f52e59fc0dba406b954c4bd33cbaf377_Out_2_Float.xxxx), _InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4);
            float _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float);
            float4 _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_e289604c6486409c921cfd69a20a8c51_R_1_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[0];
            float _Split_e289604c6486409c921cfd69a20a8c51_G_2_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[1];
            float _Split_e289604c6486409c921cfd69a20a8c51_B_3_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[2];
            float _Split_e289604c6486409c921cfd69a20a8c51_A_4_Float = _ScreenPosition_ebf5dcb769444c4da1f97816efae9c45_Out_0_Vector4[3];
            float _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float;
            Unity_Subtract_float(_Split_e289604c6486409c921cfd69a20a8c51_A_4_Float, float(1), _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float);
            float _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_b1d48d489a8141c18fa6888e054af72f_Out_1_Float, _Subtract_7601f352e5864ec2acc76ddca619c1a0_Out_2_Float, _Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float);
            float _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float = _Fade_Depth;
            float _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float;
            Unity_Divide_float(_Subtract_64e0d6caf1ef444ab656dac1693117d2_Out_2_Float, _Property_fcdcb4a544e64934bdf1bc4638a75d3c_Out_0_Float, _Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float);
            float _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            Unity_Saturate_float(_Divide_4279654ec16c495b960b74f605fd6311_Out_2_Float, _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float);
            surface.BaseColor = (_InverseLerp_68f6807a061b441090ca8d11a2fd26ff_Out_3_Vector4.xyz);
            surface.Alpha = _Saturate_b558de08682842c8a925228dc558cfac_Out_1_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.WorldSpacePosition =                         TransformObjectToWorld(input.positionOS);
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}