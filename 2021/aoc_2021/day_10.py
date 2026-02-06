import functools
from typing import Callable

from .common import read_lines

INPUT = "input/day_10.txt"

open_chars = ["(", "[", "{", "<"]
close_chars = [")", "]", "}", ">"]


@functools.cache
def do_match(opener, closer):
    return open_chars.index(opener) == close_chars.index(closer)


def calc(
    line: str, not_match: Callable[[str], int], exit: Callable[[list[str]], int]
) -> int:
    openers = []
    for char in line:
        if char in open_chars:
            openers.append(char)
        else:
            if do_match(openers[-1], char):
                openers.pop()
            else:
                return not_match(char)
    return exit(openers)


def part_a(filename: str = INPUT):
    value = {")": 3, "]": 57, "}": 1197, ">": 25137}

    return sum(
        calc(
            line,
            not_match=lambda c: value[c],
            exit=lambda _: 0,
        )
        for line in read_lines(filename)
    )


def part_b(filename: str = INPUT):
    value = {"(": 1, "[": 2, "{": 3, "<": 4}

    def exit(openers: list[str]) -> int:
        score = 0
        for char in reversed(openers):
            score *= 5
            score += value[char]
        return score

    scores = [
        score
        for line in read_lines(filename)
        if (score := calc(line, not_match=lambda _: 0, exit=exit)) > 0
    ]

    scores.sort()
    return scores[int(len(scores) / 2)]


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
