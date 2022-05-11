from itertools import count
from operator import contains
import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

octopuses = []
for line in f:
	octopuses.append([int(level) for level in line.strip()])
f.close()

max_i = len(octopuses)
max_j = len(octopuses[0])

total = 0

def increase_and_check(i, j, list):
	octopuses[j][i] += 1			
	if octopuses[j][i] == 10:
		list.append((i, j))			

for _ in range(100):
	flashes = []
	for i in range(max_i):
		for j in range(max_j):
			increase_and_check(i, j, flashes)

	while len(flashes) > 0:
		(i, j) = flashes[0]					# increase neighbours
		flashes.remove((i, j))
		if i > 0:
			increase_and_check(i - 1, j, flashes)
			if j > 0:
				increase_and_check(i - 1, j - 1, flashes)
			if j < max_j - 1:
				increase_and_check(i - 1, j + 1, flashes)
		if i < max_i - 1:
			increase_and_check(i + 1, j, flashes)
			if j > 0:
				increase_and_check(i + 1, j - 1, flashes)
			if j < max_j - 1:
				increase_and_check(i + 1, j + 1, flashes)
		if j > 0:
			increase_and_check(i, j - 1, flashes)
		if j < max_j - 1:
			increase_and_check(i, j + 1, flashes)

	for i in range(max_i):
		for j in range(max_j):
			if octopuses[j][i] > 9:
				octopuses[j][i] = 0
				total += 1

print(f"The number of flashes at the end is {total}")