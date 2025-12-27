import gleam/int
import gleam/list
import gleam/result
import util/file
import util/parse

const file: String = "input/day01.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  run(file) |> list.count(fn(s) { s.position == 0 })
}

pub fn part_2(file: String) -> Int {
  run(file) |> list.fold(0, fn(prev, s) { prev + s.laps })
}

const starting_position: Int = 50

const n_positions: Int = 100

/// Performs the rotation outputing the result of each rotation
/// for both parts.
fn run(file: String) -> List(State) {
  let from = State(starting_position, 0)
  file.read_lines(file)
  |> list.map(parse)
  |> list.scan(from:, with: rotate)
}

fn parse(str: String) -> Int {
  case str {
    "L" <> rotation -> -parse.int(rotation)
    "R" <> rotation -> parse.int(rotation)
    _ -> panic as "Only expected lines starting with L/R"
  }
}

type State {
  State(position: Int, laps: Int)
}

fn rotate(from state: State, move movement: Int) -> State {
  let addition = state.position + movement
  let position = case addition % n_positions {
    pos if pos < 0 -> n_positions + pos
    pos -> pos
  }

  let laps = case
    addition,
    state.position,
    position,
    int.floor_divide(addition, n_positions) |> result.map(int.absolute_value)
  {
    0, _, _, _ -> 1
    _, 0, _, Ok(laps) if addition < 0 -> int.max(0, laps - 1)
    _, _, 0, Ok(laps) if addition < 0 -> laps + 1
    _, _, _, Ok(laps) -> laps
    _, _, _, _ -> panic
  }

  State(position:, laps:)
}
