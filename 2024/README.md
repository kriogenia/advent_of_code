# Advent of Code 2024

Personal solutions to the [2024 Advent of Code](https://adventofcode.com/2024) using Zig 0.13.
This will be my first contact with this language. The template
used was [Zig-AoC-Template](https://github.com/SpexGuy/Zig-AoC-Template). Go give them a big star.

Each day is resolved in its own file inside `src` and runs
the related `input/day<day>.txt` file to resolve the problem.
It also contains a test for every example that can be checked
with `zig build test`.

In order to execute a day solution run `zig build day<day>`.
For example:

```sh
zig build day01
```


## Completion

| Day   | Part A | Part B |
| :---: | :----: | :----: |
| [Day 1](https://adventofcode.com/2024/day/1) | ⭐ | ⭐ |
| [Day 2](https://adventofcode.com/2024/day/2) | ⭐ | ⭐ |
| [Day 3](https://adventofcode.com/2024/day/3) | ⭐ | ⭐ |
| [Day 4](https://adventofcode.com/2024/day/4) | ⭐ | ⭐ |
| [Day 5](https://adventofcode.com/2024/day/5) | ⭐ | ⭐ |
| [Day 6](https://adventofcode.com/2024/day/6) | ⭐ |    |
| [Day 7](https://adventofcode.com/2024/day/7) | ⭐ | ⭐ |
| [Day 8](https://adventofcode.com/2024/day/8) | ⭐ | ⭐ |

**Total**: 15/50 ⭐


## Afterthoughts

- **Day 01**: My first contact with Zig has been REALLY rough, specially regarding the
documentation as I think that it's still lacking a lot. The first problem
took my hours when it should have been minutes.
- **Day 02**: I'm starting to get that Zig is all about working with arrays.
- **Day 03**: Had to add a dependency to use regex. Holy mother of Haruhi, what a painful ride.
- **Day 04**: There's no AoC without matrix navigation, innit?
- **Day 06**: The hypothesis for my second solution was wrong and I don't want to go the "attempt all" route so I'm leaving this one for later.
- **Day 07**: Would have loved to do this one multithreaded or parallel, but I'm not that comfortable with Zig yet.
