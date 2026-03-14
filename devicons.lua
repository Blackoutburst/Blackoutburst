-- mod-version:3
-- Author: PerilousBooklet (forked from Jipok's nonicons.lua)
-- Doesn't work well with scaling mode == "ui"

local common = require "core.common"
local config = require "core.config"
local style = require "core.style"
local TreeView = require "plugins.treeview"
local Node = require "core.node"

-- Config
config.plugins.devicons = common.merge({
  use_default_dir_icons = false,
  use_default_chevrons = false,
  draw_treeview_icons = true,
  draw_tab_icons = true,
  -- The config specification used by the settings gui
  config_spec = {
    name = "Devicons",
    {
      label = "Use Default Directory Icons",
      description = "When enabled does not use nonicon directory icons.",
      path = "use_default_dir_icons",
      type = "toggle",
      default = false
    },
    {
      label = "Use Default Chevrons",
      description = "When enabled does not use nonicon expand/collapse arrow icons.",
      path = "use_default_chevrons",
      type = "toggle",
      default = false
    },
    {
      label = "Draw Treeview Icons",
      description = "Enables file related icons on the treeview.",
      path = "draw_treeview_icons",
      type = "toggle",
      default = true
    },
    {
      label = "Draw Tab Icons",
      description = "Adds file related icons to tabs.",
      path = "draw_tab_icons",
      type = "toggle",
      default = true
    }
  }
}, config.plugins.devicons)

local icon_font = renderer.font.load(USERDIR.."/fonts/font_devicons/devicons.ttf", 15 * SCALE)
local chevron_width = icon_font:get_width("") -- ?
local previous_scale = SCALE

local extension_icons = {
  --[".f"] = {"#734796", ""}, [".F"] = {"#734796", ""}, [".f90"] = {"#734796", ""}, [".f95"] = {"#734796", ""}, [".f03"] = {"#734796", ""}, -- WIP: Fortran
  --[".fs"] = {"#378BBA", ""}, -- WIP: F#
  --[".j2"] = { "#02D0FF", "" }, -- WIP: J
  -- FIX: the .v extension for Veriog conflicts with the one for the V programming language
  --[".v"] = { "", "" }, -- WIP: Verilog
  --[".v"] = {"#536B8A", ""}, [".vv"] = {"#536B8A", ""}, [".vsh"] = {"#536B8A", ""}, -- WIP: V
  [".vert"] = {"#5586a4", ""}, -- Vertex shader
  [".frag"] = {"#5586a4", ""}, -- Fragment shader
  [".exe"] = {"#0178d4", ""}, -- Exe win32
  [".out"] = {"#ff9734", ""}, -- Exe posix
  [".asm"] = {"#DE002D", ""}, -- Assembly
  [".c"]   = { "#599eff", "" }, [".h"] = { "#599eff", "" },
  [".cbl"] = { "#005CA5", "" }, [".cob"] = { "#005CA5", "" }, [".cpy"] = { "#005CA5", "" }, -- Cobol
  [".clj"] = {"#91DC47", ""}, -- Clojure
  [".conf"] = { "#6d8086", "" }, [".cfg"] = { "#6d8086", "" },
  [".cpp"] = { "#519aba", "" }, [".hpp"] = { "#519aba", "" }, [".hh"] = { "#519aba", "" }, [".cc"] = { "#519aba", "" }, -- C++
  [".uhc"] = { "#eb4034", "" }, [".uhh"] = { "#eb4034", "" },
  [".cr"] = { "#000000", "" }, -- Crystal
  [".cs"] = { "#596706", "" },  -- C#
  [".css"] = { "#563d7c", "" }, [".module.css"] = { "#563d7c", "" },
  [".d"] = {"#B03931", ""}, [".di"] = {"#B03931", ""}, -- D
  [".dart"] = {"#055A9C", ""},
  [".diff"] = { "#41535b", "" },
  [".elm"] = { "#519aba", "" },
  [".erl"] = { "#A90533", "" }, [".hrl"] = { "#A90533", "" }, -- Erlang
  [".ex"] = { "#a074c4", "" }, [".exs"] = { "#a074c4", "" },  -- Elixir
  [".gd"] = { "#478CBF", "" }, -- Godot
  [".go"] = { "#519aba", "" },
  [".groovy"] = {"#357A93", ""}, [".gvy"] = {"#357A93", ""}, [".gy"] = {"#357A93", ""}, [".gsh"] = {"#357A93", ""},
  [".hs"] = {"#5E5086", ""}, -- Haskell
  [".html"] = { "#e34c26", "" }, [".html.erb"] = { "#e34c26", "" },
  [".ino"] = {"#008184", ""}, -- Arduino
  [".java"] = { "#cc3e44", "" },
  [".jl"] = {"#9359A5", ""}, -- Julia
  [".jpg"] = { "#a074c4", "" }, [".png"] = { "#a074c4", "" }, [".svg"] = { "#a074c4", "" }, -- Images
  -- WIP: Archive files
  --[".zip"] = { "", "" }, [".gzip"] = { "", "" },
  --[".tar"] = { "", "" }, [".tar.xz"] = { "", "" }, [".tar.gz"] = { "", "" },
  --[".rar"] = { "", "" },
  [".js"] = { "#cbcb41", "" },  -- JavaScript
  [".json"] = { "#854CC7", "" },
  [".kt"] = { "#816EE4", "" }, [".kts"] = { "#816EE4", "" },  -- Kotlin
  [".lisp"] = { "#FFFFFF", "" }, [".lsp"] = { "#FFFFFF", "" },
  [".lua"] = { "#51a0cf", "" },
  [".ly"] = {"#FC7DB0", ""}, -- Lilypond
  [".md"]  = { "#519aba", "" }, -- Markdown
  [".ml"] = { "#EE750A", "" }, -- OCaml
  [".nim"] = { "#FFE953", "" }, [".nims"] = { "#FFE953", "" }, [".nimble"] = { "#FFE953", "" },
  [".nix"] = {"#7EB3DF", ""},
  [".odin"] = { "#3882D2", "" },
  [".php"] = { "#a074c4", "" },
  [".pl"] = { "#519aba", "" }, [".pm"] = { "#519aba", "" },  -- Perl
  [".py"]  = { "#3572A5", "" }, [".pyc"]  = { "#519aba", "" }, [".pyd"]  = { "#519aba", "" }, -- Python
  [".r"] = { "#358a5b", "" }, [".R"] = { "#358a5b", "" },
  [".rake"] = { "#701516", "" },
  [".rb"] = { "#701516", "" },  -- Ruby
  [".rs"] = { "#dea584", "" },  -- Rust
  [".rss"] = { "#cc3e44", "" },
  [".sass"] = {"#CF649A", ""}, [".scss"] = {"#CF649A", ""},
  [".scad"] = {"#e8b829", ""}, -- OpenSCAD
  [".scala"] = { "#cc3e44", "" },
  [".sh"] = { "#4d5a5e", "" },  -- Shell
  [".sql"] = { "#C84431", "" },
  [".sv"] = { "#1A348F", "" }, [".svh"] = { "#1A348F", "" }, -- System Verilog
  [".svelte"] = {"#FF3C00", ""},
  [".swift"] = { "#e37933", "" },
  [".tex"] = {"#467f22", ""}, [".sty"] = {"#467f22", ""}, [".cls"] = {"#467f22", ""}, [".dtx"] = {"#467f22", ""}, [".ins"] = {"#467f22", ""},
  [".toml"] = { "#6d8086", "" },
  [".ts"] = { "#519aba", "" },  -- TypeScript
  [".vala"] = { "#706296", "" },
  --[".vbs"] = { "", "" }, -- WIP: Visual Basic Scripting Edition
  [".vim"] = { "#8f00ff", "" },
  [".wasm"] = {"#654EF0", ""}, -- WebAssembly
  [".xml"] = {"#005FAD", ""},
  [".yaml"] = { "#6d8086", "" }, [".yml"] = { "#6d8086", "" },
  [".zig"] = { "#cbcb41", "" },
  --[".cfg"] = { "#D29F2C", "" }, [".wfl"] = { "#D29F2C", "" }, -- Wesnoth Markup Language and Formula Language
  -- Odd files
  --[".crt"] = { "", "" }, -- WIP: Security Certificate File Format
  -- Following without special icon:
  [".bash"] = { "#4169e1", "" }, [".bat"] = { "#4169e1", "" }, [".ps1"] = { "#4169e1", "" }, -- Shells
  [".reg"] = { "#52D4FB", "" }, -- Windows registry
  [".desktop"] = { "#6d8086", "" },
  [".fish"] = { "#ca2c92", "" },
  [".ini"] = { "#ffffff", "" },
}

local known_names_icons = {
  [".tmux.conf"] = { "#1BB91F", "" }, ["tmux.conf"] = { "#1BB91F", "" },
  ["babel.config.json"] = {"#F9DC3E", ""}, [".babelrc.json"] = {"#F9DC3E", ""},
  ["build.zig"] = { "#6d8086", "" },
  ["changelog"] = { "#657175", "" }, ["changelog.txt"] = { "#4d5a5e", "" }, ["changelog.md"] = { "#519aba", "" },
  ["Cmakelists.txt"] = { "#0068C7", "" },
  ["docker-compose.yml"] = { "#4289a1", "" },
  ["dockerfile"] = { "#296478", "" },
  ["gradlew"] = { "#6d8086", "" }, ["gradlew.bat"] = { "#6d8086", "" },
  ["init.lua"] = { "#2d6496", "" },
  ["license"] = { "#d0bf41", "" }, ["license.txt"] = { "#d0bf41", "" },
  ["makefile"] = { "#6d8086", "" },
  ["meson.build"] = {"#6d8086", ""}, ["meson_options.txt"] = {"#6d8086", ""},
  ["pkgbuild"] = {"#358fdd", ""}, -- Arch Linux PKGBUILD
  ["readme.md"] = { "#72b886", "" }, ["readme"] = { "#72b886", "" },
  ["setup.py"] = { "#559dd9", "" },
  -- Web dev
  [".npmrc"] = {"#CC3534", ""},
  ["alpine.config.js"] = {"#77C1D2", ""},
  ["angular.json"] = {"#DE002D", ""},
  ["next.config.js"] = {"#000000", ""},
  ["package.json"] = {"#68A063", ""}, -- Node.js
  --["postcss.config.js"] = {"#DD3A0A", ""}, [".postcssrc"] = {"#DD3A0A", ""}, -- WIP: PostCSS
  --[""] = {"#61DBFB", ""}, -- WIP: React
  ["schema.prisma"] = { "#2D3748", "" },
  ["svelte.config.js"] = {"#FF3C00", ""},
  ["tailwind.config.js"] = {"#38BDF8", ""},
  ["vue.config.js"] = {"#3FB984", ""},
}

-- Preparing colors
for k, v in pairs(extension_icons) do
  v[1] = { common.color(v[1]) }
end
for k, v in pairs(known_names_icons) do
  v[1] = { common.color(v[1]) }
end

-- Override function to change default icons for dirs, special extensions and names
local TreeView_get_item_icon = TreeView.get_item_icon
function TreeView:get_item_icon(item, active, hovered)
  local icon, font, color = TreeView_get_item_icon(self, item, active, hovered)
  if previous_scale ~= SCALE then
    icon_font:set_size(
      icon_font:get_size() * (SCALE / previous_scale)
    )
    chevron_width = icon_font:get_width("") -- ?
    previous_scale = SCALE
  end
  if not config.plugins.devicons.use_default_dir_icons then
    icon = "" -- file icon
    font = icon_font
    color = style.text
    if item.type == "dir" then
      icon = item.expanded and "" or "" -- file dir icon open, file dir icon closed
    end
  end
  if config.plugins.devicons.draw_treeview_icons then
    local custom_icon = known_names_icons[item.name:lower()]
    if custom_icon == nil then
      custom_icon = extension_icons[item.name:match("^.+(%..+)$")]
    end
    if custom_icon ~= nil then
      color = custom_icon[1]
      icon = custom_icon[2]
      font = icon_font
    end
    if active or hovered then
      color = style.accent
    end
  end
  return icon, font, color
end

-- Override function to draw chevrons if setting is disabled
local TreeView_draw_item_chevron = TreeView.draw_item_chevron
function TreeView:draw_item_chevron(item, active, hovered, x, y, w, h)
  if not config.plugins.devicons.use_default_chevrons then
    if item.type == "dir" then
      local chevron_icon = item.expanded and "" or ""  -- open arrow icon, closed arrow icon ?
      local chevron_color = hovered and style.accent or style.text
      common.draw_text(icon_font, chevron_color, chevron_icon, nil, x, y, 0, h)
    end
    return chevron_width + style.padding.x/4
  end
  return TreeView_draw_item_chevron(self, item, active, hovered, x, y, w, h)
end

-- Override function to draw icons in tabs titles if setting is enabled
local Node_draw_tab_title = Node.draw_tab_title
function Node:draw_tab_title(view, font, is_active, is_hovered, x, y, w, h)
  if config.plugins.devicons.draw_tab_icons then
    local padx = chevron_width + style.padding.x/2
    local tx = x + padx -- Space for icon
    w = w - padx
    Node_draw_tab_title(self, view, font, is_active, is_hovered, tx, y, w, h)
    if (view == nil) or (view.doc == nil) then return end
    local item = { type = "file", name = view.doc:get_name() }
    TreeView:draw_item_icon(item, false, is_hovered, x, y, w, h)
  else
    Node_draw_tab_title(self, view, font, is_active, is_hovered, x, y, w, h)
  end
end
