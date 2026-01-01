import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/file

const file: String = "input/day_04.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  parse(file)
  |> find_removable
  |> list.length
}

pub fn part_2(file: String) -> Int {
  parse(file)
  |> set.from_list
  |> remove_rolls
}

fn find_removable(rolls: List(Coordinate)) -> List(Coordinate) {
  let roll_set = set.from_list(rolls)
  rolls
  |> list.filter(fn(roll) {
    {
      roll
      |> neighbours
      |> list.count(set.contains(roll_set, _))
    }
    < 4
  })
}

fn remove_rolls(rolls: Set(Coordinate)) -> Int {
  let to_remove = rolls |> set.to_list |> find_removable
  case list.length(to_remove) {
    0 -> 0
    removed ->
      removed + remove_rolls(set.difference(rolls, to_remove |> set.from_list))
  }
}

type Coordinate {
  Coordinate(x: Int, y: Int)
}

fn parse(file: String) -> List(Coordinate) {
  {
    use line, i <- list.index_map(file.read_lines(file))
    use char, j <- list.index_map(string.to_graphemes(line))
    case char {
      "@" -> Ok(Coordinate(i, j))
      _ -> Error(Nil)
    }
  }
  |> list.flatten
  |> result.values
}

fn neighbours(roll: Coordinate) -> List(Coordinate) {
  [
    Coordinate(roll.x - 1, roll.y - 1),
    Coordinate(roll.x, roll.y - 1),
    Coordinate(roll.x + 1, roll.y - 1),
    Coordinate(roll.x - 1, roll.y),
    Coordinate(roll.x + 1, roll.y),
    Coordinate(roll.x - 1, roll.y + 1),
    Coordinate(roll.x, roll.y + 1),
    Coordinate(roll.x + 1, roll.y + 1),
  ]
}
