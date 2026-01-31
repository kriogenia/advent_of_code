import pathlib
from pydoc import doc

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

STEPS = 10

# store template array
template = list()
template_code = f.readline().strip()
for char in template_code:
    template.append(char)

f.readline()  # ignore empty line

# store steps
rules = dict()
for line in f:
    [left, *_, right] = line.strip().split(" ")
    rules[(left[0], left[1])] = right
f.close()

# iterate applying pairs
for _ in range(STEPS):
    next = list()
    for i in range(len(template)):
        next.append(template[i])
        if i < len(template) - 1:
            new = rules[(template[i], template[i + 1])]
            if new != None:
                next.append(new)
    template = next

counts = dict()
for element in template:
    counts[element] = counts.get(element, 0) + 1
print(counts)

result = max(counts.values()) - min(counts.values())
print(f"The difference between the most and least common elements is {result}")
