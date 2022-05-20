import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

STEPS = 40

def store(pair, map, count = 1):
	map[pair] = map.get(pair, 0) + count

# store template array
pairs = dict()
template_code = f.readline().strip()
for i in range(len(template_code) - 1):
	pair = template_code[i] + template_code[i + 1]
	store(pair, pairs)

f.readline()	# ignore empty line

# store steps
rules = dict()
for line in f:
	[left, *_, right] = line.strip().split(" ")
	rules[left] = right
f.close()

# generate pairs
for _ in range(STEPS):
	next = dict()
	for (pair, count) in pairs.items():
		new = rules[pair]
		if new != None:
			store(pair[0] + new, next, count)
			store(new + pair[1], next, count)
		else:
			store(pair, new, count)
	pairs = next

# count the letters
single_letters = dict()
for key, count in pairs.items():
	store(key[0], single_letters, count)
store(template_code[-1], single_letters)

result = max(single_letters.values()) - min(single_letters.values())
print(f"The difference between the most and least common elements is {result}")