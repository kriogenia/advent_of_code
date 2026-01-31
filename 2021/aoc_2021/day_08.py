from .common import read_lines

INPUT = "input/day_08.txt"

SEGS_1 = 2
SEGS_4 = 4
SEGS_7 = 3
SEGS_8 = 7


def part_a(filename: str = INPUT):
    known_segs = [SEGS_1, SEGS_4, SEGS_7, SEGS_8]
    return sum(
        1
        for line in read_lines(filename)
        for digit in line.split(" | ")[1].split()
        if len(digit) in known_segs
    )


def part_b(filename: str = INPUT):
    raise NotImplementedError("TODO")


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    # print(f"Part B: {part_b()}")
