import pathlib
from util import Point, line_to_points, check_lines

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

lines = list(map(lambda l: line_to_points(l), f.read().splitlines()))
f.close()

# Check horizontal neighbours
check_lines(lines)

# Transpose the matrix
transposed = [[lines[j][i] for j in range(len(lines))] for i in range(len(lines[0]))]

# Check horizontal neighbours of the transposed (original, verticals)
check_lines(transposed)

# Flat the matrix and transform the points to their risks
risk = [point.value + 1 for line in lines for point in line if point.low_point]

print(f"The total risk is {sum(risk)}")
