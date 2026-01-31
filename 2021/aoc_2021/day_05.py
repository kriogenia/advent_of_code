from typing import Callable
from .common import read_lines

INPUT = "input/day_05.txt"


def parse_line(line: str) -> tuple[tuple[int, ...], tuple[int, ...]]:
    start, end = line.split(" -> ")
    start = tuple(int(n) for n in start.split(","))
    end = tuple(int(n) for n in end.split(","))
    return start, end


def get_range(start: int, end: int):
    if start > end:
        return end, start + 1
    else:
        return start, end + 1


def add_to_map(spots: dict, *coords: int):
    key = str(coords)
    spots[key] = spots.get(key, 0)
    spots[key] += 1


def run(filename: str, els: Callable | None = None):
    spots = dict()

    for line in read_lines(filename):
        (sx, sy), (ex, ey) = parse_line(line)
        if sx == ex:
            for i in range(*get_range(sy, ey)):
                add_to_map(spots, sx, i)
        elif sy == ey:
            for i in range(*get_range(sx, ex)):
                add_to_map(spots, i, sy)
        elif els:
            els(spots, sx, sy, ex, ey)

    overlaps = {k: v for k, v in spots.items() if v > 1}
    return len(overlaps)


def part_a(filename: str = INPUT):
    return run(filename)


def part_b(filename: str = INPUT):
    def do_else(spots, sx, sy, ex, ey):
        def get_direction(start: int, end: int):
            return -1 if start > end else 1

        direction_x = get_direction(sx, ex)
        direction_y = get_direction(sy, ey)
        for i in range(abs(ex - sx) + 1):
            add_to_map(spots, sx + i * direction_x, sy + i * direction_y)

    return run(filename, do_else)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
