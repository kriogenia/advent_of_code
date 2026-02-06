from .common import read_lines

INPUT = "input/day_09.txt"


class Point:
    value = 0
    low_point = True

    visited = False
    neighbours = []
    basin = []

    def __init__(self, value: str):
        self.value = int(value)
        self.neighbours = []
        self.basin = [self]

    def add(self, point):
        self.neighbours.append(point)

    def travel(self):
        if self.value == 9 or self.visited:  # Stop condition to elude 9's
            return []
        self.visited = True
        for point in self.neighbours:
            if abs(self.value - point.value) == 1:
                self.basin.extend(point.travel())
        return self.basin

    def check(self, other: "Point"):
        if self.value >= other.value:
            self.low_point = False


def line_to_points(line: str):
    points = []
    for char in line:
        points.append(Point(char))
    return points


def check_lines(lines: list[list[Point]]):
    for line in lines:
        prev = Point("10000")
        for current in line:
            prev.check(current)
            current.check(prev)
            prev = current


def graph_neighbours(matrix: list[list[Point]]):
    for line in matrix:
        prev_point, rest = line[0], line[1:]
        for point in rest:
            point.add(prev_point)
            prev_point.add(point)
            prev_point = point


def transpose(matrix: list[list[Point]]) -> list[list[Point]]:
    return [[matrix[j][i] for j in range(len(matrix))] for i in range(len(matrix[0]))]


def part_a(filename: str = INPUT):
    lines = [line_to_points(line) for line in read_lines(filename)]

    check_lines(lines)
    transposed = transpose(lines)
    check_lines(transposed)

    # Flat the matrix and transform the points to their risks
    return sum(point.value + 1 for line in lines for point in line if point.low_point)


def part_b(filename: str = INPUT):
    lines = [line_to_points(line) for line in read_lines(filename)]

    graph_neighbours(lines)
    lines = transpose(lines)
    graph_neighbours(lines)

    candidates = [point for line in lines for point in line if point.value < 9]
    basins = []

    while len(candidates) > 0:
        candidate = candidates[0]
        basin = candidate.travel()
        for point in basin:
            candidates.remove(point)
        basins.append(basin)

    sizes = [len(basin) for basin in basins]
    sizes.sort(reverse=True)

    solution = 1
    for i in range(0, 3):
        solution *= sizes[i]
    return solution


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
