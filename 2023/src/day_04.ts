import { Day, FileReader, Parser, Solver, SUM } from "./common.ts";

type Input = Scratchcard[];

// Using heaps could probably be better, but let's keep the code dependency-free
interface Scratchcard {
  winning: number[];
  scratched: number[];
}

const WS_RE = / +/;

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const cards: Scratchcard[] = [];
  for await (const card of gen) {
    const [_prefix, numbers] = card.split(": ");
    const [winningNumbers, scratchedNumbers] = numbers.split(" | ");
    // IMP? split at text + filter out empty splits could perform better?
    cards.push({
      winning: winningNumbers.split(WS_RE).map(Number),
      scratched: scratchedNumbers.split(WS_RE).map(Number),
    });
  }
  return cards;
};

const solveA: Solver<Input> = (input: Input) => {
  return input
    .map((card) => card.scratched.filter((n) => card.winning.includes(n)))
    .map((nums) => nums.length)
    .filter((l) => l) // missing a good map_filter here tho
    .map((l) => Math.pow(2, l - 1))
    .reduce(SUM, 0);
};

const day: Day<Input> = {
  a: {
    parser: parse,
    solver: solveA,
  },
  // b: {
  //   parser: parse,
  //   solver: solveB,
  // },
};

export default day;
