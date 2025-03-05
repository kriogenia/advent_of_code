import { Day, FileReader, Parser, Solver } from "./common.ts";

type Input = Almanac;

interface Almanac {
  seeds: number[];
  maps: AlmanacMap[];
}

class AlmanacMap {
  private ranges: Range[] = [];

  addRange = ([sourceStart, destStart, range]: number[]) => {
    this.ranges.push(new Range(sourceStart, destStart, range));
  };

  map = (value: number): number => {
    return this.ranges.find((range) => range.contains(value))
      ?.map(value) || value;
  };

  process = (windows: Window[]): Window[] => {
    const next = [];
    windowsLoop: while (windows.length > 0) {
      const win = windows.pop()!;

      for (const range of this.ranges) {
        const [mapped, ...sections] = range.intersect(win);
        if (mapped) {
          next.push(mapped);
          windows = [...windows, ...sections];
          continue windowsLoop;
        }
      }

      next.push(win);
    }
    return next;
  };
}

class Range {
  private offset: number;
  private sourceEnd: number;

  constructor(
    destination: number,
    private sourceStart: number,
    range: number,
  ) {
    this.sourceStart = sourceStart;
    this.offset = destination - sourceStart;
    this.sourceEnd = sourceStart + range;
  }

  contains = (value: number): boolean => {
    return (value >= this.sourceStart && value < this.sourceEnd);
  };

  map = (value: number): number => {
    return this.offset + value;
  };

  // If the window intersects with the range, generates and maps the intersection returning it
  // as the first value of the array, following can be the derived subranges if any.
  // If there's no intersection returns an empty array
  intersect = (window: Window): Window[] => {
    const intersections = [];
    const start = Math.max(window.start, this.sourceStart);
    const end = Math.min(window.end, this.sourceEnd);

    if (end > start) {
      intersections.push(new Window(start + this.offset, end + this.offset));
      if (window.start < start) {
        intersections.push(new Window(window.start, start));
      }
      if (window.end > end) {
        intersections.push(new Window(end, window.end));
      }
    }

    return intersections;
  };
}

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const seeds = gen.next()
    .then((l) => l.value!.split(": ")[1])
    .then((n) => n.split(" ").map(Number));
  gen.next(); // discard empty line

  const maps = [];
  while (true) {
    const map = await parseMap(gen);
    if (!map) {
      break;
    }
    maps.push(map!);
  }

  return {
    seeds: await seeds,
    maps: maps,
  };
};

const parseMap = async (gen: FileReader): Promise<AlmanacMap | null> => {
  const nextLine = async () => (await gen.next()).value;
  if (!(await gen.next()).value?.includes("map:")) {
    return null;
  }

  const map = new AlmanacMap();
  for (let line = await nextLine(); line; line = await nextLine()) {
    map.addRange(line.split(" ").map(Number));
  }

  return map;
};

const solveA: Solver<Input> = (input: Input) => {
  return input.seeds
    .map((n) => input.maps.reduce((val, map) => map.map(val), n))
    .reduce((a, b) => Math.min(a, b));
};

interface Window {
  start: number;
  end: number;
}

const solveB: Solver<Input> = (input: Input) => {
  const windows = [];
  for (let i = 0; i < input.seeds.length; i += 2) {
    windows.push(
      {
        start: input.seeds[i],
        end: input.seeds[i] + input.seeds[i + 1],
      },
    );
  }

  return input.maps
    .reduce((windows, m) => m.process(windows), windows)
    .map((w) => w.start).reduce((a, b) => Math.min(a, b));
};

const day: Day<Input> = {
  parser: parse,
  a: solveA,
  b: solveB,
};

export default day;
