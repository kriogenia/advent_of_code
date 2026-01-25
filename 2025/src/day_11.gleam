import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/option.{None, Some}
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/file

const file: String = "input/day_11.txt"

const out: String = "out"

const svr: String = "svr"

const you: String = "you"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let outputs = file |> file.read_lines |> list.map(parse) |> dict.from_list
  let initial_state =
    State(to_explore: [out], counter: dict.from_list([#(out, 1)]))

  calculate_paths(outputs, initial_state)
}

pub fn part_2(file: String) -> Int {
  let outputs = file |> file.read_lines |> list.map(parse) |> dict.from_list

  let start = #(svr, dict.from_list([#(0, 1)]))
  find_visiting_paths(outputs, [start] |> dict.from_list)
}

fn parse(line: String) -> #(String, Set(String)) {
  let assert Ok(#(key, paths)) = string.split_once(line, ": ")
  #(key, string.split(paths, " ") |> set.from_list)
}

type State {
  State(to_explore: List(String), counter: Dict(String, Int))
}

fn update_counter(current: Dict(String, Int), key: String, to_add: Int) {
  dict.upsert(current, key, fn(x) {
    case x {
      Some(current) -> current + to_add
      None -> to_add
    }
  })
}

// From a given maps of outputs it calculates the number of patsh leading to "out".
// This is done finding any device pointing to a series of exists and removing them from it
// while also adding to the count of each node the number of exists of the new path found.
//
// For example, given the exits [e, f, g] with c -> [d, e, f], d -> [g]
// Then c updates to c ^ exits = [e,f] with one path each, so c -> [d] and c: 2.
// While d updates to d ^ exits = [g] with one path, so d -> [] and d: 1
// Next call will send exits [d] as it is now empty... this continues until you: []
fn calculate_paths(unexplored: Dict(String, Set(String)), state: State) -> Int {
  let to_explore = state.to_explore |> set.from_list

  let calc_to_add = fn(matches) {
    state.counter
    |> dict.filter(fn(k, _) { list.contains(matches, k) })
    |> dict.values
    |> list.fold(0, int.add)
  }

  let #(new_counter, new_unexplored) =
    unexplored
    |> dict.to_list
    |> list.map_fold(state.counter, fn(counter, pair) {
      let #(key, paths) = pair

      case set.intersection(paths, to_explore) |> set.to_list {
        [] -> #(counter, pair)
        matches -> {
          let new_counter =
            calc_to_add(matches) |> update_counter(counter, key, _)

          #(new_counter, #(key, set.difference(paths, to_explore)))
        }
      }
    })

  let #(to_explore, new_unexplored) = extract_to_explore(new_unexplored)

  case dict.get(new_unexplored, you) |> result.map(set.to_list) {
    Error(_) -> dict.get(new_counter, you) |> result.unwrap(-1)
    _ ->
      calculate_paths(
        new_unexplored,
        State(to_explore: to_explore, counter: new_counter),
      )
  }
}

fn extract_to_explore(unexplored: List(#(String, Set(String)))) {
  let #(to_explore, new_unexplored) =
    list.partition(unexplored, fn(pair) { set.is_empty(pair.1) })

  let to_explore = to_explore |> list.map(fn(x) { x.0 })
  let new_unexplored = dict.from_list(new_unexplored)

  #(to_explore, new_unexplored)
}

fn find_visiting_paths(
  paths: Dict(String, Set(String)),
  open_paths: Dict(String, Dict(Int, Int)),
) -> Int {
  let assert Ok(next_paths) =
    open_paths
    |> dict.to_list
    |> list.map(expand_path(_, paths))
    |> list.reduce(fn(a, b) { dict.combine(a, b, combine_paths) })

  let len = next_paths |> dict.to_list |> list.length
  case len, dict.get(next_paths, out) {
    1, Ok(counts) -> dict.get(counts, 3) |> result.unwrap(0)
    _, _ -> find_visiting_paths(paths, next_paths)
  }
}

fn expand_path(
  from: #(String, Dict(Int, Int)),
  paths: Dict(String, Set(String)),
) -> Dict(String, Dict(Int, Int)) {
  let #(device, counts) = from

  case dict.get(paths, device) {
    Ok(x) -> {
      x
      |> set.to_list
      |> list.map(fn(device) {
        let next =
          counts
          |> dict.to_list
          |> list.map(fn(x) {
            #(int.bitwise_or(x.0, check_passed(device)), x.1)
          })
          |> dict.from_list
        #(device, next)
      })
    }
    Error(_) -> [from]
  }
  |> dict.from_list
}

fn combine_paths(left: Dict(Int, Int), right: Dict(Int, Int)) {
  // Removing 0 mask paths when there's non-zero paths should be an optimization
  // but as we are dealing with an immutable lang and we need to copy the whole dict
  // it is actually fairly slower. Pretty sure that mutable dict would be faster
  //
  // let new_dict = dict.combine(left, right, int.add)
  // case new_dict |> dict.to_list |> list.any(fn(x) { x.0 > 0 }) {
  //   True -> dict.drop(new_dict, [0])
  //   False -> new_dict
  // }

  dict.combine(left, right, int.add)
}

// Maps required devices to a mask
fn check_passed(key: String) -> Int {
  case key {
    "dac" -> 1
    "fft" -> 2
    _ -> 0
  }
}
