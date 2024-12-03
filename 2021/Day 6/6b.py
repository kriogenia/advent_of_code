def age(ages: dict):
	for i in range(len(ages) - 1):
		ages[i] = ages[i + 1]

#############################

import pathlib

DAYS = 256

RESET = 6
NEW = 8

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

fishes = [int(age) for age in f.readline().split(',')]
f.close()

# if you want to optimize something, just use a hashmap
ages = { age: 0 for age in range(NEW + 1)}
ages.update({ f: fishes.count(f) for f in fishes})	# would create something like {0: 0, 1: 163, 2: 29, ..., 8: 0}

for day in range(DAYS):
	ready = ages[0]			# Get ready qty
	age(ages)				# Age all one day
	ages[RESET] += ready	# Reset ready fishes
	ages[NEW] = ready		# Add new fishes

sum = sum(ages.values())

print(f'After {DAYS} days the total fishes will be {sum}')