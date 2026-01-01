import gleam/int
import gleam/list
import gleam/string
import util/file
import util/parse
import util/range.{type Range}

const file: String = "input/day_05.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let #(ranges, ingredients) =
    file.read_lines(file)
    |> list.split_while(fn(l) { !string.is_empty(l) })

  let ranges = generate_ranges(ranges)

  ingredients
  |> list.drop(1)
  |> list.map(parse.int)
  |> list.count(is_fresh(_, ranges))
}

pub fn part_2(file: String) -> Int {
  file.read_lines(file)
  |> list.take_while(fn(l) { !string.is_empty(l) })
  |> generate_ranges
  |> list.map(fn(r) { range.length(r) + 1 })
  |> list.fold(0, int.add)
}

fn generate_ranges(ranges: List(String)) -> List(Range(Int)) {
  ranges
  |> list.map(range.parse)
  |> list.map(range.map(_, parse.int))
  |> list.sort(fn(a, b) { int.compare(a.start, b.start) })
  |> list.fold(#([], range.Range(0, 0)), merge_ranges)
  |> fn(res) { res.0 |> list.drop(1) |> list.append([res.1]) }
}

fn merge_ranges(acc: #(List(Range(Int)), Range(Int)), r: Range(Int)) {
  let #(processed, last) = acc
  case range.merge(last, r) {
    Ok(merged) -> #(processed, merged)
    Error(Nil) -> #(list.append(processed, [last]), r)
  }
}

fn is_fresh(value: Int, ranges: List(Range(Int))) -> Bool {
  case ranges |> list.find(fn(r) { value <= r.end }) {
    Ok(range) -> value >= range.start
    Error(Nil) -> False
  }
}
