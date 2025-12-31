import gleam/bool
import gleam/int
import gleam/list
import gleam/string
import util/file
import util/parse

const file: String = "input/day_03.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  run(file, 2)
}

pub fn part_2(file: String) -> Int {
  run(file, 12)
}

pub fn run(file: String, objective: Int) -> Int {
  file.read_lines(file)
  |> list.map(string.to_graphemes)
  |> list.map(fn(chars) { chars |> list.map(parse.int) })
  |> list.map(fn(array) { find_digits(array, objective, 0) })
  |> list.fold(0, int.add)
}

/// Recursively finds the max of each subarray until all have
/// been found
fn find_digits(array: List(Int), objective: Int, acc: Int) -> Int {
  let len = array |> list.length()
  // Fast exit where all remainders must be used
  use <- bool.lazy_guard(len == objective, fn() {
    array
    |> list.prepend(acc)
    |> list.fold(0, fn(acc, i) { acc * 10 + i })
  })

  use <- bool.guard(objective == 0, acc)
  let #(start, tail) = array |> list.split(len - objective + 1)

  let max = find_max(start)
  let #(_discarded, remainder) = start |> list.split(max.0 + 1)

  find_digits(list.append(remainder, tail), objective - 1, acc * 10 + max.1)
}

/// Finds the max value of the array and returns with the index
pub fn find_max(array: List(Int)) -> #(Int, Int) {
  list.range(9, 0)
  |> list.fold_until(#(0, -1), fn(_, target) { index_of(0, array, target) })
}

fn index_of(
  index: Int,
  list: List(Int),
  target: Int,
) -> list.ContinueOrStop(#(Int, Int)) {
  case list {
    [] -> list.Continue(#(0, target - 1))
    [head, ..tail] ->
      case head == target {
        True -> list.Stop(#(index, target))
        False -> index_of(index + 1, tail, target)
      }
  }
}
