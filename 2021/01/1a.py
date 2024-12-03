import sys
import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

counter = 0
prev = sys.maxsize	# Big enough value to ignore first

for line in f:
	new = int(line)
	if (new > prev):
		counter += 1
	prev = new

print(f'The number of increments was {counter}')

f.close()