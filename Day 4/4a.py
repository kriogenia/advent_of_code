import pathlib
from util import parse_line

BOARD_SIZE = 5

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
				self.numbers[i] = 0
				break

	def check_win(self):
		return any(map(lambda c: c == 0, self.pending_columns)) or any(map(lambda r: r == 0, self.pending_rows))


##################################

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

numbers, *boards = f.read().rstrip().split("\n\n")
numbers = parse_line(numbers, ",")						# List of numbers
boards = list(map(lambda b: Board(b), boards))			# List of boards

winner = None
last_number = 0

for n in numbers:
	for b in boards:
		b.cross(n)
		if b.check_win():
			winner = b		# store winner
			break
	else:					# exit outer loop
		continue
	last_number = n			# store last number
	break

sum = sum(winner.numbers)
print(f'We have a winner with score {sum}')
print(f'The last read number was {last_number}')
print(f'The solution therefore is {last_number * sum}')

f.close()
