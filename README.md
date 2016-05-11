# What's Ackermann

The Ackermann class contain custom methods to implement the Ackermann function. As
defined on wikipedia (https://en.wikipedia.org/wiki/Ackermann_function), "the Ackermann
function is one of the simplest and earliest discovered examples of a total computable
function that is not primitive recursive."  

This function is defined as follows:
 		
A(m,n) =
* n+1					if m = 0
* A(m-1, 1)			if m > 0 and n = 0
* A(m-1, A(m, n-1))	if m > 0 and n > 0

## Features of Ackermann

* 	does not recompute already-solved values
* 	optimizes low values of m as special cases
*	does not use recursive function calls

## How to use

This is what you need to do to use this custom Ackermann class:

1.  Ensure you have ruby installed on your machine

2.  Download this repository and require the ackermann.rb file in your program

3.  Create a Ackermann instance and call the evaluate method 

```bash
# Require the ackermann.rb file in your program with the correct pathname
require './ackermann'

# Create a new instance of the Ackermann class
ackermann = Ackermann.new

# Call the Ackermann evaluate method to calculate the final integer value associated with the given Ackermann indexes
ackermann.evaluate(0,0) # This will return 1
ackermann.evaluate(3,4) # This will return 125
ackermann.evaluate(4,1) # This will return 65533
```

## The Author

This custom ackermann evaluate method was created by Carl Andrew Menning