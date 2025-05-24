--/qompassai/blaze.nvim/autoload/blaze.lua
-- --------------------------------------
-- Copyright (C) 2025 Qompass AI, All rights reserved
-- luacheck: globals vim ipairs pairs type loadstring
---@diagnostic disable: undefined-field, undefined-global, need-check-nil

local M = {}

local defaults = {
  closed_paren_align_last_line = true,
  open_paren = 'shiftwidth() * 2',
  nested_paren = 'shiftwidth()',
  continue = 'shiftwidth() * 2',
  searchpair_timeout = 150,
  disable_parentheses_indenting = false,
}

---@type table<string,any>
local cfg = vim.tbl_deep_extend('force', defaults, vim.g.mojo_indent or {}, {
  open_paren = vim.g.pyindent_open_paren or defaults.open_paren,
  nested_paren = vim.g.pyindent_nested_paren or defaults.nested_paren,
  continue = vim.g.pyindent_continue or defaults.continue,
  searchpair_timeout = vim.g.pyindent_searchpair_timeout or defaults.searchpair_timeout,
  disable_parentheses_indenting = vim.g.pyindent_disable_parentheses_indenting
    or defaults.disable_parentheses_indenting,
})

local MAX_LOOKBACK = 50

local function search_bracket(from_lnum, flags)
  return vim.fn.searchpairpos('\\v[[(]{]', '', '\\v[])}]', flags, function()
    for _, id in ipairs(vim.fn.synstack(vim.fn.line('.'), vim.fn.col('.'))) do
      local name = vim.fn.synIDattr(id, 'name')
      if name:match('Comment$') or name:match('String$') then
        return true
      end
    end
    return false
  end, from_lnum - MAX_LOOKBACK, cfg.searchpair_timeout)
end

local function dedented(lnum, expected)
  return vim.fn.indent(lnum) <= expected - vim.fn.shiftwidth()
end

---@param lnum integer
---@param extra? fun(start_lnum: integer): boolean
---@return integer
function M.get_indent(lnum, extra)
  extra = extra or function()
    return false
  end

  local line = vim.fn.getline(lnum)
  if line:match('^%s*$') then
    return -1
  end

  if vim.fn.getline(lnum - 1):match('\\$') then
    if lnum > 1 and vim.fn.getline(lnum - 2):match('\\$') then
      return vim.fn.indent(lnum - 1)
    end
    local loader = loadstring or load
    local ok, fn = pcall(loader, 'return ' .. cfg.continue)
    return vim.fn.indent(lnum - 1) + (ok and fn() or vim.fn.shiftwidth() * 2)
  end

  if
    vim.fn.has('syntax_items') == 1
    and vim.fn.synIDattr(vim.fn.synID(lnum, 1, 1), 'name'):match('String$')
  then
    return -1
  end

  local plnum = vim.fn.prevnonblank(lnum - 1)
  if plnum == 0 then
    return 0
  end

  if
    not cfg.disable_parentheses_indenting
    and cfg.closed_paren_align_last_line
    and line:match('^%s*[])}]')
  then
    local pos = search_bracket(lnum, 'bnW')
    if pos[1] > 0 then
      return vim.fn.indent(pos[1])
    end
  end

  local pline = vim.fn.getline(plnum)
  local plindent = vim.fn.indent(plnum)

  if not cfg.disable_parentheses_indenting then
    local parlnum = search_bracket(plnum, 'nbW')[1]
    if parlnum > 0 and not extra(parlnum) then
      plindent = vim.fn.indent(parlnum)
    end
  end

  if pline:match(':%s*$') then
    return plindent + vim.fn.shiftwidth()
  end

  if line:match('^%s*(elif|else|except|finally)%f[%s]') then
    return plindent - vim.fn.shiftwidth()
  end

  if vim.fn.getline(plnum):match('^%s*(break|continue|raise|return|pass)%f[%s]') then
    if dedented(lnum, plindent) then
      return -1
    end
    return plindent - vim.fn.shiftwidth()
  end

  return plindent
end

function M.indentexpr()
  local lnum = (vim.v and vim.v.lnum) or 0
  if type(lnum) ~= 'number' or lnum < 1 then
    return 0
  end
  return M.get_indent(lnum)
end

return M
