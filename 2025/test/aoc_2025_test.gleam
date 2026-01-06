import day_01
import day_02
import day_03
import day_04
import day_05
import day_06
import day_07
import day_08
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
  assert day_03.part_2("examples/day_03.txt") == 3_121_910_778_619
}

pub fn day_04_test() {
  assert day_04.part_1("examples/day_04.txt") == 13
  assert day_04.part_2("examples/day_04.txt") == 43
}

pub fn day_05_test() {
  assert day_05.part_1("examples/day_05.txt") == 3
  assert day_05.part_2("examples/day_05.txt") == 14
}

pub fn day_06_test() {
  assert day_06.part_1("examples/day_06.txt") == 4_277_556
  assert day_06.part_2("examples/day_06.txt") == 3_263_827
}

pub fn day_07_test() {
  assert day_07.part_1("examples/day_07.txt") == 21
  assert day_07.part_2("examples/day_07.txt") == 40
}

pub fn day_08_test() {
  assert day_08.part_1("examples/day_08.txt", target: 10) == 40
  // assert day_08.part_2("examples/day_08.txt") == 40
}
