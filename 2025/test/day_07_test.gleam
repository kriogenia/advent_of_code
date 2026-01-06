import day_07
import gleam/set

pub fn get_splitters_test() {
  assert day_07.get_splitters("...............") == set.new()
  assert day_07.get_splitters(".......^.......") |> set.to_list == [7]
  assert day_07.get_splitters("......^.^......") |> set.to_list == [6, 8]
}
