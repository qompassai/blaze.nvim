// lua/mojo/treesitter/mojo/grammar.js
function commaSep(rule) {
	return optional(seq(rule, repeat(seq(",", rule))));
}
export default grammar({
	name: "mojo",
	rules: {
		source_file: $ => repeat($._statement),

		_statement: $ => choice(
			$.function_definition,
			$.struct_definition,
			$.trait_definition,
			$.expression_statement
		),

		function_definition: $ =>
			seq("fn", field("name", $.identifier), $.parameter_list, $.block),

		struct_definition: $ =>
			seq("struct", field("name", $.identifier), $.block),

		trait_definition: $ =>
			seq("trait", field("name", $.identifier), $.block),

		parameter_list: $ =>
			seq("(", commaSep($.identifier), ")"),

		block: $ =>
			seq("{", repeat($._statement), "}"),

		expression_statement: $ =>
			seq($._expression, optional(";")),

		_expression: $ =>
			choice($.identifier, $.number),

		identifier: _ => /[a-zA-Z_][a-zA-Z0-9_]*/,

		number: _ => /[0-9]+/
	}
});
