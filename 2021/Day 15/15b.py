import pathlib
from queue import PriorityQueue

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

class Point:
	position = (-1, -1)
	risk = 0
	neighbours = []
	visited = False

	def __init__(self, position, risk):
		self.position = position
		self.risk = int(risk)
		self.neighbours = []
		self.visited = False

	def add_neighbour(self, neighbour):
		if neighbour != None:
			self.neighbours.append(neighbour)
			self.neighbours.sort(key = lambda n: n.risk)	# sort to start travelling from most promising to least


def dijkstra(start, points):
	table = {p:float('inf') for p in points}
	table[start] = 0

	q = PriorityQueue()
	q.put((0, start))

	while not q.empty():
		_, position = q.get()
		point = points[position]
		point.visited = True

		for neighbour in point.neighbours:
			cost = neighbour.risk
			if not neighbour.visited:
				prev_cost = table[neighbour.position]
				new_cost = table[point.position] + cost
				if new_cost < prev_cost:
					q.put((new_cost, neighbour.position))
					table[neighbour.position] = new_cost
	return table

base_points = dict()
lines = f.readlines()
for i in range(len(lines)):
	for j in range(len(lines[i].strip())):
		base_points[(i, j)] = Point((i, j), lines[i][j])
f.close()

len_x = len(lines)
len_y = len(lines[0].strip())

points = base_points.copy()
for (x, y), point in base_points.items():
	for i in range(0, 5):
		for j in range(0, 5):
			if i == 0 and j == 0:
				continue
			new_pos = (x + i * len_x, y + j * len_y)
			new_risk = point.risk + i + j
			if new_risk > 9:
				new_risk -= 9
			points[new_pos] = Point(new_pos, new_risk)

# append neighbours
for (i, j), point in points.items():
	point.add_neighbour(points.get((i, j - 1), None))
	point.add_neighbour(points.get((i, j + 1), None))
	point.add_neighbour(points.get((i - 1, j), None))
	point.add_neighbour(points.get((i + 1, j), None))

result = dijkstra((0, 0), points)

print(f"The total risk of the best path is {result[(len_x * 5 - 1, len_y * 5 - 1)]}")