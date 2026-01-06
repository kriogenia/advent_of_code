import gleam/int
import gleam/list
import gleam/result
import util/coordinates.{type Coordinate2}
import util/file
import util/parse

const file: String = "input/day_09.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  file.read_lines(file)
  |> list.map(coordinates.parse2)
  |> list.combination_pairs
  |> list.map(area)
  |> list.reduce(int.max)
  |> result.unwrap(0)
}

pub fn part_2(file: String) -> Int {
  todo
}

// Calculates the area of the rectangle, adding one to each dimension as it is the minimum
pub fn area(pair: #(Coordinate2, Coordinate2)) -> Int {
  let #(left, right) = pair
  int.absolute_value(left.x - right.x + 1)
  * int.absolute_value(left.y - right.y + 1)
}
