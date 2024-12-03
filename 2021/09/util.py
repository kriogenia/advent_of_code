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
		if (self.value == 9 or self.visited):		# Stop condition to elude 9's
			return []
		self.visited = True
		for point in self.neighbours:
			if abs(self.value - point.value) == 1:
				self.basin.extend(point.travel())
		return self.basin


def check_points(prev: Point, current: Point):
	if prev.value >= current.value:
		prev.low_point = False
	if current.value >= prev.value:
		current.low_point = False

def check_lines(lines: "list(list(Point))"):
	for line in lines:
		prev = Point(10000)
		for current in line:
			check_points(prev, current)
			prev = current

def line_to_points(line: str):
	points = []
	for char in line:
		points.append(Point(char))
	return points

def graph_neighbours(matrix: "list(list(Point))"):
	for line in matrix:
		prev_point, rest = line[0], line[1:]
		for point in rest:
			point.add(prev_point)
			prev_point.add(point)
			prev_point = point
