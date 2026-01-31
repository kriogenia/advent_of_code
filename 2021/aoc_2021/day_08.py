from typing import Iterable
from .common import read_lines
from collections import Counter


INPUT = "input/day_08.txt"

N_SEGMENTS: dict[int, str] = {
    2: "1",
    3: "7",
    4: "4",
    7: "8",
}

# easy sequential access to the sets of the low digits
LOW_SEGS: list[set[str]] = [{"c", "f"}, {"a", "c", "f"}, {"b", "c", "d", "f"}]

# segments based on their position
LEFT_SEGS: list[str] = ["b", "e"]
CENTER_SEGS: list[str] = ["a", "d", "g"]
RIGHT_SEGS: list[str] = ["c", "f"]
ALL_SEGS = {*LEFT_SEGS, *CENTER_SEGS, *RIGHT_SEGS}

TR_SEG = "c"
BR_SEG = "f"


def part_a(filename: str = INPUT):
    known_segs = [seg for seg in N_SEGMENTS]
    return sum(
        1
        for line in read_lines(filename)
        for digit in line.split(" | ")[1].split()
        if len(digit) in known_segs
    )


def parse_input(input: str) -> tuple[list[str], list[str], list[str]]:
    """
    Takes the input and returns three tuples with the numbers divide in three groups:
    - Digits with four or less segments
    - Digits with five segments
    - Digits with six segments
    The eight is useless so it gets droped out
    """
    digits = sorted(input.split(), key=len)
    return digits[:3], digits[3:6], digits[6:-1]


def filter_out_low_segments(candidates: dict[str, set[str]], low: list[str]):
    """With the low segments we can just intersect and subtract to reduce the candidates"""
    for digit, segs in zip(low, LOW_SEGS):
        for k, v in candidates.items():
            if k in segs:
                v &= set(digit)
            else:
                v -= set(digit)


def filter_out_five_segments(candidates: dict[str, set[str]], five: list[str]):
    """Intersects the left and center segments of these digits, identified by how much they are repeated"""
    char_counts = dict(Counter(ch for s in five for ch in s))

    center = set(k for k, v in char_counts.items() if v == 3)
    for seg in CENTER_SEGS:
        candidates[seg] &= center

    left = set(k for k, v in char_counts.items() if v == 1)
    for seg in LEFT_SEGS:
        candidates[seg] &= left


def filter_out_six_segments(candidates: dict[str, set[str]], six: list[str]):
    """Finds what of the right segments appears in all the three digits and complete the deducation"""
    remaining = candidates[BR_SEG]  # same for both segments
    bottom_right = next(c for c in remaining if all(c in digit for digit in six))
    candidates[BR_SEG] &= set(bottom_right)
    candidates[TR_SEG] -= set(bottom_right)


def to_string(chars: Iterable[str]) -> str:
    return "".join(sorted(c for c in chars))


def reverse_digits(candidates: dict[str, set[str]]) -> dict[str, str]:
    """Transforms the candidates into the matching strings"""
    flat = {k: v.pop() for k, v in candidates.items()}
    return {
        to_string(flat[c] for c in "abcefg"): "0",
        to_string(flat[c] for c in "acdeg"): "2",
        to_string(flat[c] for c in "acdfg"): "3",
        to_string(flat[c] for c in "abdfg"): "5",
        to_string(flat[c] for c in "abdefg"): "6",
        to_string(flat[c] for c in "abcdfg"): "9",
    }


def to_number(digit: str, reversed: dict[str, str]) -> str:
    if n := N_SEGMENTS.get(len(digit)):
        return n
    hash = to_string(c for c in digit)
    return reversed[hash]


def correlate(low: list[str], five: list[str], six: list[str]) -> dict[str, str]:
    candidates: dict[str, set[str]] = {k: ALL_SEGS.copy() for k in ALL_SEGS}
    filter_out_low_segments(candidates, low)
    filter_out_five_segments(candidates, five)
    filter_out_six_segments(candidates, six)
    return reverse_digits(candidates)


def part_b(filename: str = INPUT):
    sum = 0
    for line in read_lines(filename):
        (input, output) = line.split(" | ")
        parsed = parse_input(input)
        reversed = correlate(*parsed)

        sum += int("".join(to_number(digit, reversed) for digit in output.split()))
    return sum


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
