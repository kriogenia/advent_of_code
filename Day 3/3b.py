def not_(bit: str):
	return '0' if bit == '1' else '1'

def filter_bit(lines: "list[str]", pos: int, use_most_common: bool):
	if len(lines) == 1:			# Bit finding
		return lines[0]

	number_of_1s = len(list(filter(lambda b: b[pos] == '1', lines)))
	most_common = '1' if number_of_1s * 2 >= len(lines) else '0'
	bit = most_common if use_most_common else not_(most_common)

	return filter_bit(list(filter(lambda l: l[pos] == bit, lines)), pos + 1, use_most_common)


####################

import pathlib
from util import to_base_10, to_array

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
lines = open(path, "r").read().splitlines()

oxygen = to_array(filter_bit(lines, 0, True))
co2 = to_array(filter_bit(lines, 0, False))

print(f'The oxygen generator rating is {oxygen}')
print(f'The CO2 scrubber rating is {co2}')

oxygen = to_base_10(oxygen)
co2 = to_base_10(co2)
print(f'Oxygen in base 10 is {oxygen}')
print(f'CO2 in base 10 is {co2}')
print(f'The life support of the submarine is {oxygen * co2}')

f.close()