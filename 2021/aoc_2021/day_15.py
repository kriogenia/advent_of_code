from .common import read_lines
from queue import PriorityQueue

INPUT = "input/day_15.txt"


class Point:
    def __init__(self, position, risk):
        self.position = position
        self.risk = int(risk)
        self.neighbours = []
        self.visited = False

    def add_neighbour(self, neighbour):
        if neighbour:
            self.neighbours.append(neighbour)
            self.neighbours.sort(key=lambda n: n.risk)


coord = tuple[int, int]


def dijkstra(start: coord, points: dict[coord, Point]) -> dict[coord, float]:
    table = dict.fromkeys(points.keys(), float("inf"))
    # table = {p: float("inf") for p in points}
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


def parse(filename: str) -> tuple[dict[coord, Point], int, int]:
    points = {}
    for i, line in enumerate(read_lines(filename)):
        for j, char in enumerate(line):
            points[(i, j)] = Point((i, j), char)
    return points, i, j  # type: ignore (it is set by the first for loop)


def append_neighbours(points: dict[coord, Point]):
    for (i, j), point in points.items():
        point.add_neighbour(points.get((i, j - 1), None))
        point.add_neighbour(points.get((i, j + 1), None))
        point.add_neighbour(points.get((i - 1, j), None))
        point.add_neighbour(points.get((i + 1, j), None))


def part_a(filename: str = INPUT):
    points, last_i, last_j = parse(filename)
    append_neighbours(points)

    result = dijkstra((0, 0), points)
    return result[(last_i, last_j)]


def part_b(filename: str = INPUT):
    base_points, last_i, last_j = parse(filename)
    len_x, len_y = last_i + 1, last_j + 1

    points = base_points.copy()
    for (x, y), point in base_points.items():
        for i in range(5):
            for j in range(5):
                if i == 0 and j == 0:
                    continue
                new_pos = (x + i * len_x, y + j * len_y)
                new_risk = point.risk + i + j
                if new_risk > 9:
                    new_risk -= 9
                points[new_pos] = Point(new_pos, new_risk)

    append_neighbours(points)
    result = dijkstra((0, 0), points)

    return result[(len_x * 5 - 1, len_y * 5 - 1)]


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
