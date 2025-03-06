import { Day, FileReader, MUL, Parser, Solver } from "./common.ts";

type Input = Race[];

interface Race {
  time: number;
  distance: number;
}

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const times = gen.next()
    .then((val) => {
      const [_, ...times] = val.value!.split(/ +/);
      return times.map(Number);
    });
  const distances = gen.next()
    .then((val) => {
      const [_, ...distances] = val.value!.split(/ +/);
      return distances.map(Number);
    });
  return await Promise.all([times, distances]).then(([times, distances]) =>
    times.map((t, i) => {
      return {
        time: t,
        distance: distances[i],
      };
    })
  );
};

const solveA: Solver<Input> = (input: Input) => {
  const expectedDistance = (charge: number, time: number) =>
    charge * (time - charge);
  const minDistance = (race: Race): number => {
    for (let i = 0; i < race.distance - 1; i++) {
      if (expectedDistance(i, race.time) > race.distance) {
        return i;
      }
    }
    throw Error("unreachable");
  };

  return input
    .map((race) => (race.time + 1) - minDistance(race) * 2)
    .reduce(MUL);
};

const day: Day<Input> = {
  parser: parse,
  a: solveA,
  // b: solveB,
};

export default day;
