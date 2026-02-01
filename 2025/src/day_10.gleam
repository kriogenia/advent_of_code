import gleam/bool
import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/collections
import util/file
import util/math
import util/parse

const file: String = "input/day_10.txt"

const swap_to_depth: Int = 5

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  file.read_lines(file)
  |> list.map(parse)
  |> list.map(fn(machine) {
    let Machine(lights, schematics, _) = machine

    let lights = light_to_mask(lights)
    let schematics = schematics |> list.map(parse_binary)
    let candidates = [Candidate(current: [], remaining: schematics)]

    evaluate(lights, candidates)
  })
  |> list.fold(0, int.add)
}

pub fn part_2(file: String) -> Int {
  file.read_lines(file)
  |> list.map(parse)
  |> list.map(fn(machine) {
    let len = { machine.lights |> string.length() } - 3
    let presses = generate_presses(machine.schematics, len)
    #(machine.joltage, presses)
  })
  |> list.map(find_mininum)
  |> int.sum
}

type Machine {
  Machine(lights: String, schematics: List(List(Int)), joltage: List(Int))
}

type Presses {
  Presses(mask: Int, count: Int, state: Dict(Int, Int))
}

fn drop_guards(str: String) -> String {
  str |> string.drop_start(1) |> string.drop_end(1)
}

fn parse(line: String) -> Machine {
  let assert Ok(#(configuration, rest)) = string.split_once(line, on: " ")
  let assert [joltage, ..schematics] = rest |> string.split(" ") |> list.reverse

  let schematics =
    schematics
    |> list.reverse
    |> list.map(parse_schematic)

  let joltage =
    joltage
    |> drop_guards
    |> string.split(",")
    |> list.map(parse.int)

  Machine(lights: configuration, schematics:, joltage:)
}

pub fn light_to_mask(configuration: String) -> Int {
  configuration
  |> drop_guards
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

fn parse_schematic(schematic: String) -> List(Int) {
  schematic
  |> drop_guards
  |> string.split(",")
  |> list.map(parse.int)
}

pub fn parse_binary(schematics: List(Int)) -> Int {
  schematics
  |> list.map(int.to_float)
  |> list.map(int.power(2, _))
  |> list.map(result.unwrap(_, 0.0))
  |> list.reduce(float.add)
  |> result.map(float.truncate)
  |> result.unwrap(0)
}

fn parse_reverse_binary(schematics: List(Int), width: Int) -> Int {
  schematics
  |> list.map(fn(s) { width - s })
  |> parse_binary
}

fn generate_presses(schematics: List(List(Int)), len: Int) -> List(Presses) {
  list.range(0, len + 1)
  |> list.flat_map(list.combinations(schematics, _))
  |> list.map(fn(c) {
    let mask = c |> list.map(parse_reverse_binary(_, len)) |> xor
    let counts = c |> list.flatten() |> collections.count()

    Presses(mask, list.length(c), counts)
  })
}

pub fn binary_to_decimal(bits: List(Int)) -> Int {
  case bits {
    [] -> 0
    [single] -> single
    [first, ..rest] -> first + { 2 * binary_to_decimal(rest) }
  }
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

fn xor(list: List(Int)) -> Int {
  list.fold(list, 0, int.bitwise_exclusive_or)
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

  case xor(candidate.current) == target {
    True -> len
    False -> evaluate(target, rest |> list.append(expand(candidate)))
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

  case xor(candidate.current) == target {
    True -> depth_search(target, rest, int.min(best, len))
    False -> depth_search(target, expand(candidate) |> list.append(rest), best)
  }
}

fn find_mininum(current: #(List(Int), List(Presses))) -> Int {
  let #(joltage, presses) = current

  use <- bool.guard(joltage |> list.any(fn(x) { x < 0 }), 1_000_001)
  use <- bool.guard(int.sum(joltage) == 0, 0)

  let odd =
    joltage
    |> list.map(math.mod(_, 2))
    |> list.reverse
    |> binary_to_decimal

  let sets_to_even = fn(press: Presses) {
    { press.mask |> int.bitwise_exclusive_or(odd) } == 0
  }

  presses
  |> list.filter(sets_to_even)
  |> list.fold(1_000_000, fn(prev, press) {
    let next = substract(joltage, press.state)
    int.min(prev, press.count + { 2 * find_mininum(#(next, presses)) })
  })
}

fn substract(joltage: List(Int), state: Dict(Int, Int)) -> List(Int) {
  joltage
  |> list.index_map(fn(x, i) { x - { dict.get(state, i) |> result.unwrap(0) } })
  |> list.map(math.div(_, 2))
}
