from itertools import pairwise

from .common import read_lines

INPUT = "input/day_14.txt"


def parse(filename) -> tuple[str, dict[str, str]]:
    lines = read_lines(filename)
    template = next(lines)
    _skip = next(lines)

    rules = {}
    for line in lines:
        [left, *_, right] = line.split(" ")
        rules[left] = right

    return template, rules


def run(filename, steps: int = 10):
    def store(pair, map, count=1):
        map[pair] = map.get(pair, 0) + count

    template, rules = parse(filename)

    pairs = {}
    for left, right in pairwise(template):
        store(left + right, pairs)

    for _ in range(steps):
        next = {}
        for pair, count in pairs.items():
            new = rules[pair]
            if new is not None:
                store(pair[0] + new, next, count)
                store(new + pair[1], next, count)
            else:
                store(pair, new, count)
        pairs = next

    single_letters = {}
    for key, count in pairs.items():
        store(key[0], single_letters, count)
    store(template[-1], single_letters)

    return max(single_letters.values()) - min(single_letters.values())


def part_a(filename: str = INPUT):
    return run(filename, 10)


def part_b(filename: str = INPUT):
    return run(filename, 40)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
