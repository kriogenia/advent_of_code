import { assertEquals } from "@std/assert";
import { Day, readFile } from "./common.ts";

const TESTS: Test[] = [
  { a: 0, b: 0 },
  { a: 142, b: 281, dual: true },
  { a: 8, b: 2286 },
  { a: 4361, b: 467835 },
];

for (let i = 1; i < TESTS.length; i++) {
  const number = i < 10 ? `0${i}` : `${i}`;
  const day: Day<unknown> = (await import(`./day_${number}.ts`)).default;

  Deno.test({
    name: `Day: ${i}. Part A`,
    fn: async () => {
      const generator = readFile(`test/day_${number}.txt`);
      const result = day.a.parser(generator).then(day.a.solver);
      assertEquals(await result, TESTS[i].a);
    },
  });

  if (!day.b) continue;

  Deno.test({
    name: `Day: ${i}. Part B`,
    fn: async () => {
      const dual = TESTS[i]?.dual ? "_b" : "";
      const generator = readFile(`test/day_${number}${dual}.txt`);
      const day: Day<unknown> = (await import(`./day_${number}.ts`)).default;
      const result = day.b!.parser(generator).then(day.b!.solver);
      assertEquals(await result, TESTS[i].b);
    },
  });
}

interface Test {
  a: number;
  b: number;
  dual?: boolean;
}
