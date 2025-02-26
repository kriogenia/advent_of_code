import { Day, FileReader, Parser, Solver } from "./common.ts";

type Input = string[];

const parse: Parser<Input> = (gen: FileReader): Promise<Input> => {
  return Array.fromAsync(gen);
};

const solveA: Solver<Input> = (input: Input) => {
  return input.length;
};

const day: Day<Input> = {
  a: {
    parser: parse,
    solver: solveA,
  },
};

export default day;
