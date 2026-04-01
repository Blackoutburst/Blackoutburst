-- mod-version:3

local syntax = require "core.syntax"
local style  = require "core.style"
local common = require "core.common"

style.syntax["namespace"] = { common.color "#ff772e" }
style.syntax["struct"] = { common.color "#b9d918" }

syntax.add {
  name    = "UnHolyC",
  files   = { "%.uhc$", "%.uhh$" },
  comment = "//",
  block_comment = { "/*", "*/" },

  patterns = {
    { pattern = "//.-\n",           type = "comment" },
    { pattern = { "/%*", "%*/" },   type = "comment" },

    { pattern = "#%s*include()%s*()%b<>",  type = { "keyword", "normal", "string" } },
    { pattern = '#%s*include()%s*()%b""',  type = { "keyword", "normal", "string" } },
    { pattern = "#%s*[%a_][%w_]*",         type = "keyword" },

    { pattern = { '"',  '"',  '\\' }, type = "string" },
    { pattern = { "'",  "'",  '\\' }, type = "string" },

    { pattern = "0[xX][%da-fA-F]+[uUlL]*",            type = "number" },
    { pattern = "%d+%.%d*[eEfF]?[fFlLuU]*",           type = "number" },
    { pattern = "%.%d+[eEfF]?[fFlLuU]*",              type = "number" },
    { pattern = "%d+[eEfF][%+%-]?%d+[fFlLuU]*",       type = "number" },
    { pattern = "%d+[fFlLuU]*",                        type = "number" },

    { pattern = "struct()%s+()[%a_][%w_]*",  type = { "keyword", "normal", "struct" } },
    { pattern = "union()%s+()[%a_][%w_]*",   type = { "keyword", "normal", "struct" } },
    { pattern = "enum()%s+()[%a_][%w_]*",    type = { "keyword", "normal", "struct" } },

    { pattern = "namespace()%s+()[%a_][%w_]*", type = { "keyword", "normal", "namespace" } },

    { pattern = "[%u][%w_]*%f[%.]",  type = "namespace" },

    { pattern = "[%a_][%w_]*%f[(]",  type = "function" },

    { pattern = "[%u][%u%d]*_[%u%d_]*",  type = "number" },

    { pattern = "[%u][%w_]*",  type = "struct" },

    { pattern = "%.()[%u][%w_]*",  type = { "operator", "struct" } },

    { pattern = "[%a_][%w_]*_t%f[^%w_]",  type = "keyword2" },

    { pattern = "::",                 type = "operator" },

    { pattern = "[%+%-%*/%^%%=<>!~|&%?:%.%[%]%(%)%{%}%;%,]", type = "operator" },

    { pattern = "[%a_][%w_]*",        type = "symbol" },
  },

  symbols = {
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

    ["struct"]       = "keyword",
    ["union"]        = "keyword",
    ["enum"]         = "keyword",
    ["class"]        = "keyword",
    ["typedef"]      = "keyword",
    ["namespace"]    = "keyword",
    ["lambda"]       = "keyword",
    ["unused"]       = "keyword",
    ["deprecated"]   = "keyword",
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

    ["U0"]           = "keyword2",
    ["U8"]           = "keyword2",
    ["U16"]          = "keyword2",
    ["U32"]          = "keyword2",
    ["U64"]          = "keyword2",
    ["I8"]           = "keyword2",
    ["I16"]          = "keyword2",
    ["I32"]          = "keyword2",
    ["I64"]          = "keyword2",
    ["F32"]          = "keyword2",
    ["F64"]          = "keyword2",
    ["F128"]         = "keyword2",

    ["true"]         = "literal",
    ["false"]        = "literal",
    ["NULL"]         = "literal",
    ["nullptr"]      = "literal",
    ["TRUE"]         = "literal",
    ["FALSE"]        = "literal",
  },
}
