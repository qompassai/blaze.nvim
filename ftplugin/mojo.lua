-- Mojo indentation configuration
local M = {}

-- Mojo indentation configuration
local global_mojo_indent = vim.tbl_extend("force", vim.g.mojo_indent or {}, {
  closed_paren_align_last_line = true,
  open_paren = vim.g.pyindent_open_paren or "shiftwidth() * 2",
  nested_paren = vim.g.pyindent_nested_paren or "shiftwidth()",
  continue = vim.g.pyindent_continue or "shiftwidth() * 2",
  searchpair_timeout = vim.g.pyindent_searchpair_timeout or 150,
  disable_parentheses_indenting = vim.g.pyindent_disable_parentheses_indenting or false,
})

local maxoff = 50

local function search_bracket(from_lnum, flags)
  return vim.fn.searchpairpos([[\v[[(]{]]], "", [[\v[])}]]], flags, function()
    local syn_ids = vim.fn.synstack(vim.fn.line("."), vim.fn.col("."))
    for _, id in ipairs(syn_ids) do
      local name = vim.fn.synIDattr(id, "name")
      if name:match("Comment$") or name:match("Todo$") or name:match("String$") then
        return true
      end
    end
    return false
  end, from_lnum - maxoff, global_mojo_indent.searchpair_timeout)
end

local function is_dedented(lnum, expected)
  return vim.fn.indent(lnum) <= expected - vim.fn.shiftwidth()
end

function M.get_indent(lnum)
  local line = vim.fn.getline(lnum)
  if line:match("^%s*$") then return -1 end

  local prev_lnum = vim.fn.prevnonblank(lnum - 1)
  if prev_lnum == 0 then return 0 end

  local prev_line = vim.fn.getline(prev_lnum)
  local prev_indent = vim.fn.indent(prev_lnum)

  -- Backslash continuation
  if prev_line:match("\\$") then
    local ok, func = pcall(load, "return " .. global_mojo_indent.continue)
    return prev_indent + (ok and func() or vim.fn.shiftwidth() * 2)
  end

  -- Handle colons
  if prev_line:match(":%s*$") then
    return prev_indent + vim.fn.shiftwidth()
  end

  -- Handle dedent keywords
  if line:match("^%s*(elif|else|except|finally)\b") then
    return prev_indent - vim.fn.shiftwidth()
  end

  return prev_indent
end

function M.indentexpr()
  return M.get_indent(vim.v.lnum)
end

return M
