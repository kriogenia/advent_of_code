import gleam/int
import gleam/list
import gleam/string

pub type Range(a) {
  Range(start: a, end: a)
}

pub fn parse(line: String) -> Range(String) {
  line |> string.split("-") |> from_list
}

pub fn from_list(values: List(a)) -> Range(a) {
  let assert [start, end] = values as "Ranges have two values"
  Range(start, end)
}

pub fn map(range: Range(a), mapper: fn(a) -> b) -> Range(b) {
  Range(start: mapper(range.start), end: mapper(range.end))
}

pub fn inc_contains(range: Range(Int), n: Int) -> Bool {
  n >= range.start && n <= range.end
}

pub fn merge(left: Range(Int), right: Range(Int)) -> Result(Range(Int), Nil) {
  case left.end >= right.start {
    True -> Ok(Range(left.start, int.max(left.end, right.end)))
    False -> Error(Nil)
  }
}

pub fn produce(range: Range(Int)) -> List(Int) {
  list.range(range.start, range.end)
}
