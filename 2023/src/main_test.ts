import { assertEquals } from "@std/assert";
import { Day, readFile } from "./common.ts";

const PART_A = [undefined, 142];
const PART_B = [undefined, 281];

for (let i = 1; i < 2; i++) {
  const number = i < 10 ? `0${i}` : `${i}`;
  const day: Day<unknown> = (await import(`./day_${number}.ts`)).default;

  Deno.test({
    name: `Day: ${i}. Part A`,
    fn: async () => {
      const generator = readFile(`test/day_${number}_a.txt`);
      const result = day.a.parser(generator).then(day.a.solver);
      assertEquals(await result, PART_A[i]);
    },
  });

  if (!day.b) continue;

  Deno.test({
    name: `Day: ${i}. Part B`,
    fn: async () => {
      const generator = readFile(`test/day_${number}_b.txt`);
      const day: Day<unknown> = (await import(`./day_${number}.ts`)).default;
      const result = day.b!.parser(generator).then(day.b!.solver);
      assertEquals(await result, PART_B[i]);
    },
  });
}
