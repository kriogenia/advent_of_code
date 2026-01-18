import gleam/int

pub fn div(left: Int, right: Int) -> Int {
  let assert Ok(result) = left |> int.divide(right)
  result
}

pub fn mod(left: Int, right: Int) -> Int {
  let assert Ok(result) = left |> int.modulo(right)
  result
}
