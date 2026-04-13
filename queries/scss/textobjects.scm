; SCSS block captures
(rule_set) @block.outer
(rule_set (block) @block.inner)

(at_rule) @block.outer
(at_rule (block) @block.inner)

(mixin_statement) @block.outer
(mixin_statement (block) @block.inner)

(function_statement) @block.outer
(function_statement (block) @block.inner)
