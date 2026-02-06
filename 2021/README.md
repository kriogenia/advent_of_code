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


! > [!NOTE]
> I am in the middle of cleaning the project and migrating the first scripts to this new structure.


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

**Total**: 30/50 ⭐



## Times

|  Day  |  Part A   |  Part B   |
|-------|-----------|-----------|
|     1 | 335.863µs | 473.026µs |
|     2 | 404.886µs | 396.831µs |
|     3 | 933.188µs | 374.387µs |
|     4 |   3.604ms |   8.821ms |
|     5 |  32.840ms |  60.424ms |
|     6 | 174.821ms | 521.149µs |
|     7 |   3.435ms |  12.927ms |
|     8 | 161.790µs |   3.109ms |
|     9 |   6.707ms |  19.278ms |
|    10 |           |           |
|    11 |           |           |
|    12 |           |           |
|    13 |           |           |
|    14 |           |           |
|    15 |           |           |
|    16 |           |           |
|    17 |           |           |
|    18 |           |           |
|    19 |           |           |
|    20 |           |           |
|    21 |           |           |
|    22 |           |           |
|    23 |           |           |
|    24 |           |           |
|    25 |           |           |
| Total | 223.241ms | 106.324ms |

## Afterthoughts

- This didn't exist at first but I will take the chance to create them while migrating the whole thing.
- I'm not a fan of `__getattribute__` but this is inputs like the one in **Day 02** are the kind of places where it is handy.
- **Day 04**, the day that will always be known as they I used a for-else.
- Taking the floor and ceil averages in **Day 07** to work with both the example and input seems like a hack, but getting the solution is what matters.
- So I came back three years later to finish the second part of the **Day 08** and it was quite the different thing.
