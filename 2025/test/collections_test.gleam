import util/collections

pub fn index_of_test() {
  assert [0, 1, 2, 3] |> collections.index_of(3) == Ok(3)
  assert ["a", "b", "c"] |> collections.index_of("b") == Ok(1)
  assert ["a", "b", "c"] |> collections.index_of("d") == Error(Nil)
}
