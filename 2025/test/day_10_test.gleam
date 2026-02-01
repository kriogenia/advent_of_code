import day_10
import gleam/int
import gleam/list

pub fn light_to_mask_test() {
  assert day_10.light_to_mask("[.##.]") == 6
  assert day_10.light_to_mask("[...#.]") == 8
  assert day_10.light_to_mask("[.###.#]") == 46
}

pub fn xor_test() {
  assert [5, 3] |> list.reduce(int.bitwise_exclusive_or) == Ok(6)
  assert [12, 10] |> list.reduce(int.bitwise_exclusive_or) == Ok(6)
  assert [17, 7, 30] |> list.reduce(int.bitwise_exclusive_or) == Ok(8)
  assert [25, 55] |> list.reduce(int.bitwise_exclusive_or) == Ok(46)
}

pub fn binary_to_decimal_test() {
  assert [1, 1, 0, 1] |> day_10.binary_to_decimal == 11
  assert [1, 1, 0, 1, 0] |> day_10.binary_to_decimal == 11
  assert [0, 1, 1, 1, 0, 1] |> day_10.binary_to_decimal == 46
}
