import { Day, FileReader, Parser, Solver, SUM } from "./common.ts";

// Both days care only about the number of matching numbers so we will just keep those
type Input = number[];

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const cards: number[] = [];
  for await (const card of gen) {
    const [_prefix, numbers] = card.split(": ");
    const [winningNumbers, scratchedNumbers] = numbers.split(" | ")
      .map((list) => list.split(/ +/));
    const matching = scratchedNumbers.filter((n) => winningNumbers.includes(n));
    cards.push(matching.length);
  }
  return cards;
};

const solveA: Solver<Input> = (input: Input) => {
  return input
    .filter((l) => l)
    .map((l) => Math.pow(2, l - 1))
    .reduce(SUM, 0);
};

const solveB: Solver<Input> = (input: Input) => {
  const copies = Array.from(Array(input.length)).map((_) => 1);
  const addCopies = (wins: number, card: number) => {
    const until = Math.min(copies.length, card + wins + 1);
    for (let i = card + 1; i < until; i++) {
      copies[i] += copies[card];
    }
  };

  input.forEach(addCopies);
  return copies.reduce(SUM, 0);
};

const day: Day<Input> = {
  a: {
    parser: parse,
    solver: solveA,
  },
  b: {
    parser: parse,
    solver: solveB,
  },
};

export default day;
