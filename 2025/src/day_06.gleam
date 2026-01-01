import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/file
import util/parse

const file: String = "input/day_06.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let assert [operations, ..values] = file.read_lines(file) |> list.reverse
  let operations = split(operations, parse_sign)
  let values = values |> list.map(split(_, parse.int)) |> list.transpose

  list.zip(operations, values)
  |> list.map(fn(input) { input.1 |> list.reduce(input.0) })
  |> result.values
  |> list.reduce(int.add)
  |> result.unwrap(0)
}

pub fn part_2(file: String) -> Int {
  todo
}

fn split(line: String, parser: fn(String) -> a) -> List(a) {
  line
  |> string.split(" ")
  |> list.filter(fn(s) { !string.is_empty(s) })
  |> list.map(parser)
}

fn parse_sign(sign: String) -> fn(Int, Int) -> Int {
  case sign {
    "+" -> int.add
    "*" -> int.multiply
    _ -> panic
  }
}
