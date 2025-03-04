import { Day, FileReader, Parser, Solver, SUM } from "./common.ts";

type Input = Game[];

interface Game {
  id: number;
  max: Set;
}

interface Set {
  red: number;
  green: number;
  blue: number;
}

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const games = [];
  for await (const game of gen) {
    const [gameId, sets] = game.split(":");
    games.push({
      id: parseInt(gameId.split(" ")[1]!),
      max: sets.split(";").map(parseSet).reduce(maxSet, {
        red: 0,
        green: 0,
        blue: 0,
      }),
    });
  }
  return games;
};

const solveA: Solver<Input> = (games: Input) => {
  const limit: Set = {
    red: 12,
    green: 13,
    blue: 14,
  };

  const isValid = ({ max }: Game): boolean => {
    return max.red <= limit.red && max.green <= limit.green &&
      max.blue <= limit.blue!;
  };

  return games.filter(isValid).reduce((sum, game) => sum + game.id, 0);
};

const solveB: Solver<Input> = (games: Input) => {
  return games.map((game) => game.max).map((max) =>
    max.red * max.green * max.blue
  ).reduce(SUM, 0);
};

const maxSet = (left: Set, right: Set): Set => {
  return {
    red: Math.max(left.red, right.red),
    green: Math.max(left.green, right.green),
    blue: Math.max(left.blue, right.blue),
  };
};

const parseSet = (input: string): Set => {
  const dict = input.split(",")
    .map((s) => s.trim())
    .map((s) => s.split(" "))
    .reduce(
      (set, [count, color]) => (set.set(color, parseInt(count)), set),
      new Map(),
    );
  return {
    blue: dict.get("blue") || 0,
    red: dict.get("red") || 0,
    green: dict.get("green") || 0,
  };
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
