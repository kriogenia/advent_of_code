# Advent of Code 2023

Personal solutions to the [2023 Advent of Code](https://adventofcode.com/2023) using Typescript with Deno as the runtime.
Each day is implemented into its own file `src/day_{day}.ts`, exporting the functions to parse the input and to solve them. These are imported in runtime in the `main.ts` file. A certain day can be invoked with the `day` task:

```sh
deno task day 01
```

The test files are located in `test` and executed via `deno test -R`. The input files must be placed in `input`.

Only `std` dependencies were used. Every solution can be solved with a simple `deno` installation.


## Completion

| Day   | Part A | Part B |
| :---: | :----: | :----: |
| [Day 1](https://adventofcode.com/2023/day/1) | ⭐ | ⭐ |
| [Day 2](https://adventofcode.com/2023/day/2) | ⭐ | ⭐ |
| [Day 3](https://adventofcode.com/2023/day/3) | ⭐ | ⭐ |
| [Day 4](https://adventofcode.com/2023/day/4) | ⭐ | ⭐ |
| [Day 5](https://adventofcode.com/2023/day/5) | ⭐ | ⭐ |
| [Day 6](https://adventofcode.com/2023/day/6) | ⭐ |    |

**Total**: 11/50 ⭐


## Afterthoughts

- **Day 04**. I remembered JS/TS like really comfortable languages to write functional programming, based on things like not needing to collect and all that, but after some time working other functional languages I find the standard set of functions quite lackluster. I miss `take`, `skip`, `count`...
- **Day 05**. First real challenge where the straightforward approach was not enough. Handling ranges is quite the challenge sometimes, but also very entertaining. Oh, and every time I use a labeled loop my brain tickles.
