import gleam/int
import gleam/list
import gleam/result
import util/file

pub fn main() {
  echo "Part 1: " <> { part_1("input/day01.txt") |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let from = State(50, 0)
  let result =
    file.read_lines(file)
    |> list.filter_map(parse)
    |> list.fold(from:, with: rotate)
  result.zeroes
}

type Direction {
  Left
  Right
}

fn parse(str: String) -> Result(#(Direction, Int), Nil) {
  let to_tuple = fn(dir: Direction, i: int) { #(dir, i) }
  case str {
    // Two lines is fair enough to allow some duplication
    "L" <> rotation -> rotation |> int.parse() |> result.map(to_tuple(Left, _))
    "R" <> rotation -> rotation |> int.parse() |> result.map(to_tuple(Right, _))
    _ -> Error(Nil)
  }
}

type State {
  State(position: Int, zeroes: Int)
}

fn rotate(from state: State, move movement: #(Direction, Int)) -> State {
  case movement {
    #(Left, rotation) -> state.position - rotation
    #(Right, rotation) -> state.position + rotation
  }
  |> guard()
  |> count(state.zeroes)
}

fn guard(i: Int) -> Int {
  case i % 100 {
    0 -> 0
    mod if i < 0 -> mod + 100
    mod -> mod
  }
}

fn count(position: Int, zeroes: Int) {
  case position {
    0 -> State(position:, zeroes: zeroes + 1)
    _ -> State(position:, zeroes:)
  }
}
