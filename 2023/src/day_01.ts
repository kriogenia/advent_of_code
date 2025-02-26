import { Day, FileReader, Parser, Solver } from "./common.ts";

type Input = string[];

const parse: Parser<Input> = (gen: FileReader): Promise<Input> => {
  return Array.fromAsync(gen);
};

const solveA: Solver<Input> = (input: Input) => {
  return input
    .map((line) => [...line])
    .map((chars) => `${chars.find(isDigit)}${chars.reverse().find(isDigit)}`)
    .map(Number)
    .reduce((a, b) => a + b, 0);
};

const ZERO = "0".charCodeAt(0);
const NINE = "9".charCodeAt(0);

const isDigit = (c: string): boolean => {
  const code = c.charCodeAt(0);
  return code >= ZERO && code <= NINE;
};

const day: Day<Input> = {
  a: {
    parser: parse,
    solver: solveA,
  },
};

export default day;
