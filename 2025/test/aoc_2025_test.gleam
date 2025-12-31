import day_01
import day_02
import day_03
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn day_01_test() {
  assert day_01.part_1("examples/day_01.txt") == 3
  assert day_01.part_2("examples/day_01.txt") == 6
}

pub fn day_02_test() {
  assert day_02.part_1("examples/day_02.txt") == 1_227_775_554
  assert day_02.part_2("examples/day_02.txt") == 4_174_379_265
}

pub fn day_03_test() {
  assert day_03.part_1("examples/day_03.txt") == 357
}
