-- mod-version:3
-- Slang shading language syntax highlighting for Lite XL
-- Handles .slang files
-- Slang is an HLSL-compatible shading language by NVIDIA / Khronos Group

local syntax = require "core.syntax"

syntax.add {
  name    = "Slang",
  files   = { "%.slang$" },
  comment = "//",
  block_comment = { "/*", "*/" },

  patterns = {
    -- Comments
    { pattern = "//.-\n",                         type = "comment" },
    { pattern = { "/%*", "%*/" },                 type = "comment" },

    -- Attributes: [shader("vertex")], [numthreads(8,8,1)], etc.
    { pattern = "%[%s*[%a_][%w_%.]*%s*[%(%]]",   type = "keyword2" },
    { pattern = "%[%s*[%a_][%w_%.]*",             type = "keyword2" },

    -- System-value semantics: SV_Position, SV_Target0, etc.
    { pattern = "SV_[%u%d_]+",                   type = "keyword2" },

    -- Preprocessor directives
    { pattern = "#%s*[%a_][%w_]*",               type = "keyword" },

    -- Strings
    { pattern = { '"', '"', '\\' },              type = "string" },
    { pattern = { "'", "'", '\\' },              type = "string" },

    -- Numbers: hex, float, int
    { pattern = "0[xX][%da-fA-F]+[uUlL]*",      type = "number" },
    { pattern = "%d+%.%d*[eEfF]?[fFhHuUlL]*",   type = "number" },
    { pattern = "%.%d+[eEfF]?[fFhHuUlL]*",      type = "number" },
    { pattern = "%d+[eEfF][%+%-]?%d+[fFhHuUlL]*", type = "number" },
    { pattern = "%d+[fFhHuUlL]*",               type = "number" },

    -- Function calls
    { pattern = "[%a_][%w_]*%f[(]",              type = "function" },

    -- Operators and punctuation
    { pattern = "[%+%-%*/%^%%=<>!~|&%?:%.%[%]%(%)%{%}%;%,]", type = "operator" },

    -- Identifiers (resolved via symbols table)
    { pattern = "[%a_][%w_]*",                   type = "symbol" },
  },

  symbols = {
    -- ── Control flow ──────────────────────────────────────────────────────────
    ["if"]              = "keyword",
    ["else"]            = "keyword",
    ["for"]             = "keyword",
    ["while"]           = "keyword",
    ["do"]              = "keyword",
    ["switch"]          = "keyword",
    ["case"]            = "keyword",
    ["default"]         = "keyword",
    ["break"]           = "keyword",
    ["continue"]        = "keyword",
    ["return"]          = "keyword",
    ["discard"]         = "keyword",

    -- ── Type declarations ─────────────────────────────────────────────────────
    ["struct"]          = "keyword",
    ["interface"]       = "keyword",
    ["enum"]            = "keyword",
    ["class"]           = "keyword",
    ["typedef"]         = "keyword",
    ["typealias"]       = "keyword",
    ["associatedtype"]  = "keyword",
    ["extension"]       = "keyword",
    ["namespace"]       = "keyword",

    -- ── Module system ─────────────────────────────────────────────────────────
    ["module"]          = "keyword",
    ["import"]          = "keyword",
    ["export"]          = "keyword",
    ["implementing"]    = "keyword",

    -- ── Storage / qualifiers ──────────────────────────────────────────────────
    ["const"]           = "keyword",
    ["constexpr"]       = "keyword",
    ["static"]          = "keyword",
    ["extern"]          = "keyword",
    ["inline"]          = "keyword",
    ["__generic"]       = "keyword",
    ["let"]             = "keyword",
    ["var"]             = "keyword",
    ["property"]        = "keyword",
    ["get"]             = "keyword",
    ["set"]             = "keyword",

    -- ── Parameter direction qualifiers ────────────────────────────────────────
    ["in"]              = "keyword",
    ["out"]             = "keyword",
    ["inout"]           = "keyword",
    ["ref"]             = "keyword",
    ["uniform"]         = "keyword",
    ["varying"]         = "keyword",

    -- ── Misc language keywords ────────────────────────────────────────────────
    ["sizeof"]          = "keyword",
    ["this"]            = "keyword",
    ["cbuffer"]         = "keyword",
    ["tbuffer"]         = "keyword",
    ["register"]        = "keyword",
    ["packoffset"]      = "keyword",

    -- ── Scalar types ─────────────────────────────────────────────────────────
    ["void"]            = "keyword2",
    ["bool"]            = "keyword2",
    ["int"]             = "keyword2",
    ["uint"]            = "keyword2",
    ["float"]           = "keyword2",
    ["double"]          = "keyword2",
    ["half"]            = "keyword2",
    ["int8_t"]          = "keyword2",
    ["int16_t"]         = "keyword2",
    ["int32_t"]         = "keyword2",
    ["int64_t"]         = "keyword2",
    ["uint8_t"]         = "keyword2",
    ["uint16_t"]        = "keyword2",
    ["uint32_t"]        = "keyword2",
    ["uint64_t"]        = "keyword2",
    ["float16_t"]       = "keyword2",
    ["float32_t"]       = "keyword2",
    ["float64_t"]       = "keyword2",

    -- ── Vector types ─────────────────────────────────────────────────────────
    ["bool2"]           = "keyword2",
    ["bool3"]           = "keyword2",
    ["bool4"]           = "keyword2",
    ["int2"]            = "keyword2",
    ["int3"]            = "keyword2",
    ["int4"]            = "keyword2",
    ["uint2"]           = "keyword2",
    ["uint3"]           = "keyword2",
    ["uint4"]           = "keyword2",
    ["float2"]          = "keyword2",
    ["float3"]          = "keyword2",
    ["float4"]          = "keyword2",
    ["double2"]         = "keyword2",
    ["double3"]         = "keyword2",
    ["double4"]         = "keyword2",
    ["half2"]           = "keyword2",
    ["half3"]           = "keyword2",
    ["half4"]           = "keyword2",
    ["vector"]          = "keyword2",

    -- ── Matrix types ─────────────────────────────────────────────────────────
    ["float2x2"]        = "keyword2",
    ["float2x3"]        = "keyword2",
    ["float2x4"]        = "keyword2",
    ["float3x2"]        = "keyword2",
    ["float3x3"]        = "keyword2",
    ["float3x4"]        = "keyword2",
    ["float4x2"]        = "keyword2",
    ["float4x3"]        = "keyword2",
    ["float4x4"]        = "keyword2",
    ["int2x2"]          = "keyword2",
    ["int3x3"]          = "keyword2",
    ["int4x4"]          = "keyword2",
    ["double2x2"]       = "keyword2",
    ["double3x3"]       = "keyword2",
    ["double4x4"]       = "keyword2",
    ["matrix"]          = "keyword2",

    -- ── Texture / resource types ──────────────────────────────────────────────
    ["Texture1D"]               = "keyword2",
    ["Texture2D"]               = "keyword2",
    ["Texture3D"]               = "keyword2",
    ["TextureCube"]             = "keyword2",
    ["Texture1DArray"]          = "keyword2",
    ["Texture2DArray"]          = "keyword2",
    ["TextureCubeArray"]        = "keyword2",
    ["Texture2DMS"]             = "keyword2",
    ["Texture2DMSArray"]        = "keyword2",
    ["RWTexture1D"]             = "keyword2",
    ["RWTexture2D"]             = "keyword2",
    ["RWTexture3D"]             = "keyword2",
    ["RWTexture1DArray"]        = "keyword2",
    ["RWTexture2DArray"]        = "keyword2",
    ["Buffer"]                  = "keyword2",
    ["StructuredBuffer"]        = "keyword2",
    ["ByteAddressBuffer"]       = "keyword2",
    ["RWBuffer"]                = "keyword2",
    ["RWStructuredBuffer"]      = "keyword2",
    ["RWByteAddressBuffer"]     = "keyword2",
    ["AppendStructuredBuffer"]  = "keyword2",
    ["ConsumeStructuredBuffer"] = "keyword2",
    ["ConstantBuffer"]          = "keyword2",
    ["ParameterBlock"]          = "keyword2",
    ["RaytracingAccelerationStructure"] = "keyword2",

    -- ── Sampler types ─────────────────────────────────────────────────────────
    ["SamplerState"]            = "keyword2",
    ["SamplerComparisonState"]  = "keyword2",

    -- ── Literals ─────────────────────────────────────────────────────────────
    ["true"]            = "literal",
    ["false"]           = "literal",
    ["null"]            = "literal",

    -- ── Built-in math functions ───────────────────────────────────────────────
    ["abs"]             = "function",
    ["sign"]            = "function",
    ["floor"]           = "function",
    ["ceil"]            = "function",
    ["round"]           = "function",
    ["trunc"]           = "function",
    ["frac"]            = "function",
    ["modf"]            = "function",
    ["fmod"]            = "function",
    ["sqrt"]            = "function",
    ["rsqrt"]           = "function",
    ["pow"]             = "function",
    ["exp"]             = "function",
    ["exp2"]            = "function",
    ["log"]             = "function",
    ["log2"]            = "function",
    ["sin"]             = "function",
    ["cos"]             = "function",
    ["tan"]             = "function",
    ["asin"]            = "function",
    ["acos"]            = "function",
    ["atan"]            = "function",
    ["atan2"]           = "function",
    ["sinh"]            = "function",
    ["cosh"]            = "function",
    ["tanh"]            = "function",
    ["degrees"]         = "function",
    ["radians"]         = "function",

    -- ── Built-in vector/matrix functions ─────────────────────────────────────
    ["dot"]             = "function",
    ["cross"]           = "function",
    ["normalize"]       = "function",
    ["length"]          = "function",
    ["distance"]        = "function",
    ["mul"]             = "function",
    ["transpose"]       = "function",
    ["determinant"]     = "function",
    ["reflect"]         = "function",
    ["refract"]         = "function",
    ["faceforward"]     = "function",

    -- ── Built-in clamp/interpolation functions ────────────────────────────────
    ["min"]             = "function",
    ["max"]             = "function",
    ["clamp"]           = "function",
    ["saturate"]        = "function",
    ["lerp"]            = "function",
    ["smoothstep"]      = "function",
    ["step"]            = "function",

    -- ── Built-in logic/comparison functions ──────────────────────────────────
    ["any"]             = "function",
    ["all"]             = "function",
    ["select"]          = "function",

    -- ── Built-in bit / type functions ─────────────────────────────────────────
    ["asfloat"]         = "function",
    ["asint"]           = "function",
    ["asuint"]          = "function",
    ["asdouble"]        = "function",
    ["countbits"]       = "function",
    ["firstbithigh"]    = "function",
    ["firstbitlow"]     = "function",
    ["reversebits"]     = "function",

    -- ── Derivative / screen-space functions (pixel shader) ───────────────────
    ["ddx"]             = "function",
    ["ddy"]             = "function",
    ["ddx_coarse"]      = "function",
    ["ddy_coarse"]      = "function",
    ["ddx_fine"]        = "function",
    ["ddy_fine"]        = "function",
    ["fwidth"]          = "function",

    -- ── Atomic functions ──────────────────────────────────────────────────────
    ["InterlockedAdd"]          = "function",
    ["InterlockedAnd"]          = "function",
    ["InterlockedOr"]           = "function",
    ["InterlockedXor"]          = "function",
    ["InterlockedMin"]          = "function",
    ["InterlockedMax"]          = "function",
    ["InterlockedExchange"]     = "function",
    ["InterlockedCompareExchange"] = "function",

    -- ── Synchronisation / memory barrier functions ────────────────────────────
    ["AllMemoryBarrier"]            = "function",
    ["AllMemoryBarrierWithGroupSync"] = "function",
    ["DeviceMemoryBarrier"]         = "function",
    ["DeviceMemoryBarrierWithGroupSync"] = "function",
    ["GroupMemoryBarrier"]          = "function",
    ["GroupMemoryBarrierWithGroupSync"] = "function",

    -- ── Wave intrinsics ───────────────────────────────────────────────────────
    ["WaveGetLaneCount"]        = "function",
    ["WaveGetLaneIndex"]        = "function",
    ["WaveIsFirstLane"]         = "function",
    ["WaveReadLaneFirst"]       = "function",
    ["WaveReadLaneAt"]          = "function",
    ["WaveActiveAllTrue"]       = "function",
    ["WaveActiveAnyTrue"]       = "function",
    ["WaveActiveBallot"]        = "function",
    ["WaveActiveSum"]           = "function",
    ["WaveActiveProduct"]       = "function",
    ["WaveActiveMin"]           = "function",
    ["WaveActiveMax"]           = "function",
    ["WaveActiveCountBits"]     = "function",
    ["WavePrefixSum"]           = "function",
    ["WavePrefixProduct"]       = "function",
    ["WavePrefixCountBits"]     = "function",
    ["QuadReadAcrossX"]         = "function",
    ["QuadReadAcrossY"]         = "function",
    ["QuadReadAcrossDiagonal"]  = "function",
    ["QuadReadLaneAt"]          = "function",
  },
}
