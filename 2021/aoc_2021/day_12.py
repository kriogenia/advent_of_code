from .common import read_lines

INPUT = "input/day_12.txt"


LIMITS = {"start", "end"}


class Cave:
    def __init__(self, key: str):
        self.key = key
        self.small = key.islower()
        self.paths = []

    def add_path(self, cave):
        self.paths.append(cave)

    def travel(self, small_visited: set[str]) -> int:
        if self.small and self.key in small_visited:
            return 0

        small_visited.add(self.key)

        if self.key == "end":
            return 1

        return sum(path.travel(small_visited.copy()) for path in self.paths)

    def travel_with_one_revisit(
        self, small_visited: set[str], revisited: bool = False
    ) -> int:
        if self.small and self.key in small_visited:
            if not revisited and self.key not in LIMITS:
                revisited = True
            else:
                return 0

        small_visited.add(self.key)

        if self.key == "end":
            return 1

        return sum(
            path.travel_with_one_revisit(small_visited.copy(), revisited)
            for path in self.paths
        )


class CaveSystem:
    def __init__(self) -> None:
        self.caves = {}

    def new_path(self, s: str, e: str):
        start = self.add_or_get(s)
        end = self.add_or_get(e)
        start.add_path(end)
        end.add_path(start)

    def add_or_get(self, key: str):
        if key not in self.caves:
            self.caves[key] = Cave(key)
        return self.caves[key]


def part_a(filename: str = INPUT):
    caves = CaveSystem()
    for line in read_lines(filename):
        caves.new_path(*line.split("-"))
    return caves.caves["start"].travel(set())


def part_b(filename: str = INPUT):
    caves = CaveSystem()
    for line in read_lines(filename):
        caves.new_path(*line.split("-"))
    return caves.caves["start"].travel_with_one_revisit(set())


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
