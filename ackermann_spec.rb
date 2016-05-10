require './ackermann'

describe Ackermann do
	before(:each) do
		@ackermann = Ackermann.new
	end
	
	it "saves previous Ackermann results" do
		@ackermann.evaluate(4,1)
		expect(@ackermann.previous_results_hash).to eq({[4,0]=>13, [3,1]=>13, [4,1]=>65533, [3,13]=>65533})
	end	
	
	it "identifies previous Ackermann results" do
		expect(@ackermann.is_previous_result?([4,1])).to be true
	end	
	
	it "returns previous Ackermann results" do
		expect(@ackermann.return_previous_result([4,1])).to eq(65533)
	end		
	
	it "checks if number is equal to Float::INFINITY" do
		expect(@ackermann.is_infinity?(Float::INFINITY)).to be true
		expect(@ackermann.is_infinity?(3)).to be false
	end			
	
	it "raises a RangeError if solution grows too large" do
		expect{@ackermann.evaluate(4,8)}.to raise_error(RangeError)
	end
	
	it "raises a ArgumentError if input m or n are not Fixnum or Bignum" do
		expect{@ackermann.evaluate('a',8)}.to raise_error(ArgumentError)
		expect{@ackermann.evaluate(4,'b')}.to raise_error(ArgumentError)
	end	

	it "raises a RangeError if input m or n are > 0" do
		expect{@ackermann.evaluate(-1,8)}.to raise_error(RangeError)
	end
	
	it "implements Ackermann function correctly" do
		expect(@ackermann.ackermann_function(0,1)).to eq(2)
		expect(@ackermann.ackermann_function(1,0)).to eq([0,1])
		expect(@ackermann.ackermann_function(1,1)).to eq([0,[1,0]])
	end
	
	it "selects inner most nested array" do
		test_array = [1,[2,[3,[4,5]]]]
		nested_dimension = 3
		expect(@ackermann.select_nested_array(test_array, nested_dimension)).to eq([4,5])
	end	
	
	it "checks if Ackermann index are special cases of m equal to 0-3" do
		expect(@ackermann.is_special_case?([0,5])).to be true
		expect(@ackermann.is_special_case?([1,5])).to be true
		expect(@ackermann.is_special_case?([2,5])).to be true
		expect(@ackermann.is_special_case?([3,5])).to be true
		expect(@ackermann.is_special_case?([4,5])).to be false
	end		
	
	it "evaulates special cases of Ackermann index for m equal to 0-3" do
		expect(@ackermann.evaluate_special_case([0,5])).to eq(6)
		expect(@ackermann.evaluate_special_case([1,5])).to eq(7)
		expect(@ackermann.evaluate_special_case([2,5])).to eq(13)
		expect(@ackermann.evaluate_special_case([3,5])).to eq(253)
	end			

	it "checks if Ackermann indexes are pending a final integer result" do
		expect(@ackermann.is_pending_result?(1)).to be false
	end
	
	it "correctly evalutes the Ackermann function" do
		expect(@ackermann.evaluate(0,0)).to eq(1)
		expect(@ackermann.evaluate(1,0)).to eq(2)
		expect(@ackermann.evaluate(2,0)).to eq(3)
		expect(@ackermann.evaluate(3,0)).to eq(5)
		expect(@ackermann.evaluate(4,0)).to eq(13)
		expect(@ackermann.evaluate(5,0)).to eq(65533)
		expect(@ackermann.evaluate(0,1)).to eq(2)
		expect(@ackermann.evaluate(1,1)).to eq(3)
		expect(@ackermann.evaluate(2,1)).to eq(5)
		expect(@ackermann.evaluate(3,1)).to eq(13)
		expect(@ackermann.evaluate(4,1)).to eq(65533)
		expect(@ackermann.evaluate(0,2)).to eq(3)
		expect(@ackermann.evaluate(1,2)).to eq(4)
		expect(@ackermann.evaluate(2,2)).to eq(7)
		expect(@ackermann.evaluate(3,2)).to eq(29)
		expect(@ackermann.evaluate(0,3)).to eq(4)
		expect(@ackermann.evaluate(1,3)).to eq(5)
		expect(@ackermann.evaluate(2,3)).to eq(9)
		expect(@ackermann.evaluate(3,3)).to eq(61)
		expect(@ackermann.evaluate(0,4)).to eq(5)
		expect(@ackermann.evaluate(1,4)).to eq(6)
		expect(@ackermann.evaluate(2,4)).to eq(11)
		expect(@ackermann.evaluate(3,4)).to eq(125)
	end		
end