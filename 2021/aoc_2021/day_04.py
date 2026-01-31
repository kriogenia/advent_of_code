from typing import Callable
from .common import input

INPUT = "input/day_04.txt"

BOARD_SIZE = 5


def parse_line(line: str, separator: str | None = None):
    return [int(n) for n in line.split(separator)]


class Board:
    numbers = []
    original = []
    pending_columns = []
    pending_rows = []

    def __init__(self, board: str):
        self.numbers = parse_line(board)
        self.original = parse_line(board)
        self.pending_columns = [BOARD_SIZE] * BOARD_SIZE
        self.pending_rows = [BOARD_SIZE] * BOARD_SIZE

    def cross(self, n: int):
        for i in range(len(self.numbers)):
            if self.numbers[i] == n:
                self.pending_rows[i // BOARD_SIZE] -= 1
                self.pending_columns[i % BOARD_SIZE] -= 1
                self.numbers[i] = -1
                break

    def check_win(self):
        def all_full(ls: list[int]):
            return any(x == 0 for x in ls)

        return all_full(self.pending_columns) or all_full(self.pending_rows)

    def sum(self):
        marked = sum(1 for n in self.numbers if n == -1)
        return sum(self.numbers) + marked


def get_game(filename: str):
    with input(filename) as f:
        numbers, *boards = f.read().rstrip().split("\n\n")
        numbers = parse_line(numbers, ",")
        boards = [Board(b) for b in boards]
    return numbers, boards


def run(filename: str, fun: Callable[[list[int], list[Board]], tuple[int, Board]]):
    numbers, boards = get_game(filename)
    last_number, winner = fun(numbers, boards)
    return last_number * winner.sum()


def part_a(filename: str = INPUT):
    def find_winner(numbers: list[int], boards: list[Board]) -> tuple[int, Board]:
        winner = None

        for n in numbers:
            for b in boards:
                b.cross(n)
                if b.check_win():
                    winner = b
                    break
            else:
                continue

            return n, winner

        raise RuntimeError("A winner must be found")

    return run(filename, find_winner)


def part_b(filename: str = INPUT):
    def find_survivor(numbers: list[int], boards: list[Board]) -> tuple[int, Board]:
        for n in numbers:
            to_remove = []
            for b in boards:
                b.cross(n)
                if b.check_win():
                    to_remove.append(b)

            for b in to_remove:
                boards.remove(b)

            if len(boards) == 0:
                return n, to_remove[0]

        raise RuntimeError("A winner must be found")

    return run(filename, find_survivor)


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
