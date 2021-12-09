import sys
import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

counter = 0
prev = sys.maxsize	# Big enough value to ignore first

for x in f:
	new = int(x)
	if (new > prev):
		counter += 1
	prev = new

print(counter)