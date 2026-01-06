import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/collections
import util/file

const file: String = "input/day_07.txt"

const start_char: String = "S"

const splitter_char: String = "^"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let #(start, rest) = parse(file)

  rest
  |> list.scan(set.from_list([start]), split)
  |> list.window(2)
  |> list.fold(0, fn(acc, window) {
    let assert [first, second] = window
    acc + { set.difference(first, second) |> set.to_list |> list.length }
  })
}

pub fn part_2(file: String) -> Int {
  let #(start, rest) = parse(file)
  let timelines = dict.from_list([#(start, 1)])

  rest
  |> list.fold(timelines, split_timelines)
  |> dict.values
  |> list.reduce(int.add)
  |> result.unwrap(0)
}

fn parse(file: String) -> #(Int, List(Set(Int))) {
  let assert [start, ..rest] = file.read_lines(file)

  let assert Ok(start) =
    start
    |> string.to_graphemes()
    |> collections.index_of(start_char)

  #(start, rest |> list.map(get_splitters))
}

pub fn get_splitters(line: String) -> Set(Int) {
  let #(_, positions) =
    line
    |> string.split(splitter_char)
    |> list.map(string.length)
    |> list.map_fold(-1, fn(acc, current) {
      #(acc + current + 1, acc + current + 1)
    })

  positions |> collections.remove_last |> set.from_list
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

// The simplest method to do this is generate all the timelines and estimate
// their paths, but that's an exponential complexity that can be tricked down
// as two timelines in the same spot at the same time will have the same outcome
// so we only care about the set of positions... and how many timelines are in each
// of those, so good old dicts to save the day
fn split_timelines(
  timelines: Dict(Int, Int),
  splitters: Set(Int),
) -> Dict(Int, Int) {
  dict.to_list(timelines)
  |> list.flat_map(fn(timeline) {
    let #(position, occurrences) = timeline
    timeline_split(position, splitters)
    |> list.map(fn(pos) { #(pos, occurrences) })
  })
  |> collections.merge_to_dict(int.add)
}

fn timeline_split(position: Int, splitters: Set(Int)) -> List(Int) {
  case splitters |> set.contains(position) {
    True -> [position - 1, position + 1]
    False -> [position]
  }
}
