import gleam/bool
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/file
import util/math
import util/parse
import util/range.{type Range}

const file: String = "input/day_02.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  run(file, fn(ranges) {
    ranges
    |> list.map(to_halves)
    |> list.flat_map(find_invalids)
  })
}

pub fn part_2(file: String) -> Int {
  run(file, fn(ranges) {
    ranges
    |> list.flat_map(find_invalids_p2)
  })
}

pub fn run(file: String, fun: fn(List(List(String))) -> List(Int)) -> Int {
  file.read(file)
  |> string.split(",")
  |> list.map(string.split(_, "-"))
  |> fun
  |> list.fold(0, int.add)
}

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

fn find_invalids(rang: List(Division)) -> List(Int) {
  let rang = range.from_list(rang)
  let is_contained = range.inc_contains(
    range.map(rang, fn(r) { r.original }),
    _,
  )

  range.map(rang, fn(r) { r.left })
  |> range.produce
  |> list.map(int.to_string)
  |> list.map(extend_slice(_, 2))
  |> list.filter(is_contained)
}

fn find_invalids_p2(values: List(String)) -> List(Int) {
  let range = range.from_list(values) |> range.map(parse.int)

  values
  |> list.map(string.length)
  |> list.flat_map(calculate_divisions)
  |> list.unique()
  |> list.flat_map(generate_candidates(range, _))
  |> list.unique()
  |> list.filter(range.inc_contains(range, _))
}

/// Takes a number and generates a new one with the base
/// replicated the specified number of times
fn extend_slice(base: String, times: Int) -> Int {
  base
  |> list.repeat(times:)
  |> string.join("")
  |> parse.int()
}

// An optimization could be to cache this calcs and always start
// with the set of the higher divisor and the find the remainings

/// Finds the integer divisions of the given number
pub fn calculate_divisions(of number: Int) -> List(#(Int, Int)) {
  do_calculate_division(number, number / 2, [])
}

fn do_calculate_division(
  number: Int,
  with candidate: Int,
  in collected: List(#(Int, Int)),
) -> List(#(Int, Int)) {
  use <- bool.guard(candidate < 1, collected)
  let in = case number |> int.modulo(candidate) {
    Ok(0) -> [#(candidate, number / candidate), ..collected]
    _ -> collected
  }
  do_calculate_division(number, with: candidate - 1, in:)
}

/// For a range xx-yy and a division like (a,b) it generates slices
/// of length between a and a+remainder so limited ranges can be
/// used to generate candidates between the two ranges.
///
/// # Example
/// For a range 66, 123 with division (1,2)
/// It will generate the slices 6 and 12
/// Which will generate intermediate slices 6, 7, 8, 9, 10, 11, 12
/// And this will create the candidates 66, 77, 88, 99, 1010, 1111, 1212
fn generate_candidates(range: Range(Int), division: #(Int, Int)) -> List(Int) {
  let extender = extend_slice(_, division.1)

  range
  |> range.map(int.to_string)
  |> range.map(fn(r) { slicer(r, division) })
  |> range.map(parse.int)
  |> range.produce
  |> list.map(int.to_string)
  |> list.map(extender)
}

fn slicer(value: String, division: #(Int, Int)) -> String {
  string.slice(
    value,
    at_index: 0,
    length: division.0 + string.length(value) % division.1,
  )
}
