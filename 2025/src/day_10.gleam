import gleam/bool
import gleam/dict.{type Dict}
import gleam/float
import gleam/int
import gleam/list
import gleam/result
import gleam/string
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
    let cache =
      machine.schematics
      |> list.map(parse_binary_array(_, len))
      |> cache_combinations

    found_min_combination(machine.joltage, cache)
  })
  |> list.fold(0, int.add)
}

type Machine {
  Machine(lights: String, schematics: List(List(Int)), joltage: List(Int))
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

fn parse_binary_array(positions: List(Int), len: Int) {
  list.range(0, len)
  |> list.map(fn(x) {
    case list.contains(positions, x) {
      True -> 1
      False -> 0
    }
  })
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

fn reduce_binaries(
  list: List(List(Int)),
  function: fn(Int, Int) -> Int,
) -> List(Int) {
  list.reduce(list, fn(acc, c) {
    list.zip(acc, c)
    |> list.map(fn(x) { function(x.0, x.1) })
  })
  |> result.unwrap([])
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

pub fn cache_combinations(
  schematic: List(List(Int)),
) -> Dict(List(Int), List(#(List(Int), Int))) {
  list.range(0, list.length(schematic))
  |> list.flat_map(fn(len) { list.combinations(schematic, len) })
  |> list.fold(dict.new(), fn(acc, c) {
    let simple = reduce_binaries(c, int.bitwise_exclusive_or)
    let state = reduce_binaries(c, int.add)
    let len = list.length(c)

    let new_list = case dict.get(acc, simple) {
      Ok(list) -> {
        list.prepend(list, #(state, len))
      }
      Error(_) -> {
        [#(state, len)]
      }
    }

    dict.insert(acc, simple, new_list)
  })
}

pub fn found_min_combination(
  joltage: List(Int),
  cache: Dict(List(Int), List(#(List(Int), Int))),
) -> Int {
  use <- bool.guard(list.all(joltage, fn(i) { i == 0 }), 0)

  let simple = list.map(joltage, math.mod(_, 2))

  dict.get(cache, simple)
  |> result.unwrap([])
  |> list.filter(fn(entry) {
    list.zip(joltage, entry.0) |> list.all(fn(x) { x.0 >= x.1 })
  })
  |> list.map(fn(entry) {
    #(reduce_binaries([joltage, entry.0], fn(a, b) { { a - b } / 2 }), entry.1)
  })
  |> list.fold(10_000, fn(current, tuple) {
    let #(new_joltage, cost) = tuple
    int.min(current, cost + 2 * found_min_combination(new_joltage, cache))
  })
}
