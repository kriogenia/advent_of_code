from .common import read_lines

INPUT = "input/day_02.txt"


class ASub:
    x = 0
    y = 0

    def forward(self, d: int):
        self.x += d

    def up(self, d: int):
        self.y -= d

    def down(self, d: int):
        self.y += d

    def result(self) -> int:
        return self.x * self.y


class BSub:
    horizontal = 0
    depth = 0
    aim = 0

    def forward(self, d: int):
        self.horizontal += d
        self.depth += self.aim * d

    def up(self, d: int):
        self.aim -= d

    def down(self, d: int):
        self.aim += d

    def result(self) -> int:
        return self.horizontal * self.depth


def run(filename: str, submarine: ASub | BSub):
    for line in read_lines(filename):
        [direction, movement] = line.split(" ")
        submarine.__getattribute__(direction)(int(movement))

    return submarine.result()


def part_a(filename: str = INPUT):
    return run(filename, ASub())


def part_b(filename: str = INPUT):
    return run(filename, BSub())


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
