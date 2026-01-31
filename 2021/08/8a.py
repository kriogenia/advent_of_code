import pathlib
from util import flat_map

SEGS_1 = 2
SEGS_4 = 4
SEGS_7 = 3
SEGS_8 = 7

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

output = [
    output.strip().split()
    for (_, output) in map(lambda l: l.split(" | "), f.readlines())
]
f.close()

known = len([i for i in flat_map(output) if len(i) in (SEGS_1, SEGS_4, SEGS_7, SEGS_8)])

print(f"The number of known digits (1, 4, 7, 8) is {known}")
