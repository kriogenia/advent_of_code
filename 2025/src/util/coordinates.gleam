import gleam/int
import gleam/list
import gleam/string
import util/parse

pub type Coordinate2 {
  Coordinate2(x: Int, y: Int)
}

pub fn parse2(line: String) -> Coordinate2 {
  case string.split(line, ",") |> list.map(parse.int) {
    [x, y] -> Coordinate2(x:, y:)
    _ -> panic as "must be a 3D coordinate"
  }
}

pub fn neighbours(roll: Coordinate2) -> List(Coordinate2) {
  [
    Coordinate2(roll.x - 1, roll.y - 1),
    Coordinate2(roll.x, roll.y - 1),
    Coordinate2(roll.x + 1, roll.y - 1),
    Coordinate2(roll.x - 1, roll.y),
    Coordinate2(roll.x + 1, roll.y),
    Coordinate2(roll.x - 1, roll.y + 1),
    Coordinate2(roll.x, roll.y + 1),
    Coordinate2(roll.x + 1, roll.y + 1),
  ]
}

pub type Boundaries {
  Boundaries(min_x: Int, max_x: Int, min_y: Int, max_y: Int)
}

pub fn boundaries(pair: #(Coordinate2, Coordinate2)) -> Boundaries {
  Boundaries(
    min_x: int.min({ pair.0 }.x, { pair.1 }.x),
    max_x: int.max({ pair.0 }.x, { pair.1 }.x),
    min_y: int.min({ pair.0 }.y, { pair.1 }.y),
    max_y: int.max({ pair.0 }.y, { pair.1 }.y),
  )
}

pub type Coordinate3 {
  Coordinate3(x: Int, y: Int, z: Int)
}

pub fn parse3(line: String) -> Coordinate3 {
  case string.split(line, ",") |> list.map(parse.int) {
    [x, y, z] -> Coordinate3(x:, y:, z:)
    _ -> panic as "must be a 3D coordinate"
  }
}

pub fn distance(pair: #(Coordinate3, Coordinate3)) -> Int {
  let #(left, right) = pair
  let x = left.x - right.x
  let y = left.y - right.y
  let z = left.z - right.z
  { x * x } + { y * y } + { z * z }
}
