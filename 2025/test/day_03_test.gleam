import day_03

pub fn find_max_test() {
  assert day_03.find_max([9, 8, 7, 6, 5, 4, 3, 2, 1]) == #(0, 9)
  assert day_03.find_max([8, 1, 8, 1, 8, 1, 9, 1, 1]) == #(6, 9)
  assert day_03.find_max([2, 3, 4, 2, 3, 4, 2, 3, 7]) == #(8, 7)
}
