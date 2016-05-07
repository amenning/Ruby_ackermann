class Ackermann
	@@special_cases_hash = {
		0 => 'n+1',
		1 => 'n+2',
		2 => '2*n+3',
		3 => '2**(n+3)-3'
	}
	
	@@store_cases_results_hash = {
		[0,0] => 1,
		[1,0] => 2,
		[2,0] => 3
	}
	
	@@pending_results_hash = {
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
			if (!is_previous_result?(working_array))
				#p 'Store new result'
				#p working_array
				store_new_pending_result([working_array[0],working_array[1]], degree_of_array)
				#p @@pending_results_hash
			end
			
			if (is_previous_result?(working_array) && return_previous_result(working_array)!=nil)
				return_result = return_previous_result(working_array)
			elsif is_special_case?(working_array)
				return_result = evaluate_special_case(working_array)
			else
				return_result = ackermann_function(working_array[0], working_array[1])
				
			end
			p return_result
			if is_infinity?(return_result)
				puts "Number was too large"
				gets
				break
			end
			
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
				
				if is_pending_result?(degree_of_array)
					pending_result_array = get_pending_array(degree_of_array)
					define_new_result(degree_of_array, pending_result_array,return_result)
					#p @@store_cases_results_hash
				end
				
				degree_of_array -= 1
				
				if degree_of_array >0 
					working_array = select_nested_array(total_array, degree_of_array)
					working_array[1] = return_result
				else
					answer = return_result
				end
			end
		end
		p 'Test end'
		p @@store_cases_results_hash
		p @@pending_results_hash
		gets
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
	
	def is_previous_result?(test_array)
		return @@store_cases_results_hash.has_key?(test_array)
	end
	
	def return_previous_result(test_array)
		return @@store_cases_results_hash[test_array]
	end
	
	def store_new_pending_result(test_array, mark_degree_to_save)
		@@pending_results_hash[mark_degree_to_save] = test_array
		return true
	end
	
	def define_new_result(array_degree, test_array, new_result)
		@@pending_results_hash.delete(array_degree)
		@@store_cases_results_hash[test_array] = new_result
		return true
	end
	
	def is_pending_result?(array_degree)
		return @@pending_results_hash.has_key?(array_degree)
	end
	
	def get_pending_array(array_degree)
		return @@pending_results_hash[array_degree]
	end
	
	def is_infinity?(value)
		return value == Float::INFINITY
	end
end

# (1,0) = (1-1,1) = 2
# (2,0) = (2-1,1) = (1-1, (1,0)) = (0, 2) = 3
# (3,0) = (3-1,1) = (2-1, (2,0)) = (1-1, (1, 3-1)) = (0, [(0, (1,2))]) = (0, [(0, (0, (1,1)))]) = (0, (0, (0, (0, (1,0))))) = 6
