
module ExtInt
push!(LOAD_PATH, ".")
using Error
using Lexer
export calc, parse, NumVal, ClosureVal
abstract type OWL end
abstract type RetVal end
abstract type Environment end
type Num <: OWL
	n::Real
end
type Uniop <: OWL
    op::Function
    num::OWL
end
type IdNode <: OWL
  name::Symbol
end
type BindingNode <:OWL
    name::Symbol
    binding_expr::OWL
end
type WithNode <: OWL
  bindingNodes::Array{BindingNode}
  body::OWL
end
type FunDefNode <: OWL
    formal_parameter::Array{IdNode}
    fun_body::OWL
end
type FunAppNode <: OWL
    fun_expr::OWL
    arg_expr::Array{OWL}
end


type If0Node <: OWL
      condition::OWL
      zero_branch::OWL
      nonzero_branch::OWL
    end
type Binop <: OWL
	op::Function
	lhs::OWL
	rhs::OWL
end

type NumVal <: RetVal
  n::Real
end

type ClosureVal <: RetVal
    param::Array{Symbol}
    body::OWL
    env::Environment  # this is the environment at definition time!
end

# Definitions for our environment data structures

type mtEnv <: Environment
end

type CEnvironment <: Environment
  name::Symbol
  value::RetVal
  parent::Environment
end
function parse(sym::Symbol)
    if (sym==:*|| sym==:- || sym==:/ ||sym==:+|| sym==:mod || sym==:collatz ||sym==:if0||sym==:lambda || sym==:with)
        #print(sym,"\n")
        throw(LispError("INVALID SYNTAX"))
    end
    #print("I create a symbol ")
    #print(sym)
    return  IdNode(sym)
end
function parse(func::Function)
    return func
end
function parse(num::Number)
    return Num(num)
end
function parse(expr::Array{Any})
        if(length(expr)==0)
            throw(LispError("EMPTY STRING IDIOT"))
        end
        if (expr[1]==:lambda)
            mylistofIds=[]#
            for id in expr[2]
                if id in mylistofIds
                 throw(LispError("DUPLICATE"))
              else
                  push!(mylistofIds, parse(id))
              end
            end
            #print("I make fundef node")
            #print(expr[4])
            if length(expr)>3
                throw(LispError("invalid number of args"))
            end
            return FunDefNode(mylistofIds, parse(expr[3]))

        end
        if(expr[1]==:with)
            mylist=[]
            names=[]
            for tuple in expr[2]# is this correct?
                if(parse(tuple[1]).name in names)
                    throw(LispError("duplicate!"))
                end
                push!(names, parse(tuple[1]).name)
                push!(mylist, BindingNode(parse(tuple[1]).name,parse(tuple[2])))
            end
            return WithNode(mylist, parse(expr[3]))
        end
        if(length(expr)==4)
            if(expr[1]==:if0)
                return If0Node(parse(expr[2]), parse(expr[3]), parse(expr[4]))
            end
        end
        if(length(expr)==3)
            if(expr[1]==:* || expr[1]==:- || expr[1]==:/ || expr[1]==:+ || expr[1]==:mod)
               return Binop(parse(mydict[expr[1]]), parse(expr[2]), parse(expr[3]))
           end
        elseif(length(expr)==2)
            if(expr[1]==:collatz||expr[1]==:-)
                return Uniop(parse(mydict[expr[1]]), parse(expr[2]))
            end
        end

    #else we must have a Fun App Node
    mylistofOWLS=[]
    #print("my length is ", length(expr))
    #if length(expr)!=1
    for i = 2:length(expr)
        #print("I AM HERE ", expr[i], "\n")
        push!(mylistofOWLS, parse(expr[i]))#  grab everything else in the expr array tree
    end
#end
    #print("i make funapp node ", mylistofOWLS, " break ", expr[1])
    #print("hi " ,expr[1])
    return FunAppNode(parse(expr[1]),mylistofOWLS)
end

function collatz( x::Real )
    n=x
    if n<=0
        throw( LispError("Whoa there! LESS THAN OR EQUAL TO ZERO FOR COLLATAZ"))
    end
  return collatz_helper( n, 0 )
end

function collatz_helper( n::Real, num_iters::Int )
  if n == 1
    return num_iters
  end
  if mod(n,2)==0
    return collatz_helper( n/2, num_iters+1 )
  else
    return collatz_helper( 3*n+1, num_iters+1 )
  end
end



function calc(id::If0Node, env::Environment)
    cond = calc( id.condition, env )
    if typeof(cond)!=NumVal
        throw(LispError("Invalid!"))
    end
  if cond.n == 0
    return calc(id.zero_branch, env )
  else
    return calc(id.nonzero_branch, env )
  end
end

function calc(id::IdNode, env::Environment)
    return calc(id.name, env)
end
function calc(n::Num, env::Environment)
    return NumVal(n.n)
end
function calc(ast::Uniop, env::Environment)
        temp=calc(ast.num)
        if typeof(temp)!=NumVal
            throw(LispError("Invalid type for Uniop"))
        end

    return NumVal(ast.op(temp.n))
end
function calc(ast::FunDefNode, env::Environment)
    mylist=[]
    for idnode in ast.formal_parameter
        push!(mylist, idnode.name)
    end
    return ClosureVal(mylist, ast.fun_body, env)
end
function calc(ast::Function, env::Environment)
    return ast
end
function calc(node::WithNode, env::Environment)
    temp=env
    for expr in node.bindingNodes
        newone=CEnvironment(expr.name, calc(expr.binding_expr, env), temp)
        temp=newone
    end
    return calc(node.body, temp)


end
function calc(sym::NumVal, env::Environment)
    return sym.n
end
function calc(sym::Symbol, evn::CEnvironment)
    if sym==evn.name
        #print("I do return an ", evn.value)
        return evn.value
else
    return calc(sym, evn.parent)
end
end
function calc(sym::Symbol, env::mtEnv)
    throw(LispError("Undefined variable!"))
end
function calc(num::Number, env::Environment)
    return num
end
function calc(ast::FunAppNode, env::Environment)
      myClosureVal=calc(ast.fun_expr, env)
      if typeof(myClosureVal)!=ClosureVal
          throw(LispError("NOT A ClosureVal"))
      end
      mylistofnums=[]
      #print("my ast is this ", ast, "\n")
      for num in ast.arg_expr #gather the numbers from the fun App Node who should have them
          push!(mylistofnums, calc(num, env))
      end
      mylistofIds=[]
      for id in myClosureVal.param
         push!(mylistofIds, id)
      end
      #print("MY IDS ARE THIS ", mylistofIds, "My Nums are this ", mylistofnums, "\n")
       if length(mylistofnums)!=length(mylistofIds)
           #print(mylistofnums," ",  mylistofIds)
           throw(LispError("invalid arguments"))
           #return "STOP"
       end
       temp=env
       for i=1:length(mylistofnums)
           newone=CEnvironment(mylistofIds[i], mylistofnums[i], temp)
           temp=newone
       end
      return calc(myClosureVal.body, temp)
      #myfuncdefnode.

end
function calc(ast::Binop, env::Environment)
    opp=calc(ast.op, env)
    left=calc(ast.lhs, env)
    right=calc(ast.rhs, env)
    if opp==/
        if typeof(left) ==NumVal && typeof(right)==NumVal
        if right.n==0
            throw( LispError("Can't divide by zero") )
        end
         end
    end

    #print("my types are ", left, right)
    if typeof(left)==NumVal && typeof(right)==NumVal
        return NumVal(opp(calc(left, env), calc(right, env)))
    end
    throw(LispError("incorrect types"))
end
function calc(ast::OWL)
    return calc(ast, mtEnv())
end

function interp(cs::AbstractString)
    lxd=Lexer.lex(cs)
    print(lxd)
    ast=parse(lxd)
    print(ast, '\n')
    return calc(ast,mtEnv())
end
mydict=Dict(:+ => +, :- => -, :/ =>/, :* => *, :mod => mod, :collatz=>collatz)
#print(interp("(+ 3 3)"),"\n")
#print(interp("(/ 3 3)"),"\n")
#print(interp("(* 3 3)"), "\n")
#print(interp("(with ((x 2) (y 6)) (+ x y))"), "\n")
#print(interp("(if0 0 2 3)"),"\n")
#print(interp("((lambda (x y) (* y x)) 2 3)"), "\n")
#print(interp("(- 5)"), "\n")
#print(interp("(collatz 10)"), "\n")
#print(interp("(mod 5 4)"), "\n")
#print(interp("((lambda (x y) (* x y)) 2 (* 4 4) )"))
#print(interp("()"))
#print(interp("(x)"))
#print(interp("(1 2 3)"))
#print(interp("(/ 0 0)"), "\n")



end
#is it okay to have it in a try catch for the parse to make sure something doesn't die
#aka if we are given it in the incorrect format, we reject it right?
#parse the one below how to do it since it has no parenthese
