import { Day, FileReader, Parser, Solver, SUM } from "./common.ts";

type Input = Schematic;

interface Schematic {
  numbers: PartNumber[];
  symbols: Coordinate[];
}

interface Coordinate {
  row: number;
  col: number;
}

// TODO: optimize to just handle the row and the start and end cols?
class PartNumber {
  number: number;
  start: Coordinate;
  end: Coordinate;

  constructor(number: number, start: Coordinate) {
    this.number = number;
    this.start = start;
    this.end = { row: start.row, col: start.col };
  }

  append(number: number) {
    this.number = this.number * 10 + number;
    this.end.col += 1;
  }

  isColumnAdjacent(x: number): boolean {
    return x >= (this.start.col - 1) && x <= (this.end.col + 1);
  }
}

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const numbers: PartNumber[] = [];
  const symbols: Coordinate[] = [];

  let row = 0;
  for await (const line of gen) {
    let numBuffer: PartNumber | null = null;
    const checkNumBuffer = () => {
      if (numBuffer) {
        numbers.push(numBuffer);
        numBuffer = null;
      }
    };

    [...line].forEach((c, col) => {
      const parsed = Number.parseInt(c);
      if (!Number.isNaN(parsed)) {
        if (!numBuffer) {
          numBuffer = new PartNumber(parsed, { row: row, col: col });
        } else {
          numBuffer.append(parsed);
        }
        return;
      }

      if (c !== ".") {
        symbols.push({ row: row, col: col });
      }
      checkNumBuffer();
    });

    checkNumBuffer();
    row++;
  }

  return {
    numbers: numbers,
    symbols: symbols,
  };
};

const solveA: Solver<Input> = (schematic: Input) => {
  const hasAdjacentSymbol = symbolSearcher(schematic.symbols);
  return schematic.numbers
    .filter(hasAdjacentSymbol)
    .map((n) => n.number)
    .reduce(SUM, 0);
};

const symbolSearcher = (
  symbols: Coordinate[],
): (num: PartNumber) => boolean => {
  const isAdjacent = (distance: number) => distance >= -1 && distance <= 1;
  return (num) => {
    return symbols
      .filter((s) => isAdjacent(num.start.row - s.row))
      .find((s) => num.isColumnAdjacent(s.col)) != undefined;
  };
};

const day: Day<Input> = {
  a: {
    parser: parse,
    solver: solveA,
  },
};

export default day;
