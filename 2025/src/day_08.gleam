import gleam/int
import gleam/io
import gleam/list
import gleam/result
import gleam/set.{type Set}
import gleam/string
import util/coordinates.{type Coordinate3}
import util/file
import util/parse

const file: String = "input/day_08.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file, target: 1000) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String, target connections: Int) -> Int {
  file.read_lines(file)
  |> list.map(coordinates.parse)
  |> list.combination_pairs
  |> list.map(fn(pair) { #(pair, coordinates.distance(pair)) })
  |> list.sort(fn(a, b) { int.compare(a.1, b.1) })
  |> list.take(connections)
  |> list.map(fn(line) { line.0 })
  |> list.fold(list.new(), group_circuits)
  |> list.map(set.to_list)
  |> list.map(list.length)
  |> list.sort(fn(a, b) { int.compare(b, a) })
  |> list.take(3)
  |> list.reduce(int.multiply)
  |> result.unwrap(0)
}

pub fn part_2(file: String) -> Int {
  todo
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
