function calc(ast::NumNode)
return ast.n

function ast::MinusNode)
return calc(ast.lhs)-calc(ast.rhs)

function ast::PlusNode)
return same as above but +

#parsing recursion and calculating recursion. 
