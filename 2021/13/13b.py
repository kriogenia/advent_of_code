from functools import reduce
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

for fold in folds:
    (fold_axis, fold_line) = fold.split("=")
    fold_line = int(fold_line)

    if fold_axis == "y":
        for x, y in coordinates:
            if y > fold_line:
                coordinates.append((x, fold_line - (y - fold_line)))
        coordinates = [coord for coord in coordinates if coord[1] < fold_line]
    else:
        for x, y in coordinates:
            if x > fold_line:
                coordinates.append((fold_line - (x - fold_line), y))
        coordinates = [coord for coord in coordinates if coord[0] < fold_line]

result = set(coordinates)
width = max(c[0] for c in coordinates)
height = max(c[1] for c in coordinates)

print("The resulting code is:")
for j in range(height + 1):
    for i in range(width + 1):
        print("#" if (i, j) in result else " ", end="")
    print()
