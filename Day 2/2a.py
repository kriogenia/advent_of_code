class Position:		# Class to hold the coordinates and allow lambda usage
	x = 0
	y = 0

	def forward(self, d: int):
		self.x += d

	def up(self, d: int):
		self.y -= d

	def down(self, d: int):
		self.y += d

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

print(f'The definite position will be {position.x}, {position.y}')
print(f'The multiplication result is {position.x * position.y}')