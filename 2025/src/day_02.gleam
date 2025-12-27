import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/file
import util/math
import util/parse

const file: String = "input/day02.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  file.read(file)
  |> string.split(",")
  |> list.map(fn(r) { string.split(r, "-") })
  |> list.map(to_halves)
  |> list.flat_map(find_invalids)
  |> list.fold(0, int.add)
}

// pub fn part_2(file: String) -> Int {
//   todo
// }

type Division {
  Division(left: Int, original: Int)
}

fn to_halves(numbers: List(String)) -> List(Division) {
  // The longest of the shortest halves should be the right half 
  let length = calculate_length(numbers)
  numbers
  |> list.map(fn(from) {
    let length = string.length(from) - length
    Division(
      left: string.slice(from:, at_index: 0, length:)
        |> int.parse()
        |> result.unwrap(0),
      original: from |> parse.int(),
    )
  })
}

fn calculate_length(numbers: List(String)) -> Int {
  let assert Ok(length) =
    numbers
    |> list.map(string.length)
    |> list.map(fn(n) { math.div(n, 2) })
    |> list.reduce(int.max)
  length
}

fn find_invalids(range: List(Division)) -> List(Int) {
  let assert [start, end] = range as "Ranges have two values"

  list.range(start.left, end.left)
  |> list.map(int.to_string)
  |> list.map(fn(n) { n <> n })
  |> list.map(parse.int)
  |> list.filter(fn(n) { n >= start.original && n <= end.original })
}
