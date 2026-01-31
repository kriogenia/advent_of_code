from typing import Callable
from .common import read_lines

INPUT = "input/day_03.txt"


def to_base_10(bit_array: list[int], power_of_2=1):
    """Recursively transform from bits to base 10 int"""
    if len(bit_array) == 0:
        return 0

    bit = bit_array.pop()
    return bit * power_of_2 + to_base_10(bit_array, power_of_2 * 2)


def part_a(filename: str = INPUT):
    lines = list(read_lines(filename))

    bit_count = [0] * (len(lines[0]) - 1)

    for line in read_lines(filename):
        for bit_pos in range(0, len(line) - 1):
            # Adding the bit is like counting the 1s
            bit_count[bit_pos] += int(line[bit_pos])

    needed = (len(lines) + 1) // 2
    gamma = [1 if bit > needed else 0 for bit in bit_count]
    epsilon = [1 - bit for bit in gamma]

    return to_base_10(gamma) * to_base_10(epsilon)


def filter_bit(lines: list[str], mapper: Callable[[str], str], pos: int = 0) -> str:
    if len(lines) == 1:
        return lines[0]

    # mapping to int and summing would also work but this is probably faster
    number_of_1s = sum(1 for line in lines if line[pos] == "1")
    bit = mapper("1" if number_of_1s * 2 >= len(lines) else "0")

    new_lines = [line for line in lines if line[pos] == bit]
    return filter_bit(new_lines, mapper, pos + 1)


def part_b(filename: str = INPUT):
    lines = [line.rstrip() for line in read_lines(filename)]

    def to_array(bit_str: str):
        return [int(c) for c in bit_str]

    oxygen = to_array(filter_bit(lines, lambda x: x))
    co2 = to_array(filter_bit(lines, lambda x: "0" if x == "1" else "1"))

    return to_base_10(oxygen) * to_base_10(co2)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
