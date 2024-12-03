import pathlib
from util import to_base_10

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

lines = 0
bit_count = [0] * 12 # array with the bit size of the inputs

for line in f:
	for bit_pos in range(0, len(line) - 1):
		bit_count[bit_pos] += int(line[bit_pos])	# Adding the bit is like counting the 1s
	lines += 1

# over 500 means that more 1's were present, otherwise 0 was a more prevalent bit
gamma = list(map(lambda b: 1 if b > 500 else 0, bit_count))
epsilon = list(map(lambda b: 1 - b, gamma))

print(f'The gamma rate is {gamma}')
print(f'The epsilon rate is {epsilon}')	# Epsilon will be the inverse of gamma

gamma = to_base_10(gamma)
epsilon = to_base_10(epsilon)
print(f'Gamma in base 10 is {gamma}')
print(f'Epsilon in base 10 is {epsilon}')
print(f'The power consumption of the submarine is {gamma * epsilon}')

f.close()