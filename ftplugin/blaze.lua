-- ftplugin/blaze.lua
-- luacheck: globals vim ipairs pairs type loadstring
---@diagnostic disable: undefined-field, undefined-global, need-check-nil

local M = {}

---@type table<string, any>
local global_mojo_indent = vim.tbl_deep_extend("force", vim.g.mojo_indent or {}, {
  closed_paren_align_last_line    = true,
  open_paren                      = vim.g.pyindent_open_paren            or "shiftwidth() * 2",
  nested_paren                    = vim.g.pyindent_nested_paren          or "shiftwidth()",
  continue                        = vim.g.pyindent_continue              or "shiftwidth() * 2",
  searchpair_timeout              = vim.g.pyindent_searchpair_timeout    or 150,
  disable_parentheses_indenting   = vim.g.pyindent_disable_parentheses_indenting or false,
})

local maxoff = 50

local function search_bracket(from_lnum, flags)
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
    global_mojo_indent.searchpair_timeout
  )
end

local function is_dedented(lnum, expected)
  return vim.fn.indent(lnum) <= expected - vim.fn.shiftwidth()
end

function M.get_indent(lnum)
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

    if global_mojo_indent.closed_paren_align_last_line
     and line:match("^%s*[])}]") then
    local pos = search_bracket(lnum, "bnW")
    if pos and pos[1] then
      return vim.fn.indent(pos[1])
    end
  end

   if prev_line:match("\\$") then
    local loader = loadstring or load
    local ok, fn = pcall(loader, "return " .. global_mojo_indent.continue)
    return prev_indent + (ok and fn() or vim.fn.shiftwidth() * 2)
  end

    if prev_line:match(":%s*$") then
    return prev_indent + vim.fn.shiftwidth()
  end

    if line:match("^%s*(elif|else|except|finally)%f[%s]") then
    return prev_indent - vim.fn.shiftwidth()
  end

    if global_mojo_indent.disable_parentheses_indenting == false
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
return M
