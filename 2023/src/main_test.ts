import { assertEquals } from "@std/assert";
import { Day, readFile } from "./common.ts";

const SOLUTIONS = [undefined, 142];

for (let i = 1; i < 2; i++) {
  Deno.test({
    name: `Day: ${i}`,
    fn: async () => {
      const number = i < 10 ? `0${i}` : `${i}`;
      const generator = readFile(`test/day_${number}.txt`);
      const day: Day<unknown> = (await import(`./day_${number}.ts`)).default;
      const result = day.a.parser(generator).then(day.a.solver);
      assertEquals(await result, SOLUTIONS[i]);
    },
  });
}
