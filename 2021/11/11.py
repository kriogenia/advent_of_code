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

first = -1
total = 0
at_hundred = 0


def increase_and_check(i, j, list):
    octopuses[j][i] += 1
    if octopuses[j][i] == 10:
        list.append((i, j))


iter = 0
while iter < 100 or first == -1:
    flashes = []
    for i in range(max_i):
        for j in range(max_j):
            increase_and_check(i, j, flashes)

    while len(flashes) > 0:
        (i, j) = flashes[0]  # increase neighbours
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

    pre = total
    for i in range(max_i):
        for j in range(max_j):
            if octopuses[j][i] > 9:
                octopuses[j][i] = 0
                total += 1

    if total - pre == max_i * max_j and first == -1:  # all flashed
        first = iter

    if iter == 100 - 1:
        at_hundred = total

    iter += 1

print(f"The number of flashes at the step 100 is {at_hundred}")
print(f"The first step where all octopuses did flash was {first + 1}")
