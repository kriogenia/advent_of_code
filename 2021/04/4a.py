import pathlib
from util import get_game

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")

numbers, boards = get_game(open(path, "r"))

winner = None  # Storage variables
last_number = 0

for n in numbers:
    for b in boards:
        b.cross(n)
        if b.check_win():
            winner = b  # Store winner
            break
    else:  # Break outer loop
        continue
    last_number = n  # Store last number
    break

sum = winner.sum()
print(f"We have a winner with score {sum}")
print(f"The last read number was {last_number}")
print(f"The solution therefore is {last_number * sum}")
