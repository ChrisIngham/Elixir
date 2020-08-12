defmodule ElixirLab do
	def firstTwo(list) do
		[first, second | _ ] = list
		first == second	
	end
	
	def evenSize(list) do
		(rem (length(list)), 2) == 0
	end

	def frontBack(list) do
		x = [hd list]
		newlist = List.delete_at(list, 0)
		newlist ++ x
	end
	
	def nextNineNine(list) do
		List.insert_at(list, 1, 99)
	end
	
	def isCoord(list) do
		[first, second | _ ] = list
		(length list) == 2 && is_number(first) && is_number(second)
	end

	def helloIfSo(list) do
		newList = List.delete(list, "Hello")
		newList ++ ["Hello"]
	end
	

	def sumEven([]) do
		0
	end
	def sumEven([h|t]) do
		if (is_integer h) && ((rem h,2) == 0) do
			h + sumEven(t)
		else
			sumEven(t)
		end
	end
	
	
	def sumNum([]) do
		0
	end
	def sumNum([h|t]) do
		if (is_integer h) do
			h + sumNum(t)
		else
			sumNum(t)
		end
	end
	
	
	def tailFib(0), do: :error
	def tailFib(1), do: 1
	def tailFib(2), do: 1 
	def tailFib(n) do
		tailFib(n-1) + tailFib(n-2)
	end


	def reduce(x,y) do
		Enum.reduce(x,y)
	end
	def reduce(x,y,z) do
		# only works if there are 3 elements
		Enum.reduce(x,y,z)
	end


end