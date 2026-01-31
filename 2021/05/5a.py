import pathlib
from util import parse_line, add_to_map, get_range

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

spots = dict()

for line in f:
    (sx, sy), (ex, ey) = parse_line(line)
    if sx == ex:
        for i in range(*get_range(sy, ey)):
            add_to_map(spots, sx, i)
    elif sy == ey:
        for i in range(*get_range(sx, ex)):
            add_to_map(spots, i, sy)

overlaps = {k: v for k, v in spots.items() if v > 1}
print(f"The number of times two lines overlap is {len(overlaps)}")
