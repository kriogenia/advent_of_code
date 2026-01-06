import gleam/list

pub fn index_of(list: List(a), target: a) -> Result(Int, Nil) {
  let length = list |> list.length
  case
    list
    |> list.fold_until(0, fn(index, value) {
      case value == target {
        True -> list.Stop(index)
        False -> list.Continue(index + 1)
      }
    })
  {
    idx if idx == length -> Error(Nil)
    idx -> Ok(idx)
  }
}

pub fn remove_last(list: List(a)) -> List(a) {
  case list |> list.reverse {
    [_first, ..rest] -> list.reverse(rest)
    [] -> []
  }
}
