from itertools import count
from operator import contains
import pathlib

path = pathlib.Path(__file__).parent.resolve().joinpath("input.txt")
f = open(path, "r")

class CaveSystem:
	caves = {}

	def new_path(self, s: str, e: str):
		start = self.add_or_get(s)
		end = self.add_or_get(e)
		start.add_path(end)
		end.add_path(start)

	def add_or_get(self, key: str):
		if key not in self.caves:
			self.caves[key] = Cave(key)
		return self.caves[key]

	def traverse(self):
		self.caves["start"].travel([], 0)

	def small_caves(self):
		return len(list(filter(lambda c: c.small, self.caves.values())))

class Cave:
	key = ""
	small = False
	paths = []

	def __init__(self, key: str):
		self.key = key
		self.small = key.islower()
		self.paths = []

	def add_path(self, cave):
		self.paths.append(cave)

	def travel(self, prev, small_traveled):
		if self.small and contains(prev, self.key):						# revisited small cave
			return
		prev.append(self.key)											# add to route

		if self.small:
			small_traveled += 1

		if self.key == "end" and small > 0:								# check end
			completed_routes.append(prev)								# store valid routes

		successful_routes = []
		for destiny in self.paths:
			#print("pre", self.key, destiny.key, prev)
			destiny.travel(prev.copy(), small_traveled)		# expand travel
			#print("\tpost", self.key, destiny.key, routes)
		return len(successful_routes) > 0, successful_routes 


caves = CaveSystem()
completed_routes = []

# Parse cave system
for line in f:
	[s, e] = line.strip().split("-")
	caves.new_path(s, e)

small = caves.small_caves()
caves.traverse()
print(f"There are {len(completed_routes)} possible routes")
