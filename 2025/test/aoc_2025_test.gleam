import day_01
import day_02
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn day_1_test() {
  assert day_01.part_1("examples/day_01.txt") == 3
  assert day_01.part_2("examples/day_01.txt") == 6
}

pub fn day_2_test() {
  assert day_02.part_1("examples/day_02.txt") == 1_227_775_554
}
