# Recursive function to convert bits to power of 10
def to_base_10(bit_array: "list[int]", power_of_2 = 1):
	if len(bit_array) == 0:		# Exit condition
		return 0
	bit = bit_array.pop()		# Return bit to use from the array
	# Multiply the bit by the position power of 2 and call the next
	return bit * power_of_2 + to_base_10(bit_array, power_of_2 * 2)

def to_array(bit_str: "list[str]"):
	return list(map(lambda c: int(c), bit_str))
