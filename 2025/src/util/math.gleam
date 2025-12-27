import gleam/int

pub fn div(left: Int, right: Int) -> Int {
  let assert Ok(result) = left |> int.divide(right)
  result
}
