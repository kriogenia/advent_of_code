import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/file
import util/stream

const file: String = "input/day_07.txt"

const start_char: String = "S"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let assert [start, ..rest] = file.read_lines(file)

  let assert Ok(start) =
    start
    |> string.to_graphemes()
    |> stream.index_of(start_char)
    |> result.map(list.wrap)
    |> result.map(set.from_list)

  rest
  |> list.map(get_splitters)
  |> list.scan(start, split)
  |> list.window(2)
  |> list.fold(0, fn(acc, window) {
    let assert [first, second] = window
    acc + { set.difference(first, second) |> set.to_list |> list.length }
  })
}

pub fn part_2(file: String) -> Int {
  todo
}

pub fn get_splitters(line: String) -> Set(Int) {
  let #(_, positions) =
    line
    |> string.split("^")
    |> list.map(string.length)
    |> list.map_fold(-1, fn(acc, current) {
      #(acc + current + 1, acc + current + 1)
    })

  positions |> stream.remove_last |> set.from_list
}

// Takes a set of beams, compares it to the set of splitters 
// and generates a new set with the beams that didnt touch any
// splitters and the new ones from the splitting
fn split(beams: Set(Int), splitters: Set(Int)) -> Set(Int) {
  let non_splitter = set.difference(beams, splitters)
  set.intersection(beams, splitters)
  |> set.to_list
  |> list.flat_map(fn(n) { [n - 1, n + 1] })
  |> set.from_list
  |> set.union(non_splitter)
}
