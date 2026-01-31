import pathlib

DAYS = 80
RESET = 6
NEW = 8

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

fishes = [int(age) for age in f.readline().split(",")]
f.close()

# The first approach one can think of, very suboptimal. Part 2 has the good one.
for i in range(DAYS):
    fishes = [f - 1 for f in fishes]  # Advance day
    new_fishes = len([f for f in fishes if f == -1])  # Calculate reproduction
    fishes = [RESET if f == -1 else f for f in fishes]  # Reset
    fishes.extend([NEW] * new_fishes)  # Reproduce

print(f"The day {DAYS} will be {len(fishes)} fishes.")
