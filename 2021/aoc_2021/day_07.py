from math import floor, ceil

from .common import input

INPUT = "input/day_07.txt"


def parse(filename: str) -> list[int]:
    with input(filename) as f:
        return [int(age) for age in f.readline().split(",")]


def part_a(filename: str = INPUT):
    crabs = parse(filename)

    # Calculate median
    crab_list = crabs.copy()
    while len(crab_list) > 2:  # we keep the last two as it's an even list of numbers
        crab_list.remove(max(crab_list))
        crab_list.remove(min(crab_list))
    median = (crab_list[0] + crab_list[1]) // 2

    return sum(abs(median - crab) for crab in crabs)


def part_b(filename: str = INPUT):
    crabs = parse(filename)
    average = sum(crabs) / len(crabs)

    def calculate_fuel(avg: int):
        return sum(i for crab in crabs for i in range(abs(avg - crab) + 1))

    return min(calculate_fuel(avg) for avg in [floor(average), ceil(average)])


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
