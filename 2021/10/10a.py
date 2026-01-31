import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

open_chars = ["(", "[", "{", "<"]
close_chars = [")", "]", "}", ">"]

value = {")": 3, "]": 57, "}": 1197, ">": 25137}


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
                return value[char]
    return 0


score = 0

for line in f:
    score += calc(line)

print(f"The total syntax error is {score}")

f.close()
