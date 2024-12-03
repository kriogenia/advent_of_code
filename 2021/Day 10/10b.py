from calendar import c
import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

open_chars = ["(", "[", "{", "<"]
close_chars = [")", "]", "}", ">"]

value = {
	"(": 1,
	"[": 2,
	"{": 3,
	"<": 4
}

def do_match(opener, closer):
	return open_chars.index(opener) == close_chars.index(closer)

def calc(line):
	openers = []
	for char in line.strip():
		if open_chars.__contains__(char):
			openers.append(char)
		else:
			if do_match(openers[-1], char):
				openers.pop()
			else:
				return 0
							# corrupted, discard
	score = 0
	openers.reverse()
	for char in openers:
		score *= 5
		score += value[char]
	return score

scores = []

for line in f:
	score = calc(line)
	if score > 0:
		scores.append(score)

scores.sort()
middle = scores[int(len(scores)/2)]

print(f"The middle score is {middle}")

f.close()