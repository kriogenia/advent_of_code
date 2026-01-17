import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import util/coordinates.{type Coordinate2}
import util/file

const file: String = "input/day_09.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  parse(file)
  |> list.combination_pairs
  |> list.map(area)
  |> list.reduce(int.max)
  |> result.unwrap(0)
}

// FIXME: passes the test but it's not the correct answer
pub fn part_2(file: String) -> Int {
  let pairs = parse(file)
  let is_valid = cuts(_, pairs |> as_sides)

  pairs
  |> list.combination_pairs
  |> list.sort(fn(a, b) { int.compare(area(b), area(a)) })
  |> list.find(is_valid)
  |> result.map(area)
  |> result.unwrap(0)
}

fn parse(file: String) -> List(Coordinate2) {
  file.read_lines(file)
  |> list.map(coordinates.parse2)
}

fn as_sides(pairs: List(Coordinate2)) -> List(#(Coordinate2, Coordinate2)) {
  let assert Ok(first) = pairs |> list.first |> result.map(list.wrap)
  pairs |> list.append(first) |> list.window_by_2
}

// Calculates the area of the rectangle, adding one to each dimension as it is the minimum
fn area(pair: #(Coordinate2, Coordinate2)) -> Int {
  let #(left, right) = pair
  int.absolute_value(left.x - right.x + 1)
  * int.absolute_value(left.y - right.y + 1)
}

// Instead of checking if the rectangle is inside, it should be enough
// to check if it intersects with any of the sides
fn cuts(
  area: #(Coordinate2, Coordinate2),
  sides: List(#(Coordinate2, Coordinate2)),
) -> Bool {
  let area_boundaries = coordinates.boundaries(area)

  sides
  |> list.any(fn(side) {
    let side_boundaries = coordinates.boundaries(side)

    side_boundaries.max_x > area_boundaries.min_x
    && side_boundaries.min_x < area_boundaries.max_x
    && side_boundaries.max_y > area_boundaries.min_y
    && side_boundaries.min_y < area_boundaries.max_y
  })
  |> bool.negate
}
