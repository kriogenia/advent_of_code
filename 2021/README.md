# Advent of Code 2021

Personal solutions to the [2021 Advent of Code](https://adventofcode.com/2021) using Python 3.10. Each day is done in its
own file `aoc_2021/day_<day>.py` and can be run via `uv run python -m aoc_2021.day_<day>` (in case that you have `uv`, you
are free to use your favourite flavour), once its input file is placed as `input/day_<day>.txt`.

All the examples are also completed as tests and can be checked with:

```sh
uv pip install -e .
uv run pytest
```

No dependency is ever used so a simple Python 3.10 or later in the environment is enough to try all the solutions.

Also, there's a justfile to easily do some of these recipes:

```sh
just run 01 # to run day_01
just test   # to run all tests
just time   # to run the time suite
```



## Completion

| Day   | Part A | Part B |
| :---: | :----: | :----: |
| [Day 1](https://adventofcode.com/2021/day/1) | ⭐ | ⭐ |
| [Day 2](https://adventofcode.com/2021/day/2) | ⭐ | ⭐ |
| [Day 3](https://adventofcode.com/2021/day/3) | ⭐ | ⭐ |
| [Day 4](https://adventofcode.com/2021/day/4) | ⭐ | ⭐ |
| [Day 5](https://adventofcode.com/2021/day/5) | ⭐ | ⭐ |
| [Day 6](https://adventofcode.com/2021/day/6) | ⭐ | ⭐ |
| [Day 7](https://adventofcode.com/2021/day/7) | ⭐ | ⭐ |
| [Day 8](https://adventofcode.com/2021/day/8) | ⭐ | ⭐ |
| [Day 9](https://adventofcode.com/2021/day/9) | ⭐ | ⭐ |
| [Day 10](https://adventofcode.com/2021/day/10) | ⭐ | ⭐ |
| [Day 11](https://adventofcode.com/2021/day/11) | ⭐ | ⭐ |
| [Day 12](https://adventofcode.com/2021/day/12) | ⭐ | ⭐ |
| [Day 13](https://adventofcode.com/2021/day/13) | ⭐ | ⭐ |
| [Day 14](https://adventofcode.com/2021/day/14) | ⭐ | ⭐ |
| [Day 15](https://adventofcode.com/2021/day/15) | ⭐ | ⭐ |
| [Day 16](https://adventofcode.com/2021/day/16) | ⭐ | ⭐ |

**Total**: 32/50 ⭐



## Times

|  Day  |  Part A   |  Part B   |
|-------|-----------|-----------|
|     1 | 334.591µs | 473.065µs |
|     2 | 489.326µs | 425.905µs |
|     3 | 982.690µs | 398.102µs |
|     4 |   3.731ms |   8.749ms |
|     5 |  37.771ms |  62.610ms |
|     6 | 143.714ms | 554.552µs |
|     7 |   3.475ms |  12.851ms |
|     8 | 162.200µs |   3.143ms |
|     9 |   6.548ms |  18.722ms |
|    10 | 677.096µs | 672.126µs |
|    11 |   2.577ms |   8.520ms |
|    12 |  11.782ms | 316.496ms |
|    13 | 527.589µs |   1.347ms |
|    14 | 249.167µs | 911.104µs |
|    15 |  38.189ms |   1.265s  |
|    16 |   1.581ms |   1.348ms |
|    17 |           |           |
|    18 |           |           |
|    19 |           |           |
|    20 |           |           |
|    21 |           |           |
|    22 |           |           |
|    23 |           |           |
|    24 |           |           |
|    25 |           |           |
| Total | 252.791ms |   1.702s  |

## Afterthoughts

- This didn't exist at first but I will take the chance to create them while migrating the whole thing.
- I'm not a fan of `__getattribute__` but this is inputs like the one in **Day 02** are the kind of places where it is handy.
- **Day 04**, the day that will always be known as they I used a for-else.
- Taking the floor and ceil averages in **Day 07** to work with both the example and input seems like a hack, but getting the solution is what matters.
- So I came back three years later to finish the second part of the **Day 08** and it was quite the different thing.
- First use of `@functools.cache` in **Day 10**, I'm a pro.
- On one side the way to get the solution of the **Day 13 Part B** is amazing, but on the other hand it breaks my whole structure.
- Tried to come up with a new, shiny and convoluted solution for **Day 14** and I did it worse. Kudos to my past self of 5 years ago.
- I Love to implement state machines like in **Day 16**, but this one was a bit of a pain to debug.
