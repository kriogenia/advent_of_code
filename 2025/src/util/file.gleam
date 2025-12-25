import gleam/string
import simplifile

pub fn read_lines(from filepath: String) -> List(String) {
  let assert Ok(content) = simplifile.read(filepath)

  content
  |> string.trim_end
  |> string.split("\n")
}
