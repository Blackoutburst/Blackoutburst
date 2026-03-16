-- mod-version:3
-- UnHolyC syntax highlighting for Lite XL
-- Handles .uhc (source) and .uhh (header) files
-- Based on C/C++ with HolyC types (U8, I32, F64, ...) highlighted as keyword2

local syntax = require "core.syntax"
local style  = require "core.style"
local common = require "core.common"

-- Custom token type for namespace names.
-- Change this hex color to whatever you like.
style.syntax["namespace"] = { common.color "#ff772e" }
style.syntax["struct"] = { common.color "#b9d918" }

syntax.add {
  name    = "UnHolyC",
  files   = { "%.uhc$", "%.uhh$" },
  comment = "//",
  block_comment = { "/*", "*/" },

  patterns = {
    -- Comments
    { pattern = "//.-\n",           type = "comment" },
    { pattern = { "/%*", "%*/" },   type = "comment" },

    -- #include <stdlib.h>  ->  keyword + string
    { pattern = "#%s*include()%s*()%b<>",  type = { "keyword", "normal", "string" } },
    -- #include "foo.uhh"  ->  keyword + string
    { pattern = '#%s*include()%s*()%b""',  type = { "keyword", "normal", "string" } },
    -- Other preprocessor directives  (#define, #pragma, #ifdef …)
    { pattern = "#%s*[%a_][%w_]*",         type = "keyword" },

    -- Strings
    { pattern = { '"',  '"',  '\\' }, type = "string" },
    { pattern = { "'",  "'",  '\\' }, type = "string" },

    -- Numbers: hex, float, int (with optional suffix: f u l ul ull)
    { pattern = "0[xX][%da-fA-F]+[uUlL]*",            type = "number" },
    { pattern = "%d+%.%d*[eEfF]?[fFlLuU]*",           type = "number" },
    { pattern = "%.%d+[eEfF]?[fFlLuU]*",              type = "number" },
    { pattern = "%d+[eEfF][%+%-]?%d+[fFlLuU]*",       type = "number" },
    { pattern = "%d+[fFlLuU]*",                        type = "number" },

    -- struct/union/enum name in declaration:  "struct It {"  ->  keyword + keyword2
    { pattern = "struct()%s+()[%a_][%w_]*",  type = { "keyword", "normal", "struct" } },
    { pattern = "union()%s+()[%a_][%w_]*",   type = { "keyword", "normal", "struct" } },
    { pattern = "enum()%s+()[%a_][%w_]*",    type = { "keyword", "normal", "struct" } },

    -- Namespace declaration:  "namespace Cube {"  ->  keyword + namespace
    { pattern = "namespace()%s+()[%a_][%w_]*", type = { "keyword", "normal", "namespace" } },

    -- Namespace qualifier usage:  "Cube.It"  "Cube.create()"
    --   %f[%.]  frontier pattern: matches only when the next char is a dot
    { pattern = "[%u][%w_]*%f[%.]",  type = "namespace" },

        -- Function calls  — must come before plain symbol
    { pattern = "[%a_][%w_]*%f[(]",  type = "function" },

    -- SCREAMING_SNAKE_CASE constants  (VK_BUFFER_USAGE_…, GLFW_KEY_W, …)
    --   must start uppercase and contain at least one underscore
    --   this excludes U32/I8/etc. (no underscore) which are already keyword2
    { pattern = "[%u][%u%d]*_[%u%d_]*",  type = "number" },

    -- PascalCase / mixed-case external types  (GLFWwindow, VkBuffer, VkDeviceSize …)
    --   catch-all for any uppercase-starting identifier not already matched above
    --   by this point namespaces (before .), post-dot types, and ALL_CAPS are handled
    { pattern = "[%u][%w_]*",  type = "struct" },

    -- Uppercase type name after namespace dot:  "Cube.It"  ->  the "It" part
    --   %.  matches the literal dot, then ()  splits the token, then uppercase ident
    { pattern = "%.()[%u][%w_]*",  type = { "operator", "struct" } },

    -- _t suffix types  (pthread_mutex_t, uint32_t, size_t …)
    { pattern = "[%a_][%w_]*_t%f[^%w_]",  type = "keyword2" },

    -- Namespace / scope operator  ::
    { pattern = "::",                 type = "operator" },

    -- Operators
    { pattern = "[%+%-%*/%^%%=<>!~|&%?:%.%[%]%(%)%{%}%;%,]", type = "operator" },

    -- Everything else is a symbol (keywords resolved via the symbols table)
    { pattern = "[%a_][%w_]*",        type = "symbol" },
  },

  symbols = {
    -- ── C/C++ control flow ──────────────────────────────────────────────────
    ["if"]           = "keyword",
    ["else"]         = "keyword",
    ["for"]          = "keyword",
    ["while"]        = "keyword",
    ["do"]           = "keyword",
    ["switch"]       = "keyword",
    ["case"]         = "keyword",
    ["default"]      = "keyword",
    ["break"]        = "keyword",
    ["continue"]     = "keyword",
    ["return"]       = "keyword",
    ["goto"]         = "keyword",

    -- ── Storage / qualifiers ─────────────────────────────────────────────────
    ["static"]       = "keyword",
    ["extern"]       = "keyword",
    ["inline"]       = "keyword",
    ["volatile"]     = "keyword",
    ["const"]        = "keyword",
    ["register"]     = "keyword",
    ["auto"]         = "keyword",
    ["constexpr"]    = "keyword",
    ["mutable"]      = "keyword",
    ["explicit"]     = "keyword",
    ["virtual"]      = "keyword",
    ["override"]     = "keyword",
    ["final"]        = "keyword",

    -- ── Type / declaration keywords ───────────────────────────────────────────
    ["struct"]       = "keyword",
    ["union"]        = "keyword",
    ["enum"]         = "keyword",
    ["class"]        = "keyword",
    ["typedef"]      = "keyword",
    ["namespace"]    = "keyword",
    ["unused"]       = "keyword",
    ["template"]     = "keyword",
    ["typename"]     = "keyword",
    ["using"]        = "keyword",
    ["sizeof"]       = "keyword",
    ["alignof"]      = "keyword",
    ["decltype"]     = "keyword",
    ["new"]          = "keyword",
    ["delete"]       = "keyword",
    ["operator"]     = "keyword",
    ["public"]       = "keyword",
    ["private"]      = "keyword",
    ["protected"]    = "keyword",
    ["friend"]       = "keyword",

    -- ── Standard C types (kept for plain C compatibility) ────────────────────
    ["void"]         = "keyword2",
    ["int"]          = "keyword2",
    ["char"]         = "keyword2",
    ["short"]        = "keyword2",
    ["long"]         = "keyword2",
    ["float"]        = "keyword2",
    ["double"]       = "keyword2",
    ["unsigned"]     = "keyword2",
    ["signed"]       = "keyword2",
    ["bool"]         = "keyword2",
    ["size_t"]       = "keyword2",
    ["ptrdiff_t"]    = "keyword2",
    ["intptr_t"]     = "keyword2",
    ["uintptr_t"]    = "keyword2",

    -- ── HolyC types ──────────────────────────────────────────────────────────
    ["U0"]           = "keyword2",   -- void
    ["U8"]           = "keyword2",   -- uint8
    ["U16"]          = "keyword2",   -- uint16
    ["U32"]          = "keyword2",   -- uint32
    ["U64"]          = "keyword2",   -- uint64
    ["I8"]           = "keyword2",   -- int8 / char
    ["I16"]          = "keyword2",   -- int16
    ["I32"]          = "keyword2",   -- int32
    ["I64"]          = "keyword2",   -- int64
    ["F32"]          = "keyword2",   -- float
    ["F64"]          = "keyword2",   -- double
    ["F128"]         = "keyword2",   -- long double

    -- ── Literals ─────────────────────────────────────────────────────────────
    ["true"]         = "literal",
    ["false"]        = "literal",
    ["NULL"]         = "literal",
    ["nullptr"]      = "literal",
    ["TRUE"]         = "literal",
    ["FALSE"]        = "literal",
  },
}
