import pathlib
from util import line_to_points, graph_neighbours

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

lines = list(map(lambda l: line_to_points(l), f.read().splitlines()))
f.close()

# From matrix to graph
graph_neighbours(lines)
lines = [[lines[j][i] for j in range(len(lines))] for i in range(len(lines[0]))]
graph_neighbours(lines)

candidates = [point for line in lines for point in line]
candidates = [point for point in candidates if point.value < 9]
basins = []

while len(candidates) > 0:
	candidate = candidates[0]
	basin = candidate.travel()
	for point in basin:
		candidates.remove(point)
	basins.append(basin)

sizes = [len(basin) for basin in basins]
sizes.sort(reverse = True)

solution = 1
for i in range(0,3):
	solution *= sizes[i]
	
print(f'The sizes of the basins is {solution}')