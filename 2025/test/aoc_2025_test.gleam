import day_01
import gleeunit

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn part_1_test() {
  assert day_01.part_1("examples/day_01.txt") == 3
}
