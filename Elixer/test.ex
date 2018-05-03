defmodule Elixir_Intro do

def fib(1) do 1 end
def fib(2) do 1 end
def fib(n) do
    fib(n-1)+fib(n-2)
end

def area(:rectangle, {l,h}) do
    l*h
end

def area(:square, l) do
    l * l
end

def area(:triangle, {b, h})do
    0.5*b*h
end

def area(:circle, r)do
    r*r*:math.pi
end


def sqrList(nums) do
square = fn(x) -> x * x end
Enum.map(nums, square)
end

def calcTotals(inventory) do
calc=fn({x,y,z})->[x,y*z] end
Enum.map(inventory, calc)
end

def map(function, vals) do
    for n <- vals do function.(n) end
end

def quickSortServer() do
    receive do
        {message, pid} ->
            send(pid, {qsort(message), self()})
    end
    quickSortServer
end

def qsort([]) do [] end

	def qsort(mylist) do
        temp=:random.uniform(length(mylist))
        pivot=:lists.nth(temp,mylist )
        rest = :lists.delete(pivot, mylist)
		smaller = for n <- rest, n < pivot do n end
		larger = for n <- rest, n >= pivot do n end
		qsort(smaller) ++ [pivot] ++ qsort(larger)
	end







end
defmodule Client do
    def callServer(pid,nums) do
        send(pid, {nums, self()})
	listen
    end

    def listen do
        receive do
	    {sorted, pid} -> sorted
	end
    end
end
