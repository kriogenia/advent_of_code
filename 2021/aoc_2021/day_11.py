from typing import Callable
from .common import read_lines

INPUT = "input/day_11.txt"


def run(filename: str, condition: Callable[[int], bool]):
    octopuses = [[int(level) for level in line] for line in read_lines(filename)]

    max_i, max_j = len(octopuses), len(octopuses[0])

    def increase_and_check(i: int, j: int, lst: list[tuple[int, int]]):
        octopuses[j][i] += 1
        if octopuses[j][i] == 10:
            lst.append((i, j))

    total = 0
    iter = 1

    while condition(iter):
        flashes = []
        for i in range(max_i):
            for j in range(max_j):
                increase_and_check(i, j, flashes)

        while len(flashes) > 0:
            i, j = flashes[0]  # increase neighbours
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

        if total - pre == max_i * max_j:  # all flashed
            return iter

        iter += 1

    return total


def part_a(filename: str = INPUT):
    return run(filename, lambda i: i <= 100)


def part_b(filename: str = INPUT):
    return run(filename, lambda _: True)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
