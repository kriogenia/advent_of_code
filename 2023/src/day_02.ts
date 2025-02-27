import { Day, FileReader, Parser, Solver } from "./common.ts";

type Input = Game[];

interface Game {
  id: number;
  sets: Set[];
}

interface Set {
  red?: number;
  green?: number;
  blue?: number;
}

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const games = [];
  for await (const game of gen) {
    const [gameId, sets] = game.split(":");
    games.push({
      id: parseInt(gameId.split(" ")[1]!),
      sets: sets.split(";").map(parseSet),
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
  const isInvalid = (set: Set): boolean => {
    return (set.red != undefined && set.red > limit.red!) ||
      (set.green != undefined && set.green > limit.green!) ||
      (set.blue != undefined && set.blue > limit.blue!);
  }; // TODO: check if this can be simplified

  console.log(
    games.filter((game) => !game.sets.find(isInvalid)).map((g) => g.id),
  );
  return games.filter((game) => !game.sets.find(isInvalid)).reduce(
    (sum, game) => sum + game.id,
    0,
  );
};

const parseSet = (input: string): Set => {
  const dict = input.split(",").map((s) => s.trim()).map((s) => s.split(" "))
    .reduce(
      (set, [count, color]) => (set.set(color, parseInt(count)), set),
      new Map(),
    );
  return {
    blue: dict.get("blue"),
    red: dict.get("red"),
    green: dict.get("green"),
  };
};

const day: Day<Input> = {
  a: {
    parser: parse,
    solver: solveA,
  },
};

export default day;
