class Point:
	value = 0
	low_point = True

	def __init__(self, value: str):
		self.value = int(value)

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