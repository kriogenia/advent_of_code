import gleam/bool
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/collections
import util/file
import util/parse

const file: String = "input/day_10.txt"

const swap_to_depth: Int = 5

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  file.read_lines(file)
  |> list.map(parse_line)
  |> list.map(fn(machine) {
    let #(target, candidates) = machine
    evaluate(target, candidates)
  })
  |> list.fold(0, int.add)
}

// pub fn part_2(_file: String) -> Int {
//   todo
// }

fn parse_line(line: String) -> #(Int, List(Candidate)) {
  let assert Ok(#(configuration, schematics)) = string.split_once(line, on: " ")
  let schematics =
    schematics
    |> string.split(" ")
    |> collections.remove_last
    |> list.map(schematic_to_mask)

  #(light_to_mask(configuration), [
    Candidate(current: [], remaining: schematics),
  ])
}

pub fn light_to_mask(configuration: String) -> Int {
  configuration
  |> string.drop_start(1)
  |> string.drop_end(1)
  |> parse_bit(1)
}

fn parse_bit(configuration: String, value: Int) -> Int {
  case string.pop_grapheme(configuration) {
    Ok(#(".", rest)) -> parse_bit(rest, value * 2)
    Ok(#("#", rest)) -> value + parse_bit(rest, value * 2)
    Ok(_) -> panic as "Indicator lights can only be . or #"
    Error(_) -> 0
  }
}

pub fn schematic_to_mask(schematic: String) -> Int {
  schematic
  |> string.drop_start(1)
  |> string.drop_end(1)
  |> string.split(",")
  |> list.map(parse.int)
  |> list.map(int.to_float)
  |> list.map(int.power(2, _))
  |> list.map(result.unwrap(_, 0.0))
  |> list.reduce(float.add)
  |> result.map(float.truncate)
  |> result.unwrap(0)
}

type Candidate {
  Candidate(current: List(Int), remaining: List(Int))
}

fn expand(candidate: Candidate) -> List(Candidate) {
  candidate.remaining
  |> list.map(fn(x) {
    Candidate(
      current: list.prepend(candidate.current, x),
      remaining: candidate.remaining |> list.filter(fn(y) { y != x }),
    )
  })
}

// Starts with breadth first search for valid solutions.
// Returning the first it finds.
// If it goes over `swap_to_depth` length, then calls the depth search
fn evaluate(target: Int, candidates: List(Candidate)) -> Int {
  let assert [candidate, ..rest] = candidates
    as "should never run out of candidates"
  let len = list.length(candidate.current)

  let skip = fn() { depth_search(target, candidates, start: 1000) }
  use <- bool.lazy_guard(when: len >= swap_to_depth, return: skip)

  case
    candidate.current
    |> list.reduce(int.bitwise_exclusive_or)
    |> result.map(fn(x) { x == target })
  {
    Ok(True) -> len
    _ -> evaluate(target, rest |> list.append(expand(candidate)))
  }
}

// Depth first search for valid solutions. It cuts any branch over the current best
fn depth_search(
  target: Int,
  candidates: List(Candidate),
  start best: Int,
) -> Int {
  use <- bool.guard(list.is_empty(candidates), best)

  let assert [candidate, ..rest] = candidates
  let len = list.length(candidate.current)

  let skip = fn() { depth_search(target, rest, best) }
  use <- bool.lazy_guard(when: len >= best, return: skip)

  case
    candidate.current
    |> list.reduce(int.bitwise_exclusive_or)
    |> result.map(fn(x) { x == target })
  {
    Ok(True) -> depth_search(target, rest, int.min(best, len))
    _ -> depth_search(target, expand(candidate) |> list.append(rest), best)
  }
}
