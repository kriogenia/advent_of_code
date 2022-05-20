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

points = dict()
lines = f.readlines()
for i in range(len(lines)):
	for j in range(len(lines[i].strip())):
		points[(i, j)] = Point((i, j), lines[i][j])
f.close()

# append neighbours
for (i, j), point in points.items():
	point.add_neighbour(points.get((i, j - 1), None))
	point.add_neighbour(points.get((i, j + 1), None))
	point.add_neighbour(points.get((i - 1, j), None))
	point.add_neighbour(points.get((i + 1, j), None))

def dijkstra(start):
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

result = dijkstra((0, 0))

print(f"The total risk of the best path is {result[(len(lines) - 1, len(lines[0].strip()) - 1)]}")