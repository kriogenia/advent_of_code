def calculate_fuel(difference: int):
	sum = 0
	for i in range(difference + 1):
		sum += i
	return sum

#################################

import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

crabs = [int(age) for age in f.readline().split(',')]
f.close()

# Here we swap to the average
avg = sum(crabs) // len(crabs)

sum = 0
for crab in crabs:
	sum += calculate_fuel(abs(avg - crab))

print(f'The best position to align the crabs is {sum}')