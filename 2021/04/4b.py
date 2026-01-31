import pathlib
from util import get_game

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")

numbers, boards = get_game(open(path, "r"))

winner = None
last_number = 0

for n in numbers:
    to_remove = []
    for b in boards:
        b.cross(n)
        if b.check_win():
            to_remove.append(b)  # Store boards to remove

    for b in to_remove:  # Remove boards
        boards.remove(b)

    if len(boards) == 0:
        winner = to_remove[0]  # Save winners
        last_number = n
        break

sum = winner.sum()
print(f'We have a "winner" with score {sum}')
print(f"The last read number was {last_number}")
print(f"The solution therefore is {last_number * sum}")
