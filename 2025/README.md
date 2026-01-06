# Advent of Code 2025

Personal solutions to the [2025 Advent of Code](https://adventofcode.com/2025) using Gleam 1.13.
This will be my first contact with this language.

Each day is resolved in its own file inside `src` and runs
the related `input/day<day>.txt` file to resolve the problem.
It also contains a test for every example that can be checked
with `gleam test`.

In order to execute a day solution run `gleam run -m day_<day>`.
For example:

```sh
gleam run -m day_01
```


## Completion

| Day   | Part A | Part B |
| :---: | :----: | :----: |
| [Day 1](https://adventofcode.com/2025/day/1) | ⭐ | ⭐ |
| [Day 2](https://adventofcode.com/2025/day/2) | ⭐ | ⭐ |
| [Day 3](https://adventofcode.com/2025/day/3) | ⭐ | ⭐ |
| [Day 4](https://adventofcode.com/2025/day/4) | ⭐ | ⭐ |
| [Day 5](https://adventofcode.com/2025/day/5) | ⭐ | ⭐ |
| [Day 6](https://adventofcode.com/2025/day/6) | ⭐ | ⭐ |
| [Day 7](https://adventofcode.com/2025/day/7) | ⭐ | ⭐ |
| [Day 8](https://adventofcode.com/2025/day/8) | ⭐ | ⭐ |

**Total**: 16/50 ⭐


## Afterthoughts

- **Day 01**: Ok, I am loving this one. Functional language with
a Rust-like syntax instead of the something painful like Elixir's.
Sign me in.
- **Day 02**: While I like my solution, there's probably some optimizations
that can be done and solve the "slowness" a bit. Mainly regarding all
the parsing and serialization back and forth.
- **Day 03**: It's so pleasant when you easily adapt the logic for both parts...
- **Day 05**: Love when I can foresee improvements that they will probably ask in part 2.
- **Day 07**: Set operations and dict optimizations, the real good shit.
- **Day 08**: 14 piped functions babeeee.
