class Ackermann
	def ackermann_function(m, n)
		if m == 0
			return n+1
		elsif n == 0
			return [m-1,1]
		else
			return [m-1, [m, n-1]]
		end
	end
	
	def evaluate(m, n)
		degree_of_array = 1
		original = [m, n]
		total_array = [original[0], original[1]]
		working_array = [original[0], original[1]]
		while degree_of_array > 0 do
			#gets
			#puts degree_of_array
			p total_array
			working_array = select_nested_array(total_array, degree_of_array)
			#p working_array
			return_result = ackermann_function(working_array[0], working_array[1])
			#p return_result
			if return_result.kind_of?(Array)
				if return_result[1].kind_of?(Array)
					working_array[0] = return_result[0]
					working_array[1] = return_result[1]
					degree_of_array += 1
				else
					working_array[0] = return_result[0]
					working_array[1] = return_result[1]
				end
			else
				degree_of_array -= 1
				if degree_of_array >0 
					working_array = select_nested_array(total_array, degree_of_array)
					working_array[1] = return_result
				else
					answer = return_result
				end
			end
		end
		return answer
	end
	
	def select_nested_array(nested_array, array_degree)
		return_array_reference = nested_array
		for degree in 1..(array_degree-1) do
			return_array_reference = return_array_reference[1]
		end
		return return_array_reference
	end
end

# (1,0) = (1-1,1) = 2
# (2,0) = (2-1,1) = (1-1, (1,0)) = (0, 2) = 3
# (3,0) = (3-1,1) = (2-1, (2,0)) = (1-1, (1, 3-1)) = (0, [(0, (1,2))]) = (0, [(0, (0, (1,1)))]) = (0, (0, (0, (0, (1,0))))) = 6
