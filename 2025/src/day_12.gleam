import gleam/dict.{type Dict}
import gleam/int
import gleam/list
import gleam/result
import gleam/string
import util/file
import util/parse

const file: String = "input/day_12.txt"

pub fn main() {
  echo "Part 1: " <> { part_1(file) |> int.to_string() }
  // echo "Part 2: " <> { part_2(file) |> int.to_string() }
}

pub fn part_1(file: String) -> Int {
  let trees = file.read_lines(file) |> parse
  let #(sure, candidates) = trees |> list.partition(easy_fit)
  let survivors = candidates |> list.filter(has_enough_area)
  list.length(sure) + list.length(survivors)
}

// pub fn part_2(file: String) -> Int {
//   todo
// }

type Shape {
  Shape(content: String, area: Int)
}

type Tree {
  Tree(w: Int, h: Int, shapes: List(#(Int, Shape)))
}

fn parse(lines: List(String)) -> List(Tree) {
  let #(shapes, trees) =
    list.split_while(lines, fn(l) { !string.contains(l, "x") })

  let shapes =
    shapes
    |> list.sized_chunk(5)
    |> list.map(parse_shape)
    |> dict.from_list

  trees |> list.map(parse_tree(_, shapes))
}

fn parse_shape(lines: List(String)) -> #(Int, Shape) {
  let assert [index, ..lines] = lines
  let assert Ok(index) = string.first(index) |> result.map(parse.int)
  let content = string.join(lines, "")
  let area = string.to_graphemes(content) |> list.count(fn(c) { c == "#" })

  #(index, Shape(content:, area:))
}

fn parse_tree(line: String, shapes: Dict(Int, Shape)) -> Tree {
  let assert Ok(#(area, requirements)) = string.split_once(line, ": ")
  let assert [w, h] = string.split(area, "x") |> list.map(parse.int)

  let shapes =
    string.split(requirements, " ")
    |> list.map(parse.int)
    |> list.index_map(fn(qty, i) {
      let assert Ok(shape) = dict.get(shapes, i)
      #(qty, shape)
    })

  Tree(w:, h:, shapes:)
}

fn has_enough_area(tree: Tree) -> Bool {
  let area = tree.w * tree.h

  tree.shapes
  |> list.map(fn(x) { x.0 * { x.1 }.area })
  |> list.fold(0, int.add)
  <= area
}

fn easy_fit(tree: Tree) -> Bool {
  let total_shapes =
    tree.shapes |> list.map(fn(x) { x.0 }) |> list.fold(0, int.add)

  total_shapes <= { { tree.w / 3 } * { tree.h / 3 } }
}
