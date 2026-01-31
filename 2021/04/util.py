from io import TextIOWrapper


BOARD_SIZE = 5


def parse_line(line: str, separator: str | None = None):
    return list(map(lambda n: int(n), line.split(separator)))


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
        return any(map(lambda c: c == 0, self.pending_columns)) or any(
            map(lambda r: r == 0, self.pending_rows)
        )

    def sum(self):
        marked = len(list(filter(lambda n: n == -1, self.numbers)))
        return sum(self.numbers) + marked


def get_game(file: TextIOWrapper):
    numbers, *boards = file.read().rstrip().split("\n\n")
    numbers = parse_line(numbers, ",")  # List of numbers
    boards = list(map(lambda b: Board(b), boards))  # List of boards
    file.close()
    return numbers, boards
