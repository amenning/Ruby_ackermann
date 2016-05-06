class Ackermann
	@@special_cases_hash = {
		0 => 'n+1',
		1 => 'n+2',
		2 => '2*n+3',
		3 => '2**(n+3)-3'
	}
	
	@@store_cases_hash = {
		[0,0] => 1,
		[1,0] => 2,
		[2,0] => 3
	}
	
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
			#p total_array
			working_array = select_nested_array(total_array, degree_of_array)
			#p working_array
			if is_special_case?(working_array)
				return_result = evaluate_special_case(working_array)
			else
				return_result = ackermann_function(working_array[0], working_array[1])
			end
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
	
	def is_special_case?(test_array)
		return @@special_cases_hash.has_key?(test_array[0])
	end
	
	def evaluate_special_case(test_array)
		m = test_array[0]
		n = test_array[1]
		special_case_function = @@special_cases_hash[m]
		return eval(special_case_function)
	end 
	
	def previous_result?(test_array)
		return @@store_cases_hash.has_key?(test_array)
	end
	
	def return_previous_result(test_array)
		return @@store_cases_hash[test_array]
	end
	
	def store_new_result(test_array, result)
		@@store_cases_hash[test_array] = result
		return true
	end
end

# (1,0) = (1-1,1) = 2
# (2,0) = (2-1,1) = (1-1, (1,0)) = (0, 2) = 3
# (3,0) = (3-1,1) = (2-1, (2,0)) = (1-1, (1, 3-1)) = (0, [(0, (1,2))]) = (0, [(0, (0, (1,1)))]) = (0, (0, (0, (0, (1,0))))) = 6
