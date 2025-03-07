# Advent of Code 2022

Solutions for [Advent of Code 2022](https://adventofcode.com/2022) using [Rust](https://www.rust-lang.org/).
This repository uses a template of [fspoettel](https://github.com/fspoettel/advent-of-code-rust) to make an extremely comfortable experience. Go give them some star!!

To run a specific solution you only need to have the input in the `inputs` folder
with the naming `<day>.txt` and run `cargo solve` with the day code. This crate
can automatically download the solution if you have `aoc-cli` set-up. For example:

```sh
cargo download 07
cargo solve 07
```

To run all the problems you can use `cargo all` and every test (this one uses the
examples) with `cargo test`.


## Completion

| Day   | Part A | Part B |
| :---: | :----: | :----: |
| [Day 1](https://adventofcode.com/2022/day/1) | ⭐ | ⭐ |
| [Day 2](https://adventofcode.com/2022/day/2) | ⭐ | ⭐ |
| [Day 3](https://adventofcode.com/2022/day/3) | ⭐ | ⭐ |
| [Day 4](https://adventofcode.com/2022/day/4) | ⭐ | ⭐ |
| [Day 5](https://adventofcode.com/2022/day/5) | ⭐ | ⭐ |
| [Day 6](https://adventofcode.com/2022/day/6) | ⭐ | ⭐ |
| [Day 7](https://adventofcode.com/2022/day/7) | ⭐ | ⭐ |
| [Day 8](https://adventofcode.com/2022/day/8) | ⭐ | ⭐ |
| [Day 9](https://adventofcode.com/2022/day/9) | ⭐ | ⭐ |
| [Day 10](https://adventofcode.com/2022/day/10) | ⭐ | ⭐ |
| [Day 11](https://adventofcode.com/2022/day/11) | ⭐ | ⭐ |
| [Day 12](https://adventofcode.com/2022/day/12) | ⭐ | ⭐ |
| [Day 13](https://adventofcode.com/2022/day/13) | ⭐ | ⭐ |
| [Day 14](https://adventofcode.com/2022/day/14) | ⭐ | ⭐ |
| [Day 15](https://adventofcode.com/2022/day/15) | ⭐ | ⭐ |

**Total**: 30/50 ⭐


## Times

The following times were recorded in my local machine. Parsing time is usually considered out of the equation but I will probably update the code to add that measuring too.

|            | **Set-up** | **Part 1** | **Part 2** | **Total**  |
|------------|------------|------------|------------|------------|
| **Day 01** | 159.31µs   | 8.03µs     | 16.83µs    | 184.17µs   |
| **Day 02** | 71.94µs    | 29.82µs    | 31.50µs    | 133.26µs   |
| **Day 03** | 27.59µs    | 189.48µs   | 195.84µs   | 412.81µs   |
| **Day 04** | 220.14µs   | 2.86µs     | 1.89µs     | 224.89µs   |
| **Day 05** | 81.02µs    | 13.97µs    | 32.48µs    | 127.37µs   |
| **Day 06** | 16.90µs    | 8.94µs     | 18.58µs    | 44.42µs    |
| **Day 07** | 266.52µs   | 23.89µs    | 31.92µs    | 322.33µs   |
| **Day 08** | 37.99µs    | 30.38µs    | 225.73µs   | 294.10µs   |
| **Day 09** | 120.69µs   | 728.38µs   | 794.59µs   | 1643.66µs  |
| **Day 10** | 25.28µs    | 908.00ns   | 4.82µs     | 31.01µs    |
| **Day 11** | 28.71µs    | 39.95µs    | 16.08ms    | 16.77ms    |
| **Day 12** | 26.75µs    | 3.84ms     | 1.82ms     | 5.69ms     |
| **Day 13** | 401.24µs   | 7.61µs     | 216.16µs   | 625.01µs   |
| **Day 14** | 357.03µs   | 159.87µs   | 7.00ms     | 7.52ms     |
| **Day 14** | ?   | ?   | ?     | ?     |

Total running time for all days and parts: **49.40ms** (at the moment).

## Afterthoughts

* The template of *fspoettel* is awesome but I tweaked a bit to match my intentions, like parsing the input just once for both parts if it's possible.
* The ASCII inputs are awesome to work with bytes instead of strings and improve the performance times.
* `Rc<RefCell<T>>` combo really asks for macros and the use of `type` to stop those painfully long lines.
* I love to craft specialized data structures like I had to do on **Day 06**.
* I'm pretty proud of the decision to build a bigger array for the `Marker` data structure of **Day 06**. It allowed me to do the array advancement a lot better.
* The **Day 06** I decided to use traits and a bit of duplicated code, it would have worked with const generics but I wanted to make at least one solution based on default trait implementations for dedicated structs.
* I was trying to make some weird things to solve **Day 07** instead of the logic approaches and that made me lose a lot of time. I was actually defeated the first day and had to left it to the next. It was easy with the obvious approach.
* For **Day 08** I looked the size of the grid manually to use arrays. I see it as part of the optimization, sorry not sorry. To deal with the difference between the example and input I used the `[cfg()]` macro and it worked wonders. Macros were also a big part of this day.
* At last, in **Day 09** const generics made an appearance. It's a wonderful tool for these type of exercises where you sometimes need to work with different sizes and don't want to use Vec. I also had to use `Copy` for the first time.
* My little experience with emulation was a good help for **Day 10**.
* The actual computation of **Day 10** is solely based on the input preparation so I really need to create the measurement for the loading part.
* I actually enjoyed the complex parsing required on **Day 11** and the complex deduction needed.
