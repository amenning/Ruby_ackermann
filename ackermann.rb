class Ackermann
	def function(m, n)
		if m == 0
			return n+1
		elsif n == 0
			return function(m-1,1)
		else
			return function(m-1, function(m, n-1))
		end
	end
end

# (1,0) = (1-1,1) = 2
# (2,0) = (2-1,1) = (1-1, (1,0)) = (0, 2) = 3
# (3,0) = (3-1,1) = (2-1, (2,0)) = (1-1, (1, 3-1)) = (0, [(0, (1,2))]) = (0, [(0, (0, (1,1)))]) = (0, (0, (0, (0, (1,0))))) = 6
