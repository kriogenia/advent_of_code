import pathlib
from pydoc import doc

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

coordinates = []
folds = []

for line in f:
    line = line.strip()
    if len(line) == 0:
        continue
    if line.startswith("fold along "):
        folds.append(line.strip("fold along "))
    else:
        [x, y] = line.split(",")
        coordinates.append((int(x), int(y)))

(fold_axis, fold_line) = folds[0].split("=")
fold_line = int(fold_line)

if fold_axis == "y":
    for x, y in coordinates:
        if y > fold_line:
            coordinates.append((x, fold_line - (y - fold_line)))
    result = set(filter(lambda xy: xy[1] < fold_line, coordinates))
else:
    for x, y in coordinates:
        if x > fold_line:
            coordinates.append((fold_line - (x - fold_line), y))
        result = set(filter(lambda xy: xy[0] < fold_line, coordinates))

print(f"The numer of dots after the first fold is {len(result)}")
