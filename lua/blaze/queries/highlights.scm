; Keywords
((identifier) @keyword
 (#match? @keyword "^(fn|let|var|class|trait|struct|return|if|else|elif|for|while|with|async|await|inout|owned|borrowed|raises)$"))

; Function definitions
((function_definition name: (identifier) @function))

; Type identifiers
((type_identifier) @type)

; Comments
((comment) @comment)

; Strings
((string) @string)

; Numbers
((number) @number)

; Builtins (heuristic)
((identifier) @function.builtin
 (#match? @function.builtin "^(print|len|range|int|float|str)$"))

