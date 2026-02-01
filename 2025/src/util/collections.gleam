import gleam/bool
import gleam/dict.{type Dict}
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

pub fn pad(list: List(a), default: a, target: Int) -> List(a) {
  use <- bool.guard(target == 0, [])
  case list {
    [first, ..rest] -> list.append([first], pad(rest, default, target - 1))
    [] -> list.append([default], pad([], default, target - 1))
  }
}

pub fn count(items: List(a)) -> Dict(a, Int) {
  items
  |> list.fold(dict.new(), fn(dic, item) {
    case dict.get(dic, item) {
      Ok(exists) -> dict.insert(dic, item, exists + 1)
      Error(_) -> dict.insert(dic, item, 1)
    }
  })
}
