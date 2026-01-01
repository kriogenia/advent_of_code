import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/file
import util/parse

const file: String = "input/day_06.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let assert [operations, ..values] = file.read_lines(file) |> list.reverse
  let operations = split(operations, parse_sign)

  values
  |> list.map(split(_, parse.int))
  |> list.transpose
  |> calculate(operations, _)
}

pub fn part_2(file: String) -> Int {
  let assert [operations, ..values] = file.read_lines(file) |> list.reverse
  let operations = split(operations, parse_sign)
  let empty_chunks = fn(c) {
    case c {
      [""] -> False
      _ -> True
    }
  }

  values
  |> list.map(string.to_graphemes)
  |> list.transpose
  |> list.map(string.join(_, ""))
  |> list.map(string.trim)
  |> list.map(string.reverse)
  |> list.chunk(string.is_empty)
  |> list.filter(empty_chunks)
  |> list.map(fn(c) { c |> list.map(parse.int) })
  |> calculate(operations, _)
}

fn calculate(
  operations: List(fn(Int, Int) -> Int),
  values: List(List(Int)),
) -> Int {
  list.zip(operations, values)
  |> list.map(fn(input) { input.1 |> list.reduce(input.0) })
  |> result.values
  |> list.reduce(int.add)
  |> result.unwrap(0)
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
