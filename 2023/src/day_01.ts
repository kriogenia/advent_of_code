import { Day, FileReader, Parser, Solver, SUM } from "./common.ts";

type Input = string[];

const parse: Parser<Input> = (gen: FileReader): Promise<Input> => {
  return Array.fromAsync(gen);
};

const solveA: Solver<Input> = (input: Input) => {
  return input
    .map((line) => [...line])
    .map((chars) => `${chars.find(isDigit)}${chars.reverse().find(isDigit)}`)
    .map(Number)
    .reduce(SUM, 0);
};

const solveB: Solver<Input> = (input: Input) => {
  let total = 0;
  for (const line of input) {
    const matches = Array.from(line.matchAll(PART_B_MATCH)!.map((m) => m[1]));
    const add = +`${toNumber(matches[0])}${toNumber(matches.at(-1)!)}`;
    total += add;
  }
  return total;
};

const ZERO = "0".charCodeAt(0);
const NINE = "9".charCodeAt(0);

const PART_B_MATCH = /(?=(one|two|three|four|five|six|seven|eight|nine|\d))/g;

const isDigit = (c: string): boolean => {
  const code = c.charCodeAt(0);
  return code >= ZERO && code <= NINE;
};

const DIGIT_WORDS: { [key: string]: string } = {
  one: "1",
  two: "2",
  three: "3",
  four: "4",
  five: "5",
  six: "6",
  seven: "7",
  eight: "8",
  nine: "9",
};

const toNumber = (str: string): string => {
  if (!str) {
    return "";
  }
  if (str.length === 1) {
    return parseInt(str).toString();
  }
  return DIGIT_WORDS[str] || "";
};

const day: Day<Input> = {
  parser: parse,
  a: solveA,
  b: solveB,
};

export default day;
