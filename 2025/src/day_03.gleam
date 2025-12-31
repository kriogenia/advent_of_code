import gleam/int
import gleam/list
import gleam/string
import util/file
import util/parse

const file: String = "input/day03.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  file.read_lines(file)
  |> list.map(string.to_graphemes)
  |> list.map(fn(chars) { chars |> list.map(parse.int) })
  |> list.map(find_first_digit)
  |> list.map(fn(x) {
    let #(list, first) = x
    first.1 * 10 + find_second_digit(list, first.0)
  })
  |> list.fold(0, int.add)
}

// pub fn part_2(file: String) -> Int {
//   todo
// }

fn find_first_digit(array: List(Int)) -> #(List(Int), #(Int, Int)) {
  let assert [_, ..start] = list.reverse(array) as "No empty arrays"
  #(array, find_max(list.reverse(start)))
}

fn find_second_digit(array: List(Int), start: Int) -> Int {
  let #(_, tail) = array |> list.split(start + 1)
  find_max(tail).1
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
