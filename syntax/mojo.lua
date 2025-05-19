-- syntax/mojo.lua
-- Includes full highlighting rules from legacy mojo.vim

if vim.g.b_current_syntax then return end
vim.g.b_current_syntax = "mojo"

if vim.g.mojo_highlight_all then
  vim.g.mojo_no_builtin_highlight = nil
  vim.g.mojo_no_doctest_code_highlight = nil
  vim.g.mojo_no_doctest_highlight = nil
  vim.g.mojo_no_exception_highlight = nil
  vim.g.mojo_no_number_highlight = nil
  vim.g.mojo_space_error_highlight = 1
end

vim.cmd [[
  syntax keyword mojoStatement False None True as assert break continue del global
  syntax keyword mojoStatement lambda nonlocal pass return with yield
  syntax keyword mojoStatement class def fn struct trait inout owned borrowed raises
  syntax keyword mojoConditional elif else if
  syntax keyword mojoRepeat for while
  syntax keyword mojoOperator and in is not or
  syntax keyword mojoException except finally raise try
  syntax keyword mojoInclude from import alias
  syntax keyword mojoAsync async await
  syntax keyword mojoKeywords var let
]]

vim.cmd [[
  syntax match mojoComment "#.*$" contains=mojoTodo,@Spell
  syntax keyword mojoTodo FIXME NOTE NOTES TODO XXX contained
  syntax match mojoFunction "\h\w*" display contained
  syntax match mojoDecorator "@" display contained
  syntax match mojoDecoratorName "@\s*\h\(\w\|\.\)*" display contains=mojoDecorator
  syntax match mojoMlirInline "`[^`]*`"
  syntax match mojoAttribute /\.\h\w*/hs=s+1 contains=ALLBUT,mojoBuiltin,mojoFunction,mojoAsync
]]

if not vim.g.mojo_no_number_highlight then
  vim.cmd [[
    syntax match mojoNumber "\<0[oO]\=\o\+[Ll]\=\>"
    syntax match mojoNumber "\<0[xX]\x\+[Ll]\=\>"
    syntax match mojoNumber "\<0[bB][01]\+[Ll]\=\>"
    syntax match mojoNumber "\<\%([1-9]\d*\|0\)[Ll]\=\>"
    syntax match mojoNumber "\<\d\+[jJ]\>"
    syntax match mojoNumber "\<\d\+[eE][+-]\=\d\+[jJ]\=\>"
    syntax match mojoNumber "\<\d\+\.\%([eE][+-]\=\d\+\)\=[jJ]\=\%([^a-zA-Z0-9_]\|$\)\@="
    syntax match mojoNumber "\%(^\|[^a-zA-Z0-9_]\)\zs\d*\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>"
  ]]
end

if not vim.g.mojo_no_builtin_highlight then
  vim.cmd [[
    syntax keyword mojoBuiltin NotImplemented Ellipsis __debug__ quit exit copyright credits license
    syntax keyword mojoBuiltin abs all any ascii bin bool breakpoint bytearray bytes callable
    syntax keyword mojoBuiltin chr classmethod compile complex delattr dict dir divmod enumerate eval exec
    syntax keyword mojoBuiltin filter float format frozenset getattr globals hasattr hash help hex id input
    syntax keyword mojoBuiltin int isinstance issubclass iter len list locals map max memoryview min next object
    syntax keyword mojoBuiltin oct open ord pow print property range repr reversed round set setattr
    syntax keyword mojoBuiltin slice sorted staticmethod str sum super tuple type vars zip __import__
    syntax keyword mojoMlirKeyword __mlir_type __mlir_op __mlir_attr
  ]]
end

if not vim.g.mojo_no_exception_highlight then
  vim.cmd [[
    syntax keyword mojoExceptions BaseException Exception ArithmeticError BufferError LookupError
    syntax keyword mojoExceptions AssertionError AttributeError EOFError FloatingPointError GeneratorExit
    syntax keyword mojoExceptions ImportError IndentationError IndexError KeyError KeyboardInterrupt MemoryError
    syntax keyword mojoExceptions ModuleNotFoundError NameError NotImplementedError OSError OverflowError
    syntax keyword mojoExceptions RecursionError ReferenceError RuntimeError StopAsyncIteration StopIteration
    syntax keyword mojoExceptions SyntaxError SystemError SystemExit TabError TypeError UnboundLocalError
    syntax keyword mojoExceptions UnicodeDecodeError UnicodeEncodeError UnicodeError UnicodeTranslateError
    syntax keyword mojoExceptions ValueError ZeroDivisionError EnvironmentError IOError WindowsError
    syntax keyword mojoExceptions BlockingIOError BrokenPipeError ChildProcessError ConnectionAbortedError
    syntax keyword mojoExceptions ConnectionError ConnectionRefusedError ConnectionResetError FileExistsError
    syntax keyword mojoExceptions FileNotFoundError InterruptedError IsADirectoryError NotADirectoryError
    syntax keyword mojoExceptions PermissionError ProcessLookupError TimeoutError
    syntax keyword mojoExceptions BytesWarning DeprecationWarning FutureWarning ImportWarning
    syntax keyword mojoExceptions PendingDeprecationWarning ResourceWarning RuntimeWarning SyntaxWarning
    syntax keyword mojoExceptions UnicodeWarning UserWarning Warning
  ]]
end

if vim.g.mojo_space_error_highlight then
  vim.cmd [[
    syntax match mojoSpaceError display excludenl "\s\+$"
    syntax match mojoSpaceError display " \+\t"
    syntax match mojoSpaceError display "\t\+ "
  ]]
end

vim.cmd [[
  hi def link mojoStatement Statement
  hi def link mojoConditional Conditional
  hi def link mojoRepeat Repeat
  hi def link mojoOperator Operator
  hi def link mojoException Exception
  hi def link mojoInclude Include
  hi def link mojoAsync Statement
  hi def link mojoDecorator Define
  hi def link mojoDecoratorName Function
  hi def link mojoFunction Function
  hi def link mojoComment Comment
  hi def link mojoTodo Todo
  hi def link mojoString String
  hi def link mojoRawString String
  hi def link mojoQuotes String
  hi def link mojoTripleQuotes String
  hi def link mojoEscape Special
  hi def link mojoMlirKeyword Special
  hi def link mojoMlirInline String
  hi def link mojoKeywords Structure
]]

if not vim.g.mojo_no_number_highlight then
  vim.cmd [[ hi def link mojoNumber Number ]]
end
if not vim.g.mojo_no_builtin_highlight then
  vim.cmd [[ hi def link mojoBuiltin Function ]]
end
if not vim.g.mojo_no_exception_highlight then
  vim.cmd [[ hi def link mojoExceptions Structure ]]
end
if vim.g.mojo_space_error_highlight then
  vim.cmd [[ hi def link mojoSpaceError Error ]]
end

