##
#	Calculator by Pratik Pramanik
#

# add a method to String to check if valid integer
class String
    def is_int?
       !!(self =~ /\A[-+]?[0-9]+\z/)
    end
end

=begin
	function: mathString
	Takes a string, detects if it is a valid equation,
	and spits out the answer as a string
=end
def mathString(input)
	calc_stack = input.split(" ").reverse!
	solution = []
	
	# Reversing the input allows us pop segments in order
	while !calc_stack.empty?
		segment = calc_stack.pop
		operation = 0
		
		# check for double operand
		if ["*","/","-","+"].include?  segment
			if ["*","/","-","+"].include? calc_stack.last
				return "not a valid expression"
			end
		end
		
		# handle multiplication/division first
		case segment
		when "/"
			if calc_stack.last.is_int?
				operation = solution.pop / calc_stack.pop.to_f
			end
			solution << operation
		when "*"
			if calc_stack.last.is_int?
				operation = solution.pop * calc_stack.pop.to_f
			end
			solution << operation
		when "+", "-"
			solution << segment #save for later
		else
			if segment.is_int?
				solution << segment.to_i
			else
				return "not a valid expression"
			end
		end
	end
	
	# Reverse left over operations for popping
	solution = solution.reverse!
	buffer = nil
	
	# Adding and subtracting, until only solution is left
	while solution.length > 1
		segment = solution.pop
		
		case segment
		when "+"
			operation = buffer.to_f + solution.pop.to_f
			solution << operation
			buffer = nil
		when "-"
			operation = buffer.to_f - solution.pop.to_f
			solution << operation
			buffer = nil
		else
			buffer = segment # store current segment in buffer
		end
		
	end
	
	# return string with answer
	solution.first.to_s
end

# Test cases
printf "1 + 1 = %s\n", mathString("1 + 1")
printf "2 - 1 = %s\n", mathString("2 - 1")
printf "2 * 16 = %s\n", mathString("2 * 16")
printf "16 / 8 = %s\n", mathString("16 / 8")
printf "invalid = %s\n", mathString("invalid")
printf "16 / 8 * 32 = %s\n", mathString("16 / 8 * 32")
printf "16 / 8 + 2 = %s\n", mathString("16 / 8 + 2")
printf "0 + 0 * 0 / 0 - 0 = %s\n", mathString("0 + 0 * 0 / 0 - 0")
printf "13 * 256 * 33 / 4 - 20000000000 = %s\n", mathString("13 * 256 * 33 / 4 - 20000000000")
printf "10 + 2 * 3 / 4 = %s\n", mathString("10 + 2 * 3 / 4")
printf "345 * * = %s\n", mathString("345 * *")
printf "3 + * = %s\n", mathString("3 + *")
printf "   44 * test = %s\n", mathString("   44 * test")
printf "test + 44 = %s\n", mathString("test + 44")

# Allow user to enter additional cases
active = true
while active
	print "Calculate: "
	input = gets

	# exit if 'exit' typed
	if input.chomp.eql? "exit"
		active = false
	else
		print input.chomp + " = "
		
		# offload to dedicated methods
		answer = mathString(input);
		
		printf "%s\n", answer
	end
end
