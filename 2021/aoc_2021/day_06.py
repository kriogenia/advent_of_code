from .common import input

INPUT = "input/day_06.txt"

RESET = 6
NEW = 8


def parse(filename: str):
    with input(filename) as f:
        return [int(age) for age in f.readline().split(",")]


def part_a(filename: str = INPUT, days: int = 80):
    fishes = parse(filename)

    # The first approach one can think of, very suboptimal. Part 2 has the good one.
    for _ in range(days):
        fishes = [f - 1 for f in fishes]  # Advance day
        new_fishes = sum(1 for f in fishes if f == -1)  # Calculate reproduction
        fishes = [RESET if f == -1 else f for f in fishes]  # Reset
        fishes.extend([NEW] * new_fishes)  # Reproduce

    return len(fishes)


def age(ages: dict):
    for i in range(len(ages) - 1):
        ages[i] = ages[i + 1]


def part_b(filename: str = INPUT, days: int = 256):
    fishes = parse(filename)

    # if you want to optimize something, just use a hashmap
    ages = dict.fromkeys((age for age in range(NEW + 1)), 0)
    ages.update({f: fishes.count(f) for f in fishes})

    for _ in range(days):
        ready = ages[0]  # Get ready qty
        age(ages)  # Age all one day
        ages[RESET] += ready  # Reset ready fishes
        ages[NEW] = ready  # Add new fishes

    return sum(ages.values())


if __name__ == "__main__":
    print(f"Part A: {part_a()}")
    print(f"Part B: {part_b()}")
