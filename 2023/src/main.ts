import { Day, readFile } from "./common.ts";

if (import.meta.main) {
  if (Deno.args.length !== 1) {
    console.error("Please, provide only the day number as an argument");
    Deno.exit(1);
  }

  const number = Deno.args[0];
  const dayPromise = import(`./day_${number}.ts`);
  const generator = readFile(`input/day_${number}.txt`);

  const day: Day<unknown> = (await dayPromise).default;
  const result = day.a.parser(generator).then(day.a.solver);
  console.log(await result);
}
