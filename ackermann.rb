#The Ackermann class contain custom methods to implement the Ackermann function. As
#defined on wikipedia (https://en.wikipedia.org/wiki/Ackermann_function), "the Ackermann
#function is one of the simplest and earliest discovered examples of a total computable
#function that is not primitive recursive."  
#This function is defined as follows:
# 		
#A(m,n) =
#- n+1					if m = 0
#- A(m-1, 1)			if m > 0 and n = 0
#- A(m-1, A(m, n-1))	if m > 0 and n > 0
#
#The methods below are also implemenented with the following constraints:
#
#"Implement an Ackermann's function
#- that does not recompute already-solved values
#- that optimizes low values of m as special cases
#- without using recursive function calls"
#
#This version avoids recursive function calls by using a nested multidimensional arrays.
#Each loop works on the inner most nested 2D array as the indexes for the Ackermann function 
#until the entire nested array collapses into a single Fixnum or Bignum integer. For example:
#- A(1,1) can be written as [1,1]
#This would be evaluated as follows:
#1. \[1,1] 	#This is defined to have nested array dimension of 0
#2. \[0,[1,0]] #Note this nested array is defined to have nested dimension of 1; the working array [1,0] would be evaluted next
#3. \[0,[0,1]] #This still has a nested dimension of 1; the working array [0,1] would be evaluted next
#4. \[0,2]
#5. 3
#
#Avoiding the use of recursive function calls is benefical as this prevents SystemStackError of the stack level becoming too deep
#In addition, the avoidance of recrusive function calls could all this method to be modified to allow for pausing a calculation and returning later
# 
#By saving previously calculated Ackermann results, this will optimize future attempts to calculate the same results by only requiring a single hash lookup in a single interation
#
#Since there are special cases where n = 0 and m is 0-3, this also optimizes these Ackermann indexes and avoides uncessasry iterations
#
#Author::		Carl Andrew Menning 
#Version::		0.0.1
#License::		Distributed under the same terms as Ruby
class Ackermann	
	#Class variable that stores optimized functinos for low values of m as defined
	#at Wolfram Mathworld (http://mathworld.wolfram.com/AckermannFunction.html)
	#This hash contain keys as defined of interger values of the first ackermann 
	#parameter "m" and returns a string with the expression to be evaluated based 
	#on the second paramter "n".  This can be evaulated using eval() with a previously
	#defined local variable "n" value. 
	@@special_cases_hash = {
		0 => 'n+1',
		1 => 'n+2',
		2 => '2*n+3',
		3 => '2**(n+3)-3'
	}
	
	#Class variable that stores previously calculated results to be used first and available for any
	#instances of the Ackermann class
	#The key is the Ackermann index array [m,n]
	#The value is the overall final integer value associated with A(m,n)
	@@previous_results_hash = {}

	#The initialize method creates an instance hash to store pending solved ackermann results
	#called @pending_results_hash
	#
	#*Args*	  :
	#- no Arguments
	#*Returns* :
	#- new Ackermann instance object
	#*Raises*  :
	#- This method contains no additional error checks
	def initialize
		#Instance variable that stores pending Ackermann indexes [m,n] for new Ackermann(m,n) values
		#The key is the specified dimensional level of the overall Ackermann nested array being evaluated
		#The value is the associated Ackermann index array(s) [[m,n]]
		@pending_results_hash = {}
	end
	
	#The evaluate method is the main method used to calculate the final integer value of a given
	#Ackermann index. For example,  A(1,1) would result in 3.  
	#
	#*Args*	  :
	#- +m+ -> first integer parameter for the ackermann function
	#- +n+ -> second integer parameter for the ackermann function 
	#*Returns* :
	#- final integer solution to Ackermann function
	#*Raises*  :
	#- RangeError if integer solution grows too large
	def evaluate(m, n)
		#Set dimensional level of nested array to 1
		dimension_of_nested_array = 0
		#Create overall total array to be monitored
		total_array = [m, n]
		#While dimension of nested arrays is >= 0 (i.e. not an integer), continue loop
		while dimension_of_nested_array >= 0 do
			# 1. Set working array containing only integers to be evaluated
			working_array = select_nested_array(total_array, dimension_of_nested_array)
			# 2. Check if current Ackermann indexes have been solved before; if not, mark indexes as pending final integer result
			if (!is_previous_result?(working_array))
				#Store new result in pending_results_hash using current dimension of nested array as key and current Ackermann indexes as the value
				store_new_pending_result([working_array[0],working_array[1]], dimension_of_nested_array)
			end
			
			# 3. Calculate result using following order
			# 3a. Return previously calculated result if stored in @@previous_results_hash
			if (is_previous_result?(working_array) && return_previous_result(working_array)!=nil)
				return_result = return_previous_result(working_array)
			# 3b. Return result if part of special cases where m is equal to 0-3
			elsif is_special_case?(working_array)
				return_result = evaluate_special_case(working_array)
			# 3c. Return result using brute force Ackermann function
			else
				return_result = ackermann_function(working_array[0], working_array[1])
			end
			
			# 4. Check if result has become too large and has been defined as "infinity" to prevent infinit loop
			if is_infinity?(return_result)
				# Clear pending results to clean up current iteration
				@pending_results_hash.clear
				# Raise RangeError to warn user
				raise RangeError, "Number became too large"
			end
			
			# 5. Check if result is an array and/or a nested array, or has collapsed to an integer
			if return_result.kind_of?(Array)
				#If result has created a further nested array, increase dimension of nested array
				if return_result[1].kind_of?(Array)
					dimension_of_nested_array += 1
				end
				#Adjust working array for next loop
				working_array[0] = return_result[0]
				working_array[1] = return_result[1]
			
			# If return result has collapsed to an integer value, store new result if listed as pending and adjust dimension of overall nested array
			else				
				if is_pending_result?(dimension_of_nested_array)
					pending_result_array = get_pending_array(dimension_of_nested_array)
					define_new_result(dimension_of_nested_array, return_result)
				end
				
				dimension_of_nested_array -= 1
				
				#Check if collapsed integer result still is contained within a higher level array or if all arrays have collapsed to a single integer
				if dimension_of_nested_array >= 0 
					#Adjust working array one level up from current position to select outer array containing the current solution
					working_array = select_nested_array(total_array, dimension_of_nested_array)
					working_array[1] = return_result
				else
					#Assign final overall collapsed result to local variable answer
					answer = return_result
				end
			end
		end
		# Return final integer value for given overal Ackermann indexes
		return answer
	end

	#The ackermann_function method is the brute force implementation of the ackermann function
	#The ackermann function is defined as A(m,n) =
	#- n+1					if m = 0
	#- A(m-1, 1)			if m > 0 and n = 0
	#- A(m-1, A(m, n-1))	if m > 0 and n > 0
	#
	#*Args*	  :
	#- +m+ -> first integer parameter for the ackermann function
	#- +n+ -> second integer parameter for the ackermann function
	#*Returns* :
	#- integer (n+1) if m = 0
	#- array [m-1,1] if n = 0
	#- nested array [m-1, [m, n-1]] if m > 0 and n > 0
	#*Raises*  :
	#- +ArgumentError+ -> if input "m" or "n" is not of type Fixnum or Bignum
	#- +RangeError+ -> if input "m" or "n" is not >= 0
	def ackermann_function(m, n)
		# Check if m and n are of type Fixnum or Bignum, otherwise raise ArgumentError
		if !((m.is_a?(Fixnum) || m.is_a?(Bignum)) && (n.is_a?(Fixnum) || n.is_a?(Bignum)))
			raise ArgumentError, "Both input parameters (m and n) must be of type Fixnum or Bignum"
		# Check if m and n are both equal to or greater than 0, otherwise raise RangeError
		elsif(m<0 || n<0)
			raise RangeError, "Both input paramters (m and n) must be equal to or greater than 0"
		end
		
		if m == 0
			return n+1
		elsif n == 0
			return [m-1,1]
		else
			return [m-1, [m, n-1]]
		end
	end	
	
	#The select_nested_array method uses a loop to select the inner most nested array containing only integers
	#from the supplied nested array
	#
	#*Args*	  :
	#- +nested_array+ -> array containing variable nested arrays   
	#*Returns* :
	#- inner most array [m,n] as specified by the desired nested_array_dimension
	#*Raises*  :
	#- This method contains no additional error checks		
	def select_nested_array(nested_array, nested_array_dimension)
		return_array_reference = nested_array
		#Use for loop to iterate inwards on the 2nd element of each nested array until specified nested array is reached
		for dimension in 0..(nested_array_dimension-1) do
			return_array_reference = return_array_reference[1]
		end
		#Return nested array [m,n]
		return return_array_reference
	end

	#The is_special_case? method checks if a pair of Ackermann integer indexes (m,n) has
	#a previously calculated final integer result in the class variable @@special_cases_hash
	#
	#*Args*	  :
	#- +ackermann_index_array+ -> array containing ackermann integer indexes [m,n]
	#*Returns* :
	#- true if class variable @@special_cases_hash contains the supplied Ackermann indexes
	#- false otherwise 
	#*Raises*  :
	#- This method contains no additional error checks
	def is_special_case?(ackermann_index_array)
		return @@special_cases_hash.has_key?(ackermann_index_array[0])
	end

	#The evaluate_special_case method returns a final integer solution for a pair of Ackermann integer
	#indexes (m,n) based on the evaluted equation supplied by the @@special_cases_hash
	#
	#*Args*	  :
	#- +ackermann_index_array+ -> array containing ackermann integer indexes [m,n]
	#*Returns* :
	#- integer value for evaluated special cases
	#*Raises*  :
	#- This method contains no additional error checks	
	def evaluate_special_case(ackermann_index_array)
		# assigned first local Ackermann index m
		m = ackermann_index_array[0]
		# assigned first local Ackermann index n
		n = ackermann_index_array[1]
		# Obtain string representation of simpilified solutions for special cases
		special_case_function = @@special_cases_hash[m]
		# Evaluate string representation using local variable n and return integer value solution
		return eval(special_case_function)
	end 

	#The is_pending_result method checks if a pair of Ackermann integer indexes (m,n) is 
	#has been added to the instance variable @pending_results_hash
	#
	#*Args*	  :
	#- +nested_array_dimension+ -> dimension of the overall Ackermann nested array
	#*Returns* :
	#- true if instance variable @pending_results_hash contains the supplied nested array dimension as a key
	#- false if instance variable @pending_results_hash does not contain the supplied nested array dimension as a key
	#*Raises*  :
	#- This method contains no additional error checks	
	def is_pending_result?(nested_array_dimension)
		return @pending_results_hash.has_key?(nested_array_dimension)
	end

	#The get_pending_array method returns the Ackermann indexes as an array [m,n] that corresponds
	#to the assigned pending nested array dimension of the overall Ackermann nested array
	#
	#*Args*	  :
	#- +nested_array_dimension+ -> dimension of the overall Ackermann nested array
	#*Returns* :
	#- array with Ackermann indexes [m,n]
	#*Raises*  :
	#- This method contains no additional error checks
	def get_pending_array(nested_array_dimension)
		return @pending_results_hash[nested_array_dimension]
	end

	#The store_new_pending_result method is intended to store a new Ackermann index array associated
	#with a given dimensional level of the overall Ackermann nested array being evaluated.  This will store
	#the new ackermann index array [m,n] as a value associated with the key being the specified nested array dimension
	#in the instance variable @pending_results_hash.
	#
	#*Args*	  :
	#- +ackermann_index_array+ -> array containing ackermann integer indexes [m,n]
	#- +mark_dimension_to_save+ -> specified dimensonal level of overall Ackermann nested array being evaluated
	#*Returns* :
	#- true if no error is encountered
	#*Raises*  :
	#- This method contains no additional error checks
	def store_new_pending_result(ackermann_index_array, mark_dimension_to_save)
		if @pending_results_hash[mark_dimension_to_save] != nil
			@pending_results_hash[mark_dimension_to_save] << ackermann_index_array
		else
			@pending_results_hash[mark_dimension_to_save] = [ackermann_index_array]
		end
		return true
	end

	#The define_new_result method is intended to store a final new integer result for a previously
	#pending ackerman index array.  It deletes the ackerman index array from the pending @pending_results_hash 
	#instance variable and stores the new result in the class variable @@previous_results_hash
	#
	#*Args*	  :
	#- +nested_array_dimension+ -> dimension of the overall Ackermann nested array
	#- +new_result+ -> final integer value to be associated with Ackermann index array
	#*Returns* :
	#- true if no error is encountered
	#*Raises*  :
	#- This method contains no additional error checks
	def define_new_result(nested_array_dimension, new_result)
		@pending_results_hash[nested_array_dimension].each do |m, n|
			@@previous_results_hash[[m,n]] = new_result
		end
		@pending_results_hash.delete(nested_array_dimension)
		return true
	end		

	#The is_previous_result? method returns a boolean upon checking if
	#@@previous_results_hash variable contains a key based on an array of ackermann indexes
	#
	#*Args*	  :
	#- +ackermann_index_array+ -> array containing ackermann integer indexes [m,n]
	#*Returns* :
	#- true if ackermann index array key is found in class variable @@previous_results_hash
	#- false if ackermann index array key is not found
	#*Raises*  :
	#- This method contains no additional error checks
	def is_previous_result?(ackermann_index_array)
		return @@previous_results_hash.has_key?(ackermann_index_array)
	end

	#The return_previous_result method returns a previous solved saved result from the 
	#@@previous_results_hash variable based on an array of ackermann indexes
	#
	#*Args*	  :
	#- +ackermann_index_array+ -> array containing ackermann integer indexes [m,n]
	#*Returns* :
	#- stored integer value if ackermann index array key is found in class variable @@previous_results_hash
	#- nil if ackermann index array key is not found
	#*Raises*  :
	#- This method contains no additional error checks
	def return_previous_result(ackermann_index_array)
		return @@previous_results_hash[ackermann_index_array]
	end	
	
	#The is_infinity? method checks if a value is equal to Float::INFINITY
	#
	#*Args*	  :
	#- +value+ -> value to check if equal to Float::INFINITY
	#*Returns* :
	#- true if value is equal to Float::INFINITY
	#- false if value is not equal to Float::INFINITY
	#*Raises*  :
	#- This method contains no additional error checks
	def is_infinity?(value)
		return value == Float::INFINITY
	end
	
	#The previous_results_hash method allows access to the class variable of the same name
	def previous_results_hash
		@@previous_results_hash
	end
end