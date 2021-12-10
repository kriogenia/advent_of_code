import sys
import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

BIG = 100000

counter = 0
line_number = 0

prev = sys.maxsize		# Big enough value to ignore first
last = [BIG, BIG, BIG]	# Hold the last three points

for x in f:
	# Get new three
	last[line_number % len(last)] = int(x)
	new = sum(last)
	# Check increment
	if (new > prev):
		counter += 1
	# Save and advance line
	prev = new
	line_number += 1

print(f'The number of three step increments was {counter}')
