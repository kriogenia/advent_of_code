import gleam/int
import gleam/list
import gleam/option
import gleam/result
import gleam/set.{type Set}
import util/coordinates.{type Coordinate3}
import util/file

const file: String = "input/day_08.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file, target: 1000) |> int.to_string() }
  echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String, target connections: Int) -> Int {
  parse(file)
  |> sort
  |> list.take(connections)
  |> list.fold(list.new(), group_circuits)
  |> list.map(set.to_list)
  |> list.map(list.length)
  |> list.sort(fn(a, b) { int.compare(b, a) })
  |> list.take(3)
  |> list.reduce(int.multiply)
  |> result.unwrap(0)
}

pub fn part_2(file: String) -> Int {
  let connections = parse(file)
  let folder = fn(acc, line) { group_all(acc, line, list.length(connections)) }

  let assert #(_, option.Some(#(left, right))) =
    connections
    |> sort
    |> list.fold_until(#(list.new(), option.None), folder)

  left.x * right.x
}

fn parse(file: String) -> List(Coordinate3) {
  file.read_lines(file)
  |> list.map(coordinates.parse)
}

fn sort(coordinates: List(Coordinate3)) {
  coordinates
  |> list.combination_pairs
  |> list.map(fn(pair) { #(pair, coordinates.distance(pair)) })
  |> list.sort(fn(a, b) { int.compare(a.1, b.1) })
  |> list.map(fn(line) { line.0 })
}

fn group_circuits(
  circuits: List(Set(Coordinate3)),
  line: #(Coordinate3, Coordinate3),
) -> List(Set(Coordinate3)) {
  let left =
    circuits |> list.find(fn(circuit) { set.contains(circuit, line.0) })
  let right =
    circuits |> list.find(fn(circuit) { set.contains(circuit, line.1) })

  case left, right {
    Ok(a), Ok(b) -> {
      circuits
      |> list.filter(fn(circuit) { circuit != a && circuit != b })
      |> list.prepend(set.union(a, b))
    }
    Ok(a), Error(Nil) -> {
      circuits
      |> list.filter(fn(circuit) { circuit != a })
      |> list.prepend(set.insert(a, line.1))
    }
    Error(Nil), Ok(a) -> {
      circuits
      |> list.filter(fn(circuit) { circuit != a })
      |> list.prepend(set.insert(a, line.0))
    }
    Error(Nil), Error(Nil) ->
      circuits |> list.prepend(set.from_list([line.0, line.1]))
  }
}

// Wrapper for the group all that can halt when reaching a single set with
// all the connections returning exactly the last connection
fn group_all(
  acc: #(List(Set(Coordinate3)), option.Option(#(Coordinate3, Coordinate3))),
  line: #(Coordinate3, Coordinate3),
  target: Int,
) -> list.ContinueOrStop(
  #(List(Set(Coordinate3)), option.Option(#(Coordinate3, Coordinate3))),
) {
  let #(circuits, _) = acc
  case group_circuits(circuits, line) {
    [single_circuit] as circuits -> {
      case { single_circuit |> set.to_list |> list.length } == target {
        True -> list.Stop(#([], option.Some(line)))
        False -> list.Continue(#(circuits, option.None))
      }
    }
    grouped_circuits -> list.Continue(#(grouped_circuits, option.None))
  }
}
