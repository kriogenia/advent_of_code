import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/coordinates.{type Coordinate2}
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

fn find_removable(rolls: List(Coordinate2)) -> List(Coordinate2) {
  let roll_set = set.from_list(rolls)
  rolls
  |> list.filter(fn(roll) {
    {
      roll
      |> coordinates.neighbours
      |> list.count(set.contains(roll_set, _))
    }
    < 4
  })
}

fn remove_rolls(rolls: Set(Coordinate2)) -> Int {
  let to_remove = rolls |> set.to_list |> find_removable
  case list.length(to_remove) {
    0 -> 0
    removed ->
      removed + remove_rolls(set.difference(rolls, to_remove |> set.from_list))
  }
}

fn parse(file: String) -> List(Coordinate2) {
  {
    use line, i <- list.index_map(file.read_lines(file))
    use char, j <- list.index_map(string.to_graphemes(line))
    case char {
      "@" -> Ok(coordinates.Coordinate2(i, j))
      _ -> Error(Nil)
    }
  }
  |> list.flatten
  |> result.values
}
