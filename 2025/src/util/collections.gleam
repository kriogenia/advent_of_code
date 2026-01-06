import gleam/dict
import gleam/list
import gleam/set

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

pub fn merge_to_dict(
  list: List(#(a, b)),
  merger: fn(b, b) -> b,
) -> dict.Dict(a, b) {
  list
  |> list.fold(dict.new(), fn(acc, tuple) {
    let val = case acc |> dict.get(tuple.0) {
      Ok(stored) -> merger(stored, tuple.1)
      Error(_) -> tuple.1
    }
    dict.insert(acc, tuple.0, val)
  })
}
