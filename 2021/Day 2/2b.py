class Position:		# Class to hold the coordinates and allow lambda usage
	horizontal = 0
	depth = 0
	aim = 0

	def forward(self, d: int):
		self.horizontal += d
		self.depth += self.aim * d

	def up(self, d: int):
		self.aim -= d

	def down(self, d: int):
		self.aim += d

#####################################

import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

position = Position()
commands = { 			# function mapping
	"forward": lambda pos, n : pos.forward(n), 
	"up": lambda pos, n : pos.up(n), 
	"down": lambda pos, n : pos.down(n)
}

for line in f:
	[ direction, movement ] = line.split(" ")
	commands[direction](position, int(movement))	# get movement function and apply distance

print(f'The definite position will be {position.horizontal}, {position.depth}')
print(f'The multiplication result is {position.horizontal * position.depth}')

f.close()