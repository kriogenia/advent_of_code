import { Day, FileReader, Parser, Solver } from "./common.ts";

type Input = Almanac;

interface Almanac {
  seeds: number[];
  maps: AlmanacMap[];
}

class AlmanacMap {
  ranges: Range[];

  constructor() {
    this.ranges = [];
  }

  addRange = ([sourceStart, destStart, range]: number[]) => {
    this.ranges.push(new Range(sourceStart, destStart, range));
  };

  map = (value: number): number => {
    return this.ranges.find((range) => range.contains(value))?.map(value) ||
      value;
  };
}

class Range {
  start: number;
  range: number;
  offset: number;

  constructor(destination: number, source: number, range: number) {
    this.start = source;
    this.offset = destination - source;
    this.range = range;
  }

  contains = (value: number): boolean => {
    const distance = value - this.start;
    return (distance >= 0 && distance < this.range);
  };

  map = (value: number): number => {
    return this.offset + value;
  };
}

const N_MAPS = 7;

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const seeds = gen.next()
    .then((l) => l.value!.split(": ")[1])
    .then((n) => n.split(" ").map(Number));
  gen.next(); // discard empty line

  const maps = [];
  while (maps.length < N_MAPS) {
    maps.push(await parseMap(gen));
  }

  return {
    seeds: await seeds,
    maps: maps,
  };
};

const parseMap = async (gen: FileReader): Promise<AlmanacMap> => {
  const nextLine = async () => (await gen.next()).value;
  gen.next();

  const map = new AlmanacMap();
  for (let line = await nextLine(); line; line = await nextLine()) {
    map.addRange(line.split(" ").map(Number));
  }

  return map;
};

const solveA: Solver<Input> = (input: Input) => {
  return input.seeds
    .map((x) => input.maps.reduce((prev, current) => current.map(prev), x))
    .reduce((a, b) => Math.min(a, b));
};

const day: Day<Input> = {
  parser: parse,
  a: solveA,
  // b: solveB,
};

export default day;
