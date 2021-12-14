import pathlib

DAYS = 80
RESET = 6
NEW = 8

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

fishes = list(map(lambda f: int(f), f.readline().split(",")))

for i in range(DAYS):
	fishes = [f - 1 for f in fishes]							# Advance day
	fishes.extend([NEW] * len([f for f in fishes if f == -1]))	# Reproduce
	fishes = [RESET if f == -1 else f for f in fishes]			# Reset

print(f'The day {DAYS} will be {len(fishes)} fishes.')