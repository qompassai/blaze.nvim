-- ~/.config/nvim/ftplugin/blaze.lua
-- ---------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved

if vim.b.did_blaze_ftplugin then
  return
end
vim.b.did_blaze_ftplugin = 1
local M = {}
local function get_config()
  return vim.tbl_deep_extend("force", 
    vim.g.mojo_indent or {}, 
    vim.b.mojo_indent or {},
    {
      closed_paren_align_last_line    = true,
      open_paren                      = "shiftwidth() * 2",
      nested_paren                    = "shiftwidth()",
      continue                        = "shiftwidth() * 2",
      searchpair_timeout              = 150,
      disable_parentheses_indenting   = false,
      expandtab = true,
      shiftwidth = 4,
      tabstop = 4,
      softtabstop = 4,
    })
end
local maxoff = 50
local function search_bracket(from_lnum, flags)
  local config = get_config()
  return vim.fn.searchpairpos(
    "\\v[[(]{]", "", "\\v[])}]", flags,
    function()
      for _, id in ipairs(vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))) do
        local n = vim.fn.synIDattr(id, "name")
        if n:match("Comment$") or n:match("String$") then return true end
      end
      return false
    end,
    from_lnum - maxoff,
    config.searchpair_timeout
  )
end
local function is_dedented(lnum, expected)
  return vim.fn.indent(lnum) <= expected - vim.fn.shiftwidth()
end
function M.get_indent(lnum)
  local config = get_config()
  local line = vim.fn.getline(lnum)
  if line:match("^%s*$") then
    return -1
  end
  local prev_lnum = vim.fn.prevnonblank(lnum - 1)
  if prev_lnum == 0 then
    return 0
  end
  local prev_line   = vim.fn.getline(prev_lnum)
  local prev_indent = vim.fn.indent(prev_lnum)
  if config.closed_paren_align_last_line
     and line:match("^%s*[])}]") then
    local pos = search_bracket(lnum, "bnW")
    if pos and pos[1] then
      return vim.fn.indent(pos[1])
    end
  end
  if prev_line:match("\\$") then
    local loader = loadstring or load
    local ok, fn = pcall(loader, "return " .. config.continue)
    return prev_indent + (ok and fn() or vim.fn.shiftwidth() * 2)
  end
  if prev_line:match(":%s*$") then
    return prev_indent + vim.fn.shiftwidth()
  end
  if line:match("^%s*(elif|else|except|finally)%f[%s]") then
    return prev_indent - vim.fn.shiftwidth()
  end
  if config.disable_parentheses_indenting == false
     and is_dedented(prev_lnum, prev_indent) then
    return prev_indent - vim.fn.shiftwidth()
  end
  return prev_indent
end
function M.indentexpr()
  local lnum = vim.v and vim.v.lnum or 0
  if type(lnum) ~= "number" then
    return 0
  end
  return M.get_indent(lnum)
end
function M.setup(opts)
  local config = vim.tbl_deep_extend("force", get_config(), opts or {})
  vim.bo.expandtab = config.expandtab
  vim.bo.shiftwidth = config.shiftwidth
  vim.bo.tabstop = config.tabstop
  vim.bo.softtabstop = config.softtabstop
  
  vim.b.mojo_indent = config
end
M.setup()
vim.bo.indentexpr = 'v:lua.require("ftplugin.blaze").indentexpr()'
vim.bo.autoindent = true
vim.bo.smartindent = false
vim.bo.commentstring = "# %s"
vim.opt_local.iskeyword:append("$")
vim.opt_local.suffixesadd:prepend(".mojo")
return M
