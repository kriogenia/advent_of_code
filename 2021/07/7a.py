import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

crabs = [int(age) for age in f.readline().split(',')]
f.close()

# Calculate median
crab_list = crabs.copy()
while len(crab_list) > 2:	# we keep the last two as it's an even list of numbers
	crab_list.remove(max(crab_list))
	crab_list.remove(min(crab_list))
median = (crab_list[0] + crab_list[1]) // 2

sum = 0
for crab in crabs:
	sum += abs(median - crab)

print(f'The best position to align the crabs is {sum}')