import { Day, FileReader, Parser, Solver, SUM } from "./common.ts";

type Input = Schematic;

interface Schematic {
  numbers: PartNumber[];
  symbols: Symbol[];
  gears: Symbol[];
}

interface Symbol {
  row: number;
  col: number;
}

// TODO: optimize to just handle the row and the start and end cols?
class PartNumber {
  number: number;
  row: number;
  start: number;
  end: number;

  constructor(number: number, row: number, start: number) {
    this.number = number;
    this.row = row;
    this.start = start;
    this.end = start;
  }

  append(number: number) {
    this.number = this.number * 10 + number;
    this.end += 1;
  }

  isColumnAdjacent(x: number): boolean {
    return x >= (this.start - 1) && x <= (this.end + 1);
  }
}

const parse: Parser<Input> = async (gen: FileReader): Promise<Input> => {
  const numbers: PartNumber[] = [];
  const symbols: Symbol[] = [];
  const gears: Symbol[] = [];

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
          numBuffer = new PartNumber(parsed, row, col);
        } else {
          numBuffer.append(parsed);
        }
        return;
      }

      if (c !== ".") {
        symbols.push({ row: row, col: col });
        if (c === "*") {
          gears.push({ row: row, col: col });
        }
      }
      checkNumBuffer();
    });

    checkNumBuffer();
    row++;
  }

  return {
    numbers: numbers,
    symbols: symbols,
    gears: gears,
  };
};

const solveA: Solver<Input> = (schematic: Input) => {
  const hasAdjacentSymbol = symbolSearcher(schematic.symbols);
  return schematic.numbers
    .filter(hasAdjacentSymbol)
    .map((n) => n.number)
    .reduce(SUM, 0);
};

const solveB: Solver<Input> = (schematic: Input) => {
  const findAdjacentNumbers = numberSearcher(schematic.numbers);
  return schematic.gears
    .map(findAdjacentNumbers)
    .filter((ns) => ns.length == 2)
    .map((ns) => ns[0].number * ns[1].number)
    .reduce(SUM, 0);
};

const isAdjacent = (distance: number) => distance >= -1 && distance <= 1;

const symbolSearcher = (
  symbols: Symbol[],
): (num: PartNumber) => boolean => {
  return (num) => {
    return symbols
      .filter((s) => isAdjacent(num.row - s.row))
      .find((s) => num.isColumnAdjacent(s.col)) != undefined;
  };
};

const numberSearcher = (
  numbers: PartNumber[],
): (sym: Symbol) => PartNumber[] => {
  return (sym) => {
    return numbers
      .filter((n) => isAdjacent(sym.row - n.row))
      .filter((n) => n.isColumnAdjacent(sym.col));
  };
};

const day: Day<Input> = {
  parser: parse,
  a: solveA,
  b: solveB,
};

export default day;
