import sys

from .common import lines

INPUT = "input/day_01.txt"


def part_a(filename: str = INPUT):
    counter = 0
    prev = sys.maxsize  # Big enough value to ignore first

    for line in lines(filename):
        new = int(line)
        if new > prev:
            counter += 1
        prev = new

    return counter


def part_b(filename: str = INPUT):
    BIG = 100_000

    counter = 0

    prev = sys.maxsize
    last = [BIG, BIG, BIG]  # could have been a fifo but this is better

    for i, line in enumerate(lines(filename)):
        last[i % len(last)] = int(line)
        new = sum(last)

        if new > prev:
            counter += 1

        prev = new

    return counter


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
