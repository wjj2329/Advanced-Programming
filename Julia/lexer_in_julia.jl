push!(LOAD_PATH, ".")
using Error
Using Lexor
abstract type OWL
end
type NumNode <: OWL
    n::Real
end
type PlusNode <:OWL
    lhs::OWL
    rhs::OWl
end
type MinusNode <:OWL
    lhs::OWL
    rhs::OWL
end
type WithNode<: OWL
    the_var::Symbol
    binding_expr::OWL
    body::OWL
end
type SymbolNode <: OWL
    the_sym::Symbol
end
abstract type RetVal
end
type ClosureVa<:RetVal
    body::OWL
    formal_parm::Symbol
    env::Environment



end
type NumVal<:RetVal
    n::Number
end
abstract type Environment
end
type MtEnv <:
end
type ConcreteEnvironment <:Environment
    value::Number
    the_sym::Symbol
    parent::Environment
end
function parse( expr::Symbol)
    return SymbolNode( expr)
function parse( expr::Number)
    return NumNode (expr)
end
function parse(expr::Array{any})
    if expr[1]==:+
        return PlusNode( parse (expr[2]), parse(expr[3]))
    elseif expr[1]==:-
        return MinusNode( parse (expr[2]), parse(expr[3]))
    elseif expr[1]==:with
        return WithNode ( expr[2], parse( expr[3]), parse (expr[4]))
    end
    error("YOUV DONT GOOFED")
end
function interp(cs::AbstractString)
    lxd=Lexer.lex(cs)
    ast=parse(lxd)
    return calc(ast, MtEnv())
end
function calc (ast::NumNode, env::Environment)
    return ast.n
end
function calc (ast::PlusNode, env::Environment )
    return calc(ast.lhs, env)+calc(ast.rhs, env)
end
function clac (ast::MinusNose, env::Environment)
    return calc(ast.lhs, env)- calc (ast.rhs, env)
end
function calc( ast::SymbolNode, env:MtEnv)
    Error("NO")
end

function calc (ast::SymbolNode, env::ConcreteEnvironment)
    if typeof( env)==MtEnv
        Error("WELL HELLO THErE")
    end
    if env.the_sym==ast.the_sym
    else
        return calc(ast, env.parent)
    end
end

function calc(ast::WithNode, env::Environment)
 ze_bind=calc(ast.binding_expr, env)
 ext_env=ConcreteEnvironment(ze_bind, ast.the_sym, env)
 return calc(ast.body, ext_env)

end
#end #module
