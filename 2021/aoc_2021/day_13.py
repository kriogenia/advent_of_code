from sys import stderr

from .common import read_lines

INPUT = "input/day_13.txt"


def parse_coordinates(lines_gen) -> list[tuple[int, int]]:
    coordinates = []
    for line in lines_gen:
        if len(line) == 0:
            break
        [x, y] = line.split(",")
        coordinates.append((int(x), int(y)))
    return coordinates


def parse_fold(line: str) -> tuple[str, int]:
    (fold_axis, fold_line) = line.strip("fold along ").split("=")
    return fold_axis, int(fold_line)


def fold_coordinates(coordinates, fold_axis, fold_line) -> int:
    if fold_axis == "y":
        axis = 1
        for c in coordinates:
            if c[axis] > fold_line:
                coordinates.append((c[0], 2 * fold_line - c[1]))
    else:
        axis = 0
        for c in coordinates:
            if c[axis] > fold_line:
                coordinates.append((2 * fold_line - c[0], c[1]))
    return axis


def part_a(filename: str = INPUT):
    lines_gen = read_lines(filename)
    coordinates = parse_coordinates(lines_gen)
    fold_axis, fold_line = parse_fold(next(lines_gen))
    axis = fold_coordinates(coordinates, fold_axis, fold_line)
    result = set(c for c in coordinates if c[axis] < fold_line)
    return len(result)


def part_b(filename: str = INPUT):
    lines_gen = read_lines(filename)
    coordinates = parse_coordinates(lines_gen)

    for line in lines_gen:
        fold_axis, fold_line = parse_fold(line)
        axis = fold_coordinates(coordinates, fold_axis, fold_line)
        coordinates = [c for c in coordinates if c[axis] < fold_line]

    result = set(coordinates)
    width = max(c[0] for c in coordinates)
    height = max(c[1] for c in coordinates)

    for j in range(height + 1):
        for i in range(width + 1):
            print("#" if (i, j) in result else " ", end="", file=stderr)
        print(file=stderr)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print("Part B:")
    part_b()
