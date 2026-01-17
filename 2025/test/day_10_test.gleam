import day_10
import gleam/int
import gleam/list

pub fn light_to_mask_test() {
  assert day_10.light_to_mask("[.##.]") == 6
  assert day_10.light_to_mask("[...#.]") == 8
  assert day_10.light_to_mask("[.###.#]") == 46
}

pub fn schematic_to_mask_test() {
  assert day_10.schematic_to_mask("(3)") == 8
  assert day_10.schematic_to_mask("(1,3)") == 10
  assert day_10.schematic_to_mask("(0,1,2,3,4)") == 31
}

pub fn xor_test() {
  assert [5, 3] |> list.reduce(int.bitwise_exclusive_or) == Ok(6)
  assert [12, 10] |> list.reduce(int.bitwise_exclusive_or) == Ok(6)
  assert [17, 7, 30] |> list.reduce(int.bitwise_exclusive_or) == Ok(8)
  assert [25, 55] |> list.reduce(int.bitwise_exclusive_or) == Ok(46)
}
