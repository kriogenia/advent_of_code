import day_02

pub fn calculate_divisors_test() {
  assert day_02.calculate_divisions(2) == [#(1, 2)]
  assert day_02.calculate_divisions(4) == [#(1, 4), #(2, 2)]
  assert day_02.calculate_divisions(6) == [#(1, 6), #(2, 3), #(3, 2)]
  assert day_02.calculate_divisions(8) == [#(1, 8), #(2, 4), #(4, 2)]
}
